-------------------------------------------------------------------------------
-- Title      : Operational Unit
-- Project    : 
-------------------------------------------------------------------------------
-- File       : op_unit.vhd
-- Author     :   <Dominik@DESKTOP-FIRPP3J>
-- Company    : 
-- Created    : 2022-01-27
-- Last update: 2022-01-28
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Unit contains: Akkumulator, ALU, Register and PC
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2022-01-27  1.0      Dominik	Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity op_unit is
  
  port (
    clk_in      : in  std_logic;                      -- system clock
    rst_n_in    : in  std_logic;                      -- async reset active low
    instruct_in : in  std_logic_vector(19 downto 0);  -- Instruction vector
    data_in     : in  std_logic_vector(7  downto 0);  -- 8-bit data input
    status_out  : out std_logic_vector(7  downto 0);  -- 8-bit status vector
    adr_reg_out : out std_logic_vector(7  downto 0);  -- 8-bit address register
    data_out    : out std_logic_vector(7  downto 0)); -- 8-bit data output

end entity op_unit;

architecture rlt  of op_unit is
-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------------
   component programcounter is
    port (
      clk_in   : in  std_logic;                      -- clock input
      rst_n_in : in  std_logic;                      -- async reset active low
      sel_in   : in  std_logic_vector(1 downto 0) ;  -- 2-bit select
      d_in     : in  std_logic_vector(7 downto 0);   -- 8-bit data input
      d_out    : out std_logic_vector(7 downto 0));  -- 8-bit data output
  end component programcounter;
-------------------------------------------------------------------------------
  component register_8_bit is
    port (
      clk_in   : in  std_logic;                     -- system clock
      rst_n_in : in  std_logic;                     -- async reset active low
      ce_in    : in  std_logic;                     -- chip select
      we_in    : in  std_logic;                     -- write enable
      sel_a    : in  std_logic_vector(2 downto 0);  -- output register a select
      sel_b    : in  std_logic_vector(2 downto 0);  -- output register b selcect
      sel_d    : in  std_logic_vector(2 downto 0);  -- input register select
      d_in     : in  std_logic_vector(7 downto 0);  -- 8-bit data input
      da_out   : out std_logic_vector(7 downto 0);  -- 8-bit data output a
      db_out   : out std_logic_vector(7 downto 0)); -- 8-bit data output d
  end component register_8_bit;
-------------------------------------------------------------------------------
-- Signal declaration
-------------------------------------------------------------------------------
    signal pc_d_s   : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data signal for programcounter
    signal pc_q_s   : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data output of programcounter
    signal reg_d_s  : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data input for registers
    signal rega_q_s : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data output for registers
    signal regb_q_s : std_logic_vector(7 downto 0) := x"00";  -- 8-bit data output for registers
   

 begin  -- architecture rlt
-------------------------------------------------------------------------------
-- combinatorical logic
-------------------------------------------------------------------------------
  -- purpose: demultiplexer 2:1
  -- type   : combinational
  -- inputs : data_in, instruct(2)
  -- outputs: pc_data,reg_data
  dmux: process (data_in, instruct_in(2)) is
  begin  -- process dmux
    case instruct_in(2) is
      when '0' => pc_d_s  <= data_in;
      when '1' => reg_d_s <= data_in;
      when others => null;
    end case;
    
  end process dmux;

  -- purpose: multiplexer 1:2
  -- type   : combinational
  -- inputs : pc_q_s, rega_q_s, instruct(3)
  -- outputs: output_register_out
  mux: process (pc_q_s, rega_q_s, instruct_in(4 downto 3)) is
  begin  -- process mux
    case instruct_in(4 downto 3) is
      when "00" => data_out <= pc_q_s;
      when "01" => data_out <= rega_q_s;
      when "10" => data_out <= regb_q_s;             
      when others => null;
    end case;
        
  end process mux;
-------------------------------------------------------------------------------
-- component instansiation
-------------------------------------------------------------------------------
  pc_inst : programcounter
    port map (
      clk_in   => clk_in,                      -- clock input
      rst_n_in => rst_n_in,                    -- async reset active low
      sel_in   => instruct_in(1 downto 0),      -- 2-bit select
      d_in     => pc_d_s,                      -- 8-bit data input
      d_out    => pc_q_s);                     -- 8-bit data output
-------------------------------------------------------------------------------
  reg_inst : register_8_bit 
    port map(
      clk_in   => clk_in,                      -- system clock
      rst_n_in => rst_n_in,                    -- async reset active low
      ce_in    => instruct_in(5),              -- chip select
      we_in    => instruct_in(6),              -- write enable
      sel_a    => instruct_in(9 downto 7),     -- output register a select
      sel_b    => instruct_in(12 downto 10),   -- output register b selcect
      sel_d    => instruct_in(15 downto 13),   -- input register select
      d_in     => reg_d_s,                     -- 8-bit data input
      da_out   => rega_q_s,                    -- 8-bit data output a
      db_out   => regb_q_s);                   -- 8-bit data output d
-------------------------------------------------------------------------------


  

end architecture rlt ;
