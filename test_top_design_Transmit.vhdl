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
 
ENTITY test_top_design_transmit IS
END test_top_design_transmit;
 
ARCHITECTURE behavior OF test_top_design_transmit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_design
    PORT(
         ssegAnode : OUT  std_logic_vector(3 downto 0);
         ssegCathode : OUT  std_logic_vector(7 downto 0);
         slideSwitches : IN  std_logic_vector(7 downto 0);
         pushButtons : IN  std_logic_vector(3 downto 0);
         LEDs : OUT  std_logic_vector(7 downto 0);
         clk50mhz : IN  std_logic;
         logic_analyzer : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal slideSwitches : std_logic_vector(7 downto 0) := (others => '0');
   signal pushButtons : std_logic_vector(3 downto 0) := (others => '0');
   signal clk50mhz : std_logic := '0';

 	--Outputs
   signal ssegAnode : std_logic_vector(3 downto 0);
   signal ssegCathode : std_logic_vector(7 downto 0);
   signal LEDs : std_logic_vector(7 downto 0);
   signal logic_analyzer : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk50mhz_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_design PORT MAP (
          ssegAnode => ssegAnode,
          ssegCathode => ssegCathode,
          slideSwitches => slideSwitches,
          pushButtons => pushButtons,
          LEDs => LEDs,
          clk50mhz => clk50mhz,
          logic_analyzer => logic_analyzer
        );

   -- Clock process definitions
   clk50mhz_process :process
   begin
		clk50mhz <= '0';
		wait for clk50mhz_period/2;
		clk50mhz <= '1';
		wait for clk50mhz_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	
      
      slideSwitches <= "00000000";
      pushButtons <= "0000";

      wait for clk50mhz_period*10;
      
      pushButtons(3) <= '1';
      
      wait for clk50mhz_period*10;
      
      pushButtons(3) <= '0';
      
      wait for clk50mhz_period*10;
      
      pushButtons(0) <= '1';

      -- insert stimulus here 

      wait;
   end process;

END;
