// Copyright 2024 ETH Zurich and University of Bologna.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// Control helpers for the L2 cache (an axi_llc instance at __base_l2).
//
// At reset the axi_llc-based L2 brings up *every* way as scratchpad (SPM).
// While a way is SPM it is excluded from the cache, so accesses to the cached
// (DRAM) region take the bypass path and reach memory uncached. Until software
// converts ways to cache mode the L2 therefore provides no caching at all.
// These helpers flip the way configuration so the L2 actually caches DRAM.

#pragma once

#include <stdint.h>
#include "util.h"
#include "params.h"
#include "regs/axi_llc.h"

// Block until the tag-RAM BIST has completed. Config writes issued before this
// are overwritten by the BIST result, so we must gate on it.
static inline void __l2_wait_bist(void) {
    while (!(*reg32(&__base_l2, AXI_LLC_BIST_STATUS_REG_OFFSET) &
             (1u << AXI_LLC_BIST_STATUS_DONE_BIT)))
        ;
}

// Mask of physically instantiated ways (set-associativity is small, so the
// low word always suffices for realistic configurations).
static inline uint32_t __l2_way_mask(void) {
    uint32_t assoc = *reg32(&__base_l2, AXI_LLC_SET_ASSO_LOW_REG_OFFSET);
    return (assoc >= 32) ? 0xFFFFFFFFu : ((1u << assoc) - 1u);
}

// Configure all ways as cache and commit, so the L2 caches the DRAM region.
static inline void l2_cache_enable(void) {
    __l2_wait_bist();
    // SPM mask: 1 = way is scratchpad, 0 = way is cache. Clear it for all ways.
    *reg32(&__base_l2, AXI_LLC_CFG_SPM_LOW_REG_OFFSET)  = 0;
    *reg32(&__base_l2, AXI_LLC_CFG_SPM_HIGH_REG_OFFSET) = 0;
    *reg32(&__base_l2, AXI_LLC_COMMIT_CFG_REG_OFFSET)   = 1;
    // The commit (de)flushes the affected ways; for an SPM->cache switch nothing
    // needs eviction, so the FLUSHED flags simply clear once it is applied.
    while (*reg32(&__base_l2, AXI_LLC_FLUSHED_LOW_REG_OFFSET) |
           *reg32(&__base_l2, AXI_LLC_FLUSHED_HIGH_REG_OFFSET))
        ;
}

// Configure all ways as scratchpad and commit, flushing any dirty lines back to
// memory. This restores pure bypass behaviour (useful for A/B comparisons).
static inline void l2_cache_disable(void) {
    __l2_wait_bist();
    uint32_t mask = __l2_way_mask();
    *reg32(&__base_l2, AXI_LLC_CFG_SPM_LOW_REG_OFFSET)  = mask;
    *reg32(&__base_l2, AXI_LLC_CFG_SPM_HIGH_REG_OFFSET) = 0;
    *reg32(&__base_l2, AXI_LLC_COMMIT_CFG_REG_OFFSET)   = 1;
    // Done once every way reports flushed (i.e. has become scratchpad again).
    while ((*reg32(&__base_l2, AXI_LLC_FLUSHED_LOW_REG_OFFSET) & mask) != mask)
        ;
}
