--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:21:55 09/23/2013
-- Design Name:   
-- Module Name:   C:/Users/Merrick/Dropbox/UniCourses/CSSE4010/project/test_Transmitter_Controller.vhdl
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Transmitter_Controller
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
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
