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
         ssegAnode :         out STD_LOGIC_VECTOR (3 downto 0);  -- 7seg output
         ssegCathode :       out STD_LOGIC_VECTOR (7 downto 0);  -- 7seg output
         slideSwitches :     in  STD_LOGIC_VECTOR (7 downto 0);  -- Slide switches input
         pushButtons :       in  STD_LOGIC_VECTOR (3 downto 0);  -- Push button input
         LEDs :              out STD_LOGIC_VECTOR (7 downto 0);  -- LED's on the board
         clk50mhz :          in  STD_LOGIC;                      -- 50mhz system clock
         logic_analyzer :    out STD_LOGIC_VECTOR (6 downto 0);  -- Output for the logic analyser
         input :             in  STD_LOGIC;                      -- Input for the manchester demodulator
         row_select :        out STD_LOGIC_VECTOR (2 downto 0);  -- Row select for the matrix driver
         led_matrix :        out STD_LOGIC_VECTOR (14 downto 0)  -- Matrix output for the row
        );
    END COMPONENT;
    

   --Inputs
   signal slideSwitches : std_logic_vector(7 downto 0) := (others => '0');
   signal pushButtons : std_logic_vector(3 downto 0) := (others => '0');
   signal clk50mhz : std_logic := '0';
   signal input : std_logic;
   
 	--Outputs
   signal ssegAnode : std_logic_vector(3 downto 0);
   signal ssegCathode : std_logic_vector(7 downto 0);
   signal LEDs : std_logic_vector(7 downto 0);
   signal logic_analyzer : std_logic_vector(6 downto 0);

   signal row_select : std_logic_vector(2 downto 0);
   signal led_matrix : std_logic_vector(14 downto 0);

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
          logic_analyzer => logic_analyzer,
          input => input,
          row_select => row_select,
          led_matrix => led_matrix
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
      
      wait for clk50mhz_period*1000;
      
      pushButtons(3) <= '0';
      
      wait for clk50mhz_period*10;
      
      pushButtons(0) <= '1';

      wait for clk50mhz_period*100;
      
      -- pushButtons(0) <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
