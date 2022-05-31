-------------------------------------------------------------------------------
-- Title      : Programcounter
-- Project    : 
-------------------------------------------------------------------------------
-- File       : programcounter.vhd
-- Author     :   <Dominik@DESKTOP-FIRPP3J>
-- Company    : 
-- Created    : 2022-01-19
-- Last update: 2022-01-19
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 8-bit program counter.
--      sel_in | Function 
--      -----------------------
--        00   | d_out <= d_out
--        01   | d_out + 1 
--        10   | d_out <= d_in
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-19  1.0      Dominik	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity programcounter is
  
  port (
    clk_in   : in  std_logic;                      -- clock input
    rst_n_in : in  std_logic;                      -- async reset active low
    sel_in   : in  std_logic_vector(1 downto 0) ;  -- 2-bit select
    d_in     : in  std_logic_vector(7 downto 0);   -- 8-bit data input
    d_out    : out std_logic_vector(7 downto 0));  -- 8-bit data output

end entity programcounter;

architecture rtl of programcounter is

  -----------------------------------------------------------------------------
  -- constant declaration
  -----------------------------------------------------------------------------
  constant null_v : std_logic_vector(7 downto 0) := x"00";  -- null vector
  constant max_v  : std_logic_vector(7 downto 0) := x"ff";  -- max vector
  -----------------------------------------------------------------------------
  -- signal declaration
  -----------------------------------------------------------------------------
  signal data_s : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data register
  
begin  -- architecture rtl

     -- purpose: 8bit programcounter. sel_in is controlvector
     -- type   : sequential
     -- inputs : clk_in, rst_n_in, data_s
     -- outputs: 
  pc_p: process (clk_in, rst_n_in) is
     begin  -- process pc_p
       if rst_n_in = '0' then           -- asynchronous reset (active low)
         data_s <= null_v;
       elsif clk_in'event and clk_in = '1' then  -- rising clock edge
         case sel_in is
           when "00" => data_s <= data_s;
           when "01" => data_s <= std_logic_vector(unsigned(data_s)+1);
           when "10" => data_s <= d_in;
           when others => null;
         end case;
         if data_s > max_v then
           data_s <= null_v;
         end if;
       end if;
     end process pc_p;   

end architecture rtl;
