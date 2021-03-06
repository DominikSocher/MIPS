-------------------------------------------------------------------------------
-- Title      : 8x8-bit register file
-- Project    : 
-------------------------------------------------------------------------------
-- File       : register.vhd
-- Author     :   <Dominik@DESKTOP-FIRPP3J>
-- Company    : 
-- Created    : 2022-01-19
-- Last update: 2022-01-27
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Register holds 8x 8-bit register.
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-19  1.0      Dominik	Created
-- 2022-01-26  1.1      Dominik change of internal structure
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_8_bit is
  
  port (
    clk_in   : in  std_logic;                      -- system clock
    rst_n_in : in  std_logic;                      -- async reset active low
    ce_in    : in  std_logic;                      -- chip selcet
    we_in    : in  std_logic;                      -- write enable 
    sel_a    : in  std_logic_vector(2 downto 0);   -- output register a select
    sel_b    : in  std_logic_vector(2 downto 0);   -- outpur register b select
    sel_d    : in  std_logic_vector(2 downto 0);   -- input  register selcet
    d_in     : in  std_logic_vector(7 downto 0);   -- 8-bit data input
    da_out   : out std_logic_vector(7 downto 0);   -- 8-bit data output a
    db_out   : out std_logic_vector(7 downto 0));  -- 8-bit data output b 

end entity register_8_bit;

architecture rtl of register_8_bit is

  -----------------------------------------------------------------------------
  -- type delcaration for 8x8bit array as register file
  -----------------------------------------------------------------------------
  type register_t  is array (0 to 7) of std_logic_vector(7 downto 0);   -- 8x8-bit array as register file
  signal register_s : register_t := (others => x"00");                -- signal to hold current register
  
  
begin  -- architecture rtl
  
       -- purpose: 8x8bit register file
       -- type   : sequential
       -- inputs : clk_in, rst_n_in, d_in, we_in
       -- outputs: da_out, db_out
  register_p: process (clk_in, rst_n_in) is
       begin  -- process register_p
         if rst_n_in = '0' then         -- asynchronous reset (active low)
           register_s <= (others => x"00");
           da_out     <= (others => '0');
           db_out     <= (others => '0');
         elsif clk_in'event and clk_in = '1' then  -- rising clock edge
           if ce_in = '1' then
             da_out <= register_s(to_integer(unsigned(sel_a)));
             db_out <= register_s(to_integer(unsigned(sel_b)));
             if we_in = '1' then
               register_s(to_integer(unsigned(sel_d))) <= d_in;
             end if;
           end if;
         end if;
       end process register_p;     

end architecture rtl;
