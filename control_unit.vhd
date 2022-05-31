-------------------------------------------------------------------------------
-- Title      : Control Unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : control_unit.vhd
-- Author     : Dominik Socher
-- Company    : Digitaltechnik Socher
-- Created    : 2022-01-24
-- Last update: 2022-01-28
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Control unit for CPU
--      instruction  Table:
--             inst | descripton
--             0000 | NOP
--             0001 | pc+1
--             0010 | jump
-------------------------------------------------------------------------------
-- Copyright (c) 2022 Digitaltechnik Socher
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-24  1.0      Dominik	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity control_unit  is
  
  port (
    clk_in       : in  std_logic;                      -- system clock
    rst_n_in     : in  std_logic;                      -- async reset active low
    ce_in        : in  std_logic;                      -- chip enable
    data_bus_in  : in  std_logic_vector(11 downto 0);  -- 12 bit data bus
    addr_bus_out : out std_logic_vector(7  downto 0);  -- 8-bit address bus
    data_bus_out : out std_logic_vector(7  downto 0);  -- 8-bit data output
    inst_bus_out : out std_logic_vector(19 downto 0)); -- 4-bit instruction bus

end entity control_unit ;

architecture rtl of control_unit is
-------------------------------------------------------------------------------
-- CPU opcodes
-------------------------------------------------------------------------------
  type op_t is (NO,IF1, IF2, IF3, ID1, ID2, DF1, DF2, EX); -- Machine states
  signal OPCODE : op_t;                                   -- OPCODE vector

-------------------------------------------------------------------------------
-- Instruction opcodes
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
  signal instr_reg_s : std_logic_vector(3  downto 0) := x"0";      -- instruction data register
  signal data_reg_s  : std_logic_vector(7  downto 0) := x"00";     -- 8-bit date register
  signal instr_bus_s : std_logic_vector(19 downto 0) := X"00000";  -- 20-bit instruction bus
 
  
begin  -- architecture rtl

  -- purpose: Main statemachine of 8-bit CPU
  -- type   : sequential
  -- inputs : clk_in, rst_n_in, data_bus_in, ce_in
  -- outputs: addr_bus_out, inst_bus_out, data_bus_out
  CPU: process (clk_in, rst_n_in) is
  begin  -- process CPU
    if rst_n_in = '0' then              -- asynchronous reset (active low)
      OPCODE      <= NO;
      instr_reg_s <= (others => '0');
      instr_bus_s <= (others => '0');
      data_reg_s  <= (others => '0');
    elsif clk_in'event and clk_in = '1' then  -- rising clock edge
      case OPCODE is
        when NO =>
          if ce_in = '0' then
            OPCODE <= NO;
          elsif ce_in = '1' then
            OPCODE <= IF1;      
          end if;
        when IF1 =>
          OPCODE <= IF2;                -- starting
        when IF2 =>
          OPCODE <= IF3;                --syncornise
        when IF3 =>
          instr_reg_s <= data_bus_in(3 downto 0);  -- load data to internal
                                                   -- instruction register.
          data_reg_s  <= data_bus_in(11 downto 4); -- load data to internal
                                                   -- data register.
          OPCODE      <= ID1;
        when ID1 =>
          OPCODE <= ID2;
        when ID2 =>
          case instr_reg_s is
            when "0000"  =>
              OPCODE <= IF1;
            when "0001"  =>
              OPCODE <= IF1;
            when others => null;
          end case;
        when others => null;
      end case;
      
    end if;
  end process CPU;


  

end architecture rtl ;
