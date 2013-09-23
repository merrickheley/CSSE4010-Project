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
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_Transmitter_Controller IS
END test_Transmitter_Controller;
 
ARCHITECTURE behavior OF test_Transmitter_Controller IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Transmitter_Controller
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         st_Transmit : IN  std_logic;
         st_Disp : IN  std_logic;
         en_Data : OUT  std_logic;
         en_Enc : OUT  std_logic;
         en_Enc2 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal st_Transmit : std_logic := '0';
   signal st_Disp : std_logic := '0';

 	--Outputs
   signal en_Data : std_logic;
   signal en_Enc : std_logic;
   signal en_Enc2 : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Transmitter_Controller PORT MAP (
          clk => clk,
          rst => rst,
          st_Transmit => st_Transmit,
          st_Disp => st_Disp,
          en_Data => en_Data,
          en_Enc => en_Enc,
          en_Enc2 => en_Enc2
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
      
      wait for clk_period*5;
      
      rst <= '0';

      wait for clk_period*10;
      
      st_Transmit <= '1';
      
      wait for clk_period;
      
      st_Transmit <= '0';
      
      wait for clk_period*65;

      -- insert stimulus here 

      wait;
   end process;

END;
