// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// L2 cache functional / performance check.
//
// Sweeps a DRAM-resident array that is larger than the CVA6 L1 D-cache (32 KiB)
// but fits inside the L2, so every pass misses L1 and exercises the path below
// it. We time the sweep with the L2 in bypass (scratchpad) mode and again in
// cache mode; a working L2 makes the cached run markedly faster.
//
// Build and run the DRAM variant (e.g. l2_cache.dram.elf), since the L2 only
// caches the DRAM region (0x8000_0000+).

#include "regs/cheshire.h"
#include "dif/clint.h"
#include "dif/uart.h"
#include "params.h"
#include "util.h"
#include "l2.h"

// 64 KiB working set: exceeds the 32 KiB L1 D-cache, fits the default 128 KiB L2.
#define BUF_BYTES (64 * 1024)
#define BUF_LEN   (BUF_BYTES / sizeof(uint64_t))
#define SWEEPS    16

static volatile uint64_t buf[BUF_LEN];

static uint64_t sweep(void) {
    uint64_t acc = 0;
    for (int s = 0; s < SWEEPS; s++)
        for (uint64_t i = 0; i < BUF_LEN; i++) acc += buf[i];
    return acc;
}

static void put_str(const char *s) {
    uint64_t n = 0;
    while (s[n]) n++;
    uart_write_str(&__base_uart, (void *)s, n);
}

static void put_hex64(uint64_t v) {
    char s[19] = "0x0000000000000000";
    for (int i = 0; i < 16; i++) {
        s[18 - i] = "0123456789abcdef"[v & 0xF];
        v >>= 4;
    }
    uart_write_str(&__base_uart, s, 18);
}

int main(void) {
    uint32_t rtc_freq = *reg32(&__base_regs, CHESHIRE_RTC_FREQ_REG_OFFSET);
    uint64_t core_freq = clint_get_core_freq(rtc_freq, 2500);
    uart_init(&__base_uart, core_freq, __BOOT_BAUDRATE);

    for (uint64_t i = 0; i < BUF_LEN; i++) buf[i] = i;
    fence();

    // Baseline: L2 in bypass (scratchpad) mode -> L1 misses go straight to DRAM.
    l2_cache_disable();
    fence();
    uint64_t t0 = get_mcycle();
    volatile uint64_t r_off = sweep();
    uint64_t t1 = get_mcycle();

    // L2 in cache mode. Warm it once, then time the steady-state sweep.
    l2_cache_enable();
    (void)sweep();
    fence();
    uint64_t t2 = get_mcycle();
    volatile uint64_t r_on = sweep();
    uint64_t t3 = get_mcycle();

    (void)r_off;
    (void)r_on;

    put_str("L2 bypass cycles: "); put_hex64(t1 - t0); put_str("\r\n");
    put_str("L2 cache  cycles: "); put_hex64(t3 - t2); put_str("\r\n");
    uart_write_flush(&__base_uart);

    // Leave the L2 enabled for whatever runs next.
    return 0;
}
