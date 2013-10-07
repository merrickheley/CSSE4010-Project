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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Hamming_Encoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (3 downto 0);
           err : in  STD_LOGIC_VECTOR (7 downto 0);
           output : out  STD_LOGIC_VECTOR (7 downto 0));
end Hamming_Encoder;

architecture Behavioral of Hamming_Encoder is
    
begin


    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en, rst)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            output <= "00000000";
        
        -- Hamming encode if enabled, otherwise output 0's
        -- Input is of the form [D3 D2 D1 D0]
        -- Output = P0 P1 P2 P3 | D3 D2 D1 D0
        elsif clk'event and clk = '1' then
            if en = '0' then
                output <= "00000000";
            else
                output <=   ((input(0) xor input(1) xor input(2)) &  -- P0 : 0, 1, 2
                             (input(0) xor input(1) xor input(3)) &  -- P1 : 0, 1, 3
                             (input(0) xor input(2) xor input(3)) &  -- P2 : 0, 2, 3
                             (input(1) xor input(2) xor input(3)) &  -- P3 : 1, 2, 3
                              input
                             ) xor err;
            end if;      
        end if;
    END PROCESS;
    


end Behavioral;

