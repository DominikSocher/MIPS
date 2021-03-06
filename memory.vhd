-------------------------------------------------------------------------------
-- Title      : Device memory
-- Project    : 
-------------------------------------------------------------------------------
-- File       : memory.vhd
-- Author     :   <Dominik@DESKTOP-FIRPP3J>
-- Company    : 
-- Created    : 2022-01-27
-- Last update: 2022-01-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Instruction and data memroy
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-27  1.0      Dominik	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
  
  port (
    clk_in   : in  std_logic;                       -- system clock
    we_in    : in  std_logic;                       -- write enable
    addr_in  : in  std_logic_vector(7 downto 0);    -- 8-bit address vector
    data_in  : in  std_logic_vector(11 downto 0);   -- 8-bit data input
    data_out : out std_logic_vector(11 downto 0));  -- 12-bit data out

end entity memory;

architecture rtl of memory is

  type ram_t is array (0 to 255) of std_logic_vector(11 downto 0);  -- ram type 255 x 12
  signal ram_s : ram_t := (others => x"000");  -- initial values of RAM
  
begin  -- architecture rtl

  -- purpose: Data memory of CPU 
  -- type   : sequential
  -- inputs : clk_in, addr_in, data_in
  -- outputs: data_out
  ram_p: process (clk_in) is
  begin  -- process ram_p
    if clk_in'event and clk_in = '1' then  -- rising clock edge
      if we_in = '1' then
        ram_s(to_integer(unsigned(addr_in))) <= data_in;
      end if;
    end if;
  end process ram_p;

  data_out <= ram_s(to_integer(unsigned(addr_in)));

end architecture rtl;
