set_property SRC_FILE_INFO {cfile:/home/shc/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.cheshire/cheshire.srcs/constrs_1/imports/constraints/cheshire.xdc rfile:../../../cheshire.srcs/constrs_1/imports/constraints/cheshire.xdc id:1} [current_design]
set_property SRC_FILE_INFO {cfile:/home/shc/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.cheshire/cheshire.srcs/constrs_1/imports/constraints/genesys2.xdc rfile:../../../cheshire.srcs/constrs_1/imports/constraints/genesys2.xdc id:2} [current_design]
set_property src_info {type:XDC file:1 line:36 export:INPUT save:INPUT read:READ} [current_design]
set_input_jitter clk_jtag 1.000
set_property src_info {type:XDC file:1 line:48 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -from [get_ports jtag_trst_ni]
set_property src_info {type:XDC file:1 line:58 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -from [get_ports uart_rx_i]
set_property src_info {type:XDC file:1 line:61 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -to [get_ports uart_tx_o]
set_property src_info {type:XDC file:1 line:70 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -through [get_pins -of_objects [get_cells -hier -filter {ORIG_REF_NAME=="sync" || REF_NAME=="sync"}] -filter {NAME=~*serial_i}]
set_property src_info {type:XDC file:1 line:73 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -through [get_pins -of_objects [get_cells -hier -filter {ORIG_REF_NAME == axi_cdc_src || REF_NAME == axi_cdc_src}] -filter {NAME =~ *async*}]
set_property src_info {type:XDC file:1 line:75 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -through [get_pins -of_objects [get_cells -hier -filter {ORIG_REF_NAME == axi_cdc_dst || REF_NAME == axi_cdc_dst}] -filter {NAME =~ *async*}]
set_property src_info {type:XDC file:2 line:53 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -setup -through [get_pins i_dram_wrapper/i_dram/aresetn]
set_property src_info {type:XDC file:2 line:57 export:INPUT save:INPUT read:READ} [current_design]
set_false_path -hold -through [get_pins i_dram_wrapper/i_dram/ui_clk_sync_rst]
set_property src_info {type:XDC file:2 line:62 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -datapath_only -from [get_pins i_dram_wrapper/gen_cdc.i_axi_cdc_mig/i_axi_cdc_*/i_cdc_fifo_gray_*/*reg*/C] -to [get_pins i_dram_wrapper/gen_cdc.i_axi_cdc_mig/i_axi_cdc_*/i_cdc_fifo_gray_*/*i_sync/reg*/D] 5
set_property src_info {type:XDC file:2 line:65 export:INPUT save:INPUT read:READ} [current_design]
set_max_delay -datapath_only -from [get_pins i_dram_wrapper/gen_cdc.i_axi_cdc_mig/i_axi_cdc_*/i_cdc_fifo_gray_*/*reg*/C] -to [get_pins i_dram_wrapper/gen_cdc.i_axi_cdc_mig/i_axi_cdc_*/i_cdc_fifo_gray_*/i_spill_register/spill_register_flushable_i/*reg*/D] 5
set_property src_info {type:XDC file:2 line:129 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN AD11  IOSTANDARD LVDS     } [get_ports { sys_clk_n }]; #IO_L12N_T1_MRCC_33 Sch=sysclk_n
set_property src_info {type:XDC file:2 line:130 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN AD12  IOSTANDARD LVDS     } [get_ports { sys_clk_p }]; #IO_L12P_T1_MRCC_33 Sch=sysclk_p
set_property src_info {type:XDC file:2 line:133 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { sys_resetn }]; #IO_0_14 Sch=cpu_resetn
set_property src_info {type:XDC file:2 line:145 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN Y23   IOSTANDARD LVCMOS33 } [get_ports { uart_tx_o }]; #IO_L1P_T0_12 Sch=uart_rx_out
set_property src_info {type:XDC file:2 line:146 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN Y20   IOSTANDARD LVCMOS33 } [get_ports { uart_rx_i }]; #IO_0_12 Sch=uart_tx_in
set_property src_info {type:XDC file:2 line:193 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN AD27  IOSTANDARD LVCMOS33 } [get_ports { jtag_tck_i }]; #IO_L11P_T1_SRCC_13 Sch=prog_d0/sck
set_property src_info {type:XDC file:2 line:194 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W27   IOSTANDARD LVCMOS33 } [get_ports { jtag_tdi_i }]; #IO_L2P_T0_13 Sch=prog_d1/mosi
set_property src_info {type:XDC file:2 line:195 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W28   IOSTANDARD LVCMOS33 } [get_ports { jtag_tdo_o }]; #IO_L2N_T0_13 Sch=prog_d2/miso
set_property src_info {type:XDC file:2 line:196 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN W29   IOSTANDARD LVCMOS33 } [get_ports { jtag_tms_i }]; #IO_L4P_T0_13 Sch=prog_d3/ss
set_property src_info {type:XDC file:2 line:197 export:INPUT save:INPUT read:READ} [current_design]
set_property -dict { PACKAGE_PIN Y29   IOSTANDARD LVCMOS33 } [get_ports { jtag_trst_ni }]; #IO_L4N_T0_13 Sch=prog_d[4]
