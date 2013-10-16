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
   signal rst : std_logic := '1';
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
      input <= "00000000";
      wait for clk_period*8;
      
      en <= '1';
      wait for clk_period*16;
        
      en <= '0';
      
      wait for clk_period*10;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
