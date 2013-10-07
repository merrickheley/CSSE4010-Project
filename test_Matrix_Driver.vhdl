--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:03:34 10/08/2013
-- Design Name:   
-- Module Name:   C:/Users/Merrick/Dropbox/UniCourses/CSSE4010/project/test_Matrix_Driver.vhdl
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Matrix_Driver
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
 
ENTITY test_Matrix_Driver IS
END test_Matrix_Driver;
 
ARCHITECTURE behavior OF test_Matrix_Driver IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Matrix_Driver
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic_vector(1 downto 0);
         data_source : IN  std_logic_vector(3 downto 0);
         data_sink : IN  std_logic_vector(3 downto 0);
         led_matrix : OUT  std_logic_vector(15 downto 0);
         row_select : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic_vector(1 downto 0) := (others => '0');
   signal data_source : std_logic_vector(3 downto 0) := (others => '0');
   signal data_sink : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal led_matrix : std_logic_vector(15 downto 0);
   signal row_select : std_logic_vector(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Matrix_Driver PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          data_source => data_source,
          data_sink => data_sink,
          led_matrix => led_matrix,
          row_select => row_select
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
      rst <= '1';
      en <= "00";
      wait for clk_period*10;
      rst <= '0';
      en <= "10";

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
