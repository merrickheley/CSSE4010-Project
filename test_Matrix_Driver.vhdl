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
 
ENTITY test_Matrix_Driver IS
END test_Matrix_Driver;
 
ARCHITECTURE behavior OF test_Matrix_Driver IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Matrix_Driver
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         data_source : IN  std_logic_vector(3 downto 0);
         data_source_err : IN  std_logic_vector(7 downto 0);
         data_sink : IN  std_logic_vector(3 downto 0);
         data_sink_err : IN  std_logic_vector(7 downto 0);
         valid_sink : IN  std_logic;
         led_matrix : OUT  std_logic_vector(14 downto 0);
         row_select : OUT  std_logic_vector(2 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal data_source : std_logic_vector(3 downto 0) := (others => '0');
   signal data_source_err : std_logic_vector(7 downto 0) := (others => '0');
   signal data_sink : std_logic_vector(3 downto 0) := (others => '0');
   signal data_sink_err : std_logic_vector(7 downto 0) := (others => '0');
   signal valid_sink : std_logic := '0';

 	--Outputs
   signal led_matrix : std_logic_vector(14 downto 0);
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
          data_source_err => data_source_err,
          data_sink => data_sink,
          data_sink_err => data_sink_err,
          valid_sink => valid_sink,
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
      wait for 100 ns;
      
      rst <= '1';
      en <= '1';
      wait for clk_period*10;
      rst <= '0';
      
      data_source <= "0001";
      data_source_err <= "00010101";
      data_sink <= "0110";
      data_sink_err <= "11000010";
      valid_sink <= '1';

      -- Wait while matrix displays data
      wait for clk_period*20;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
