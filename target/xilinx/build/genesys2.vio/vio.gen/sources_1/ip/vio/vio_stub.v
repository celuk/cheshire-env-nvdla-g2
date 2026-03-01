// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
// Date        : Sat Feb 28 21:45:09 2026
// Host        : ECIT01684 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/2640084/Desktop/ubuntu/shared/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.vio/vio.gen/sources_1/ip/vio/vio_stub.v
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
