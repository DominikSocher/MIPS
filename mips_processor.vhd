-------------------------------------------------------------------------------
-- Title      : MIPS Processor
-- Project    : 
-------------------------------------------------------------------------------
-- File       : Vhdl1.vhd
-- Author     : Domink Socher
-- Company    : Digitaltechnik Socher
-- Created    : 2022-01-19
-- Last update: 2022-01-28
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Head file of a simple 8-bit MIPS processor.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-19  1.0      Dominik	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity mips_processor is
  
  port (
    clk_in   : in std_logic;            -- system clock
    rst_n_in : in std_logic);           -- async reset active low

end entity mips_processor;

architecture rtl of mips_processor is
-------------------------------------------------------------------------------
-- signal declaration
-------------------------------------------------------------------------------
  signal addr_s  : std_logic_vector(7  downto 0) := x"00";    -- 8-bit address bus
  signal data_s  : std_logic_vector(11 downto 0) := x"000";   -- 12-bit data bus
  signal op_d_s  : std_logic_vector(7  downto 0) := x"00";    -- 8-bit data output op unit
  signal ram_d_s : std_logic_vector(11 downto 0) := x"000";   -- 12-bit data ram data input
  signal instr_s : std_logic_vector(19 downto 0) := x"00000"; -- 12-bit instruction bus
-------------------------------------------------------------------------------
-- component declaration
-------------------------------------------------------------------------------
  component op_unit is
    port (
      clk_in      : in  std_logic;                      -- system clock
      rst_n_in    : in  std_logic;                      -- async reset active low
      instruct_in : in  std_logic_vector(19 downto 0);  -- Instruction vector
      data_in     : in  std_logic_vector(7  downto 0);  -- 8-bit data input
      status_out  : out std_logic_vector(7  downto 0);  -- 8-bit status vector
      adr_reg_out : out std_logic_vector(7  downto 0);  -- 8-bit address register
      data_out    : out std_logic_vector(7  downto 0)); -- 8-bit data output
  end component op_unit;
-------------------------------------------------------------------------------
  component control_unit is
     port (
       clk_in       : in  std_logic;                      -- system clock
       rst_n_in     : in  std_logic;                      -- async reset active low
       data_bus_in  : in  std_logic_vector(11 downto 0);  -- 12 bit data bus
       addr_bus_out : out std_logic_vector(7 downto 0);   -- 8-bit address bus
       inst_bus_out : out std_logic_vector(19 downto 0)); -- 12-bit instruction bus
  end component control_unit;
-------------------------------------------------------------------------------
  component memory is
    port (
      clk_in   : in  std_logic;                       -- system clock
      we_in    : in  std_logic;                       -- write enable
      addr_in  : in  std_logic_vector(7 downto 0);    -- 8-bit address vector
      data_in  : in  std_logic_vector(11 downto 0);   -- 8-bit data input
      data_out : out std_logic_vector(11 downto 0));  -- 12-bit data out
  end component memory;
-------------------------------------------------------------------------------
  
begin  -- architecture rtl

-------------------------------------------------------------------------------
-- combinatorical logic
-------------------------------------------------------------------------------
  ram_d_s <= op_d_s & x"0";
  
-------------------------------------------------------------------------------
-- component instansiation
-------------------------------------------------------------------------------
  op_inst : op_unit
    port map (
      clk_in      => clk_in,                    -- system clock
      rst_n_in    => rst_n_in,                  -- async reset active low
      instruct_in => instr_s,                   -- Instruction vector
      data_in     => x"00",                     -- 8-bit data input
      status_out  => open,                      -- 8-bit status vector
      adr_reg_out => addr_s,                    -- 8-bit address register
      data_out    => op_d_s);                   -- 8-bit data output
-------------------------------------------------------------------------------
  control_inst : control_unit
    port map (
      clk_in       => clk_in,                   -- system clock
      rst_n_in     => rst_n_in,                 -- async reset active low
      data_bus_in  => data_s,                   -- 12 bit data bus
      addr_bus_out => open,                     -- 8-bit address bus
      inst_bus_out => instr_s);                 -- 4-bit instruction bus
-------------------------------------------------------------------------------                                                
  ram_inst : memory
    port map (
      clk_in   => clk_in,                       -- system clock
      we_in    => '0',                          -- write enable
      addr_in  => addr_s,                       -- 8-bit address vector
      data_in  => ram_d_s,                      -- 12-bit data input
      data_out => data_s);                      -- 12-bit data out

  

end architecture rtl;
