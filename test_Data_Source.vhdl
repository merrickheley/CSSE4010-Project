--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:40:30 09/17/2013
-- Design Name:   
-- Module Name:   C:/Users/Merrick/Dropbox/UniCourses/CSSE4010/project/test_Data_Source.vhdl
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Data_Source
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
 
ENTITY test_Data_Source IS
END test_Data_Source;
 
ARCHITECTURE behavior OF test_Data_Source IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Source
    PORT(
         clk :  IN  std_logic;
         rst :  IN  std_logic;
         en :   IN  std_logic;
         out1 : OUT  std_logic_vector(3 downto 0);
         out2 : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';

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

      wait for clk_period*70;

      -- insert stimulus here 

      wait;
   end process;

END;
