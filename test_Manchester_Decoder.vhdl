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

ENTITY test_Manchester_Decoder IS
END test_Manchester_Decoder;
 
ARCHITECTURE behavior OF test_Manchester_Decoder IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Manchester_Decoder
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         en : IN  std_logic;
         input : IN  std_logic;
         decode_valid : out STD_LOGIC;
         decoded : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal en : std_logic := '0';
   signal input : std_logic := '0';

 	--Outputs
   signal decode_valid : std_logic;
   signal decoded : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   
   -- Test data
   signal dataByte : std_logic_vector(7 downto 0);
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Manchester_Decoder PORT MAP (
          clk => clk,
          rst => rst,
          en => en,
          input => input,
          decode_valid => decode_valid,
          decoded => decoded
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
      input <= '1';

      wait for clk_period*10;
      rst <= '0';
      en <= '1';
      
      -- Simulate line noise
      wait for clk_period*10;
      input <= '0';
      wait for clk_period*1;
      input <= '1';

      dataByte <= "00000000";
      -- Send start byte
      for I in 0 to 7 loop
          wait for clk_period*10;
          input <= dataByte(I);
          wait for clk_period*10;
          input <= not(dataByte(I));
      end loop;
      
      dataByte <= "10110010";
      -- Send start byte
      for I in 0 to 7 loop
          wait for clk_period*10;
          input <= dataByte(I);
          wait for clk_period*10;
          input <= not(dataByte(I));
      end loop;
      
      dataByte <= "01001100";
      -- Send start byte
      for I in 0 to 7 loop
          wait for clk_period*10;
          input <= dataByte(I);
          wait for clk_period*10;
          input <= not(dataByte(I));
      end loop;
      dataByte <= "00000000";
    
        
      wait for clk_period*10;
      input <= '1';
      wait for clk_period*200;
      
      dataByte <= "00000000";
      -- Send start byte
      for I in 0 to 7 loop
          wait for clk_period*10;
          input <= dataByte(I);
          wait for clk_period*10;
          input <= not(dataByte(I));
      end loop;
      
      dataByte <= "00111101";
      -- Send start byte
      for I in 0 to 7 loop
          wait for clk_period*10;
          input <= dataByte(I);
          wait for clk_period*10;
          input <= not(dataByte(I));
      end loop;
      dataByte <= "00000000";
      
      wait for clk_period*10;
      input <= '1';
      
      wait for clk_period*10;
      assert false report "------------------ Test completed" severity failure;
      wait;
   end process;

END;
