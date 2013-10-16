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
 
ENTITY test_Data_Source IS
END test_Data_Source;
 
ARCHITECTURE behavior OF test_Data_Source IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Source
    PORT(
         clk :  IN  std_logic;
         rst :  IN  std_logic;
         en :   IN  std_logic;
         sel  : in   STD_LOGIC_VECTOR (5 downto 0);
         out1 : OUT  std_logic_vector(3 downto 0);
         out2 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal sel : std_logic_vector(5 downto 0) := "000000";

 	--Outputs
   signal out1 : std_logic_vector(3 downto 0);
   signal out2 : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Data_Source PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          sel => sel,
          out1 => out1,
          out2 => out2
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
      
      wait for 10 ns;
      
      en <= '1';
      rst <= '0';
     
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      -- Play through the data
      wait for clk_period*30;
      
      -- Manually read some data
      sel <= "000111";
      
      -- Continue playing data
      wait for clk_period*10;

      assert (out2 = "0111") report "Selection failed" severity error;

      wait for clk_period*10;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
