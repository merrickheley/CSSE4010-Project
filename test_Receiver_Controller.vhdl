-------------------------------------------------------------------------------
-- CSSE4010 Project
-- Simple Communication System
--
-- Merrick Heley
-- 2013-10-08 
-- 
-- This system implements a communication system between two Nexus 2 FPGA 
-- boards, that sends a 64 character message from one system to the other 
-- using a hamming and manchester coded message.
--
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test_Receiver_Controller IS
END test_Receiver_Controller;
 
ARCHITECTURE behavior OF test_Receiver_Controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Receiver_Controller
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en_dec : OUT  std_logic;
         display : OUT  std_logic_vector(5 downto 0);
         start_display : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal start_display : std_logic := '0';

 	--Outputs
   signal en_dec : std_logic;
   signal display : std_logic_vector(5 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Receiver_Controller PORT MAP (
          clk => clk,
          rst => rst,
          en_dec => en_dec,
          display => display,
          start_display => start_display
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

      rst <= '1';
      wait for clk_period*10;
      rst <= '0';
    
      start_display <= '1';
      wait for clk_period;

      wait for clk_period*100;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
