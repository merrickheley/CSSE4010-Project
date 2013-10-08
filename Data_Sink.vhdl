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

entity Data_Sink is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (3 downto 0);
           input_err : in STD_LOGIC_VECTOR (7 downto 0);
           read_ram : in STD_LOGIC_VECTOR (5 downto 0);
           out1 : out  STD_LOGIC_VECTOR (3 downto 0);
           out2 : out  STD_LOGIC_VECTOR (7 downto 0));
           
    attribute RAM_STYLE : string;
    attribute RAM_STYLE of Data_Sink: entity is "BLOCK" ;
end Data_Sink;

architecture Behavioral of Data_Sink is

signal index : STD_LOGIC_VECTOR(5 downto 0) := "000000";

TYPE RAM_TYPE is array (0 to 63) of std_logic_vector (3 downto 0);
TYPE ERR_TYPE is array (0 to 63) of std_logic_vector (7 downto 0);

signal RAM : RAM_TYPE :=    (others => (others => '0'));
signal RAM_ERR : ERR_TYPE :=    (others => (others => '0'));



begin

    -- Process for writing data to the sink when enable is on
    PROCESS (clk, en, rst)
    BEGIN
        
        if (rst = '1') then
            index <= "000000";
            RAM <= (others => (others => '0'));
            RAM_ERR <= (others => (others => '0'));
            
        elsif clk'event and clk = '1' then
            if en = '1' then
                RAM(conv_integer(index)) <= input;
                RAM_ERR(conv_integer(index)) <= input_err;
                index <= index + '1';
            end if;
            
            out1 <= RAM(conv_integer(read_ram));
            out2 <= RAM_ERR(conv_integer(read_ram));
            
        end if;

    END PROCESS;

end Behavioral;

