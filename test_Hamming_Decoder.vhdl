-------------------------------------------------------------------------------
-- CSSE4010 Project
-- Simple Communication System
--
-- Merrick Heley
-- 2013-10-07
-- 
-- This system implements a communication system between two Nexus 2 FPGA 
-- boards, that sends a 64 character message from one system to the other 
-- using a hamming and manchester coded message.
--
-------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_Hamming_Decoder IS
END test_Hamming_Decoder;
 
ARCHITECTURE behavior OF test_Hamming_Decoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Hamming_Decoder
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         input : IN  std_logic_vector(7 downto 0);
         receive : OUT STD_LOGIC;
         decode_invalid : OUT STD_LOGIC;
         decoded : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    
    COMPONENT Hamming_Encoder
    PORT (
        clk : IN std_logic;
        rst : IN std_logic;
        en  : IN std_logic;
        input : in  STD_LOGIC_VECTOR (3 downto 0);
        err : in  STD_LOGIC_VECTOR (7 downto 0);
        output : out  STD_LOGIC_VECTOR (7 downto 0)
    );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal hammingencoded : std_logic_vector(7 downto 0) := (others => '0');
   
   signal input : std_logic_vector(3 downto 0) := (others => '0');
   signal err : std_logic_vector(7 downto 0) := (others => '0');

   --Outputs
   signal receive : std_logic;
   signal decode_invalid : std_logic;
   signal decoded : std_logic_vector(3 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Hamming_Decoder PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          input => hammingencoded,
          receive => receive,
          decode_invalid => decode_invalid,
          decoded => decoded
        );
        
    uut1 : Hamming_Encoder PORT MAP (
        clk => clk,
        rst => rst,
        en => en,
        input => input,
        err => err,
        output => hammingencoded
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
      rst <= '1';
      en <= '0';
      wait for clk_period*5;	
      rst <= '0';
      wait for clk_period*5;
      en <= '1';
      
      input <= "0000";
      err <= "00000000";
      
      -- Test all inputs with a single bit of error in all positions
      for I in 0 to 15 loop 
          for J in 0 to 7 loop
             wait for clk_period*2;
             assert(decoded = input and decode_invalid = '0') report "Failed test" severity error;
             err <= "00000000";
             err(J) <= '1';
           end loop;
          
          input <= input + '1';
      end loop;
      
      -- Test some inputs with double-bit of error, decode should be invalid
      input <= "0100";
      err <= "10001000";
      
      wait for clk_period*2;
      assert(decode_invalid = '1') report "Failed test" severity error;
              
      input <= "0100";
      err <= "00011000";
      
      wait for clk_period*2;
      assert(decode_invalid = '1') report "Failed test" severity error;

      wait for clk_period*10;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
