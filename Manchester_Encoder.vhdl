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

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Manchester_Encoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR(7 downto 0);
           outSig : out  STD_LOGIC);
end Manchester_Encoder;

architecture Behavioral of Manchester_Encoder is

shared variable count_var: integer range 0 to 7;

signal count : STD_LOGIC_VECTOR(2 downto 0) := "000";

begin

    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en)
    BEGIN
        
        if (rst = '1') then
            count <= "000";
        elsif clk'event and clk = '1' and en = '1' then         
            count <= count + '1';
            count_var := conv_integer (count);
        end if;
    END PROCESS;
    
    -- THIS IS LEAST SIGNIFICANT BIT FIRST
    -- USE 7-count_var for MOST SIGNIFICANT BIT
    outSig <= '1' WHEN rst = '1' or en = '0' ELSE not(input(count_var) XOR clk);

end Behavioral;

