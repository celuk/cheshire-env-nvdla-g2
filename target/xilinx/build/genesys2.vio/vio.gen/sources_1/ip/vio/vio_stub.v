// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
// Date        : Fri Feb 27 21:15:59 2026
// Host        : karpuz running 64-bit Ubuntu 22.04.5 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/shc/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.vio/vio.gen/sources_1/ip/vio/vio_stub.v
// Design      : vio
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg900-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "vio,Vivado 2022.2" *)
module vio(clk, probe_out0, probe_out1, probe_out2)
/* synthesis syn_black_box black_box_pad_pin="clk,probe_out0[0:0],probe_out1[1:0],probe_out2[0:0]" */;
  input clk;
  output [0:0]probe_out0;
  output [1:0]probe_out1;
  output [0:0]probe_out2;
endmodule
