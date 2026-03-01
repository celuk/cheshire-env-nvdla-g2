-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (lin64) Build 3671981 Fri Oct 14 04:59:54 MDT 2022
-- Date        : Sun Mar  1 22:48:38 2026
-- Host        : karpuz running 64-bit Ubuntu 22.04.5 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/shc/projects/cheshire-env-nvdla-g2/target/xilinx/build/genesys2.clkwiz/clkwiz.gen/sources_1/ip/clkwiz/clkwiz_stub.vhdl
-- Design      : clkwiz
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg900-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clkwiz is
  Port ( 
    clk_50 : out STD_LOGIC;
    clk_48 : out STD_LOGIC;
    clk_20 : out STD_LOGIC;
    clk_10 : out STD_LOGIC;
    reset : in STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clkwiz;

architecture stub of clkwiz is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_50,clk_48,clk_20,clk_10,reset,locked,clk_in1";
begin
end;
