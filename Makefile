# Copyright 2022 ETH Zurich and University of Bologna.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#
# Nicole Narr <narrn@student.ethz.ch>
# Christopher Reinwardt <creinwar@student.ethz.ch>
# Paul Scheffler <paulsc@iis.ee.ethz.ch>

CHS_ROOT := $(shell realpath .)
BENDER	 ?= bender -d $(CHS_ROOT)

all:

include cheshire.mk

# Locally, make Cheshire phonies available without `chs_` prefix
define chs_phony_fwd_rule
$(patsubst chs-%,%,$(1)): $(1)
endef

$(foreach phony,$(CHS_PHONY),$(eval $(call chs_phony_fwd_rule,$(phony))))

help:
	@echo "Possible phonies (may not all be implemented):"
	@$(foreach phony,$(sort $(CHS_PHONY)),echo '- $(patsubst chs-%,%,$(phony))';)

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))

.PHONY: jtag
jtag:
	/media/shc/0EDEBC4906059163/tools/riscv-openocd/src/openocd -f verification/jtag/debug_soc.cfg

PHONY: gdb
gdb:
	gdb-multiarch -ex "target remote :3333"

.PHONY: pico
pico:
	picocom -b 115200 /dev/ttyUSB$(ARGS) --imap lfcrlf
