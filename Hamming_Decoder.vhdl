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

entity Hamming_Decoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (7 downto 0);
           decode_valid : out STD_LOGIC;
           decoded : out  STD_LOGIC_VECTOR (3 downto 0));
end Hamming_Decoder;

architecture Behavioral of Hamming_Decoder is

    SIGNAL S1 : STD_LOGIC := '0';
    SIGNAL S2 : STD_LOGIC := '0';
    SIGNAL S3 : STD_LOGIC := '0';
    
    type lut is array (0 to 7) of std_logic_vector(7 downto 0);
    constant my_lut : lut := (  0 => "00000000",
                                1 => "00010000",
                                2 => "00100000",
                                3 => "00000100",
                                4 => "01000000",
                                5 => "00000010",
                                6 => "00000001",
                                7 => "00001000");

begin

    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en, rst)
        variable s0     : integer range 0 to 1;
        variable s1     : integer range 0 to 1;
        variable s2     : integer range 0 to 1;    
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            decoded <= "0000";
            decode_valid <= '0';
        
        --Hamming Decoder
        -- Form syndromes 
        elsif clk'event and clk = '1'  then
            if en = '1' then
                
                -- Generate syndromes
                s0 := conv_integer(input(6) xor input(0) xor input(1) xor input(3));
                s1 := conv_integer(input(5) xor input(0) xor input(2) xor input(3));
                s2 := conv_integer(input(4) xor input(1) xor input(2) xor input(3));
                
                -- Set decoded output
                decoded <= input(3 downto 0) xor my_lut(s0*4 + s1*2 + s2)(3 downto 0);
                
                -- Check if the decode is valid (detected uncorrectable error)
                if ((input(0) xor input(1) xor input(2) xor input(3) xor input(4) xor input(5) xor input(6)) = input(7))
                        and ((s0 + s1 + s2) > 0) then
                        
                    decode_valid <= '0';
                else
                    decode_valid <= '1';
                end if;
                
            else
                decode_valid <= '0';
                decoded <= "0000";
                
            end if;
        end if;
    END PROCESS;

end Behavioral;

