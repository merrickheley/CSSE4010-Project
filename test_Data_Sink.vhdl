-------------------------------------------------------------------------------
-- CSSE4010 Project
-- Simple Communication System
--
-- Merrick Heley
-- 2013-09-16 
-- 
-- This system implements a communication system between two Nexus 2 FPGA 
-- boards, that sends a 64 character message from one system to the other 
-- using a hamming and manchester coded message.
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.Numeric_Std.all; 
 
ENTITY test_Data_Sink IS
END test_Data_Sink;
 
ARCHITECTURE behavior OF test_Data_Sink IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Sink
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         input : IN  std_logic_vector(3 downto 0);
         input_err : IN  std_logic_vector(7 downto 0);
         input_val : IN  std_logic;
         read_ram : IN  std_logic_vector(5 downto 0);
         out1 : OUT  std_logic_vector(3 downto 0);
         out2 : OUT  std_logic_vector(7 downto 0);
         out3 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal input : std_logic_vector(3 downto 0) := (others => '0');
   signal input_err : std_logic_vector(7 downto 0) := (others => '0');
   signal input_val : std_logic := '0';
   signal read_ram : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal out1 : std_logic_vector(3 downto 0);
   signal out2 : std_logic_vector(7 downto 0);
   signal out3 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Data_Sink PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          input => input,
          input_err => input_err,
          input_val => input_val,
          read_ram => read_ram,
          out1 => out1,
          out2 => out2,
          out3 => out3
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;
      
      en <= '0';
      rst <= '1';
      
      -- Test a single write/read
      input <= "0001";
      input_err <= "00100100";
      input_val <= '0';

      wait for clk_period*10;
      
      rst <= '0';
      en <= '1';
      
      wait for clk_period;
      
      en <= '0';
      
      wait for clk_period;
      assert(out1 = input)     report "Failed test 1 - input"     severity error;
      assert(out2 = input_err) report "Failed test 1 - input_err" severity error;
      assert(out3 = input_val) report "Failed test 1 - input_val" severity error;
      
      -- Test a write/read at a later location
      input <= "0010";
      input_err <= "00100100";
      input_val <= '0';
      
      en <= '1';
      wait for clk_period*20;
      en <= '0';
      read_ram <= "001111";
      wait for clk_period;
      assert(out1 = input)     report "Failed test 2 - input"     severity error;
      assert(out2 = input_err) report "Failed test 2 - input_err" severity error;
      assert(out3 = input_val) report "Failed test 2 - input_val" severity error;
      
      wait for clk_period*10;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;