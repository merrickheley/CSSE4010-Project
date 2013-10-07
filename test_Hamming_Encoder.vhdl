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
 
ENTITY test_Hamming_Encoder IS
END test_Hamming_Encoder;
 
ARCHITECTURE behavior OF test_Hamming_Encoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Hamming_Encoder
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         input : IN  std_logic_vector(3 downto 0);
         err : IN  std_logic_vector(7 downto 0);
         output : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal input : std_logic_vector(3 downto 0) := (others => '0');
   signal err : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Hamming_Encoder PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          input => input,
          err => err,
          output => output
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
      en <= '0';
      wait for clk_period*5;	
      rst <= '0';
      wait for clk_period*5;
      en <= '1';
      input <= "1111";
      err <= "00000000";
      wait for clk_period;
      assert(output = "11111111" ) report "Failed test 1" severity error;
      
      input <= "1111";
      err <= "01000000";
      
      wait for clk_period;
      assert(output = "10111111" ) report "Failed test 2" severity error;
      
      input <= "1001";
      err <= "00000000";
      
      wait for clk_period;
      assert(output = "10011001" ) report "Failed test 3" severity error;
        
      input <= "0010";
      err <= "00000000";       

      wait for clk_period;
      assert(output = "11010010" ) report "Failed test 4" severity error;

      -- insert stimulus here 

      wait;
   end process;

END;
