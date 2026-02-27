-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2022.2 (win64) Build 3671981 Fri Oct 14 05:00:03 MDT 2022
-- Date        : Fri Feb 27 00:42:06 2026
-- Host        : ECIT01684 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/cheshire/target/xilinx/build/genesys2.clkwiz/clkwiz.gen/sources_1/ip/clkwiz/clkwiz_stub.vhdl
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
