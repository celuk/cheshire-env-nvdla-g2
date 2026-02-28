// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Feb 27 21:15:23 2026
// Host        : karpuz running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/shc/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.clkwiz/clkwiz.gen/sources_1/ip/clkwiz/clkwiz_stub.v
// Design      : clkwiz
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clkwiz(clk_50, clk_48, clk_20, clk_10, reset, locked, 
  clk_in1)
/* synthesis syn_black_box black_box_pad_pin="clk_50,clk_48,clk_20,clk_10,reset,locked,clk_in1" */;
  output clk_50;
  output clk_48;
  output clk_20;
  output clk_10;
  input reset;
  output locked;
  input clk_in1;
endmodule
