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
use IEEE.Numeric_Std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_Source is
    Port ( clk :  in   STD_LOGIC;
           rst :  in   STD_LOGIC;
           en :   in   STD_LOGIC;
           out1 : out  STD_LOGIC_VECTOR (3 downto 0);
           out2 : out  STD_LOGIC_VECTOR (3 downto 0)
         );
         
    attribute RAM_STYLE : string;
    attribute RAM_STYLE of Data_Source: entity is "BLOCK" ;
end Data_Source;

architecture Behavioral of Data_Source is

-- This is a circular index for referencing data in the RAM array
signal index : std_logic_vector(5 downto 0) := "000000";

TYPE RAM_TYPE is array (0 to 63) of std_logic_vector (3 downto 0);
constant RAM : RAM_TYPE :=  (   "0000",
                                "0001",
                                "0010",
                                "0011",
                                "0100",
                                "0101",
                                "0110",
                                "0111",
                                "1000",
                                "1001",
                                "1010",
                                "1011",
                                "1100",
                                "1101",
                                "1110",
                                "1111",
                                "0000",
                                "0000",
                                "0000",
                                "0000",
                                "0100",
                                "0000",
                                "0011",
                                "1011",
                                "0110",
                                "0100",
                                "0001",
                                "1110",
                                "0110",
                                "1010",
                                "1000",
                                "1111",
                                "1110",
                                "0110",
                                "0111",
                                "0010",
                                "1001",
                                "1100",
                                "1110",
                                "0001",
                                "0110",
                                "1111",
                                "1110",
                                "0011",
                                "0000",
                                "0011",
                                "1110",
                                "0000",
                                "0111",
                                "0010",
                                "0000",
                                "1101",
                                "1010",
                                "0011",
                                "1000",
                                "0111",
                                "1110",
                                "1111",
                                "1000",
                                "1010",
                                "0110",
                                "1101",
                                "0000",
                                "0010");
                                
--attribute ram_style of RAM : signal is "MRAM";

begin
    
    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en, rst)
        variable input_var: integer range 0 to 63;
    BEGIN
        
        if (rst = '1') then
            index <= "000000";
        elsif clk'event and clk = '1' and en = '1' then
            input_var := conv_integer (index);
            out1 <= RAM(input_var);
            index <= index + '1';
        end if;

    END PROCESS;
    
end Behavioral;

