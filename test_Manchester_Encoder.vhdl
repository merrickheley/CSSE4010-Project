--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:07:24 09/17/2013
-- Design Name:   
-- Module Name:   C:/Users/Merrick/Dropbox/UniCourses/CSSE4010/project/test_Manchester_Encoder.vhdl
-- Project Name:  project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Manchester_Encoder
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
 
ENTITY test_Manchester_Encoder IS
END test_Manchester_Encoder;
 
ARCHITECTURE behavior OF test_Manchester_Encoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Manchester_Encoder
    PORT(
         clk    : IN  std_logic;
         rst    : IN  std_logic;
         en     : IN  std_logic;
         input  : IN  std_logic_vector(7 downto 0);
         outSig : OUT  std_logic;
         outBit : OUT  std_logic_VECTOR(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal input : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal outSig : std_logic;
   signal outBit : std_logic_VECTOR(2 downto 0);

   -- Clock period definitions
   constant clk_period : time := 50 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Manchester_Encoder PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          input => input,
          outSig => outSig,
          outBit => outBit
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
      
      -- Rising edge should be the start of the clock
      --wait for clk_period/2;
      
      rst <= '0';
      en <= '1';
      
      input <= "00000000";
      wait for clk_period*16;
      
      input <= "11111111";
      wait for clk_period*16;
      
      input <= "10110011";
      wait for clk_period*16;
            
      input <= "10101010";
      wait for clk_period*16;
      
      en <= '0';

      wait;
   end process;

END;
