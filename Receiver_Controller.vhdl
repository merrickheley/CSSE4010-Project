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

entity Receiver_Controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en_dec : out  STD_LOGIC;
           display : out  STD_LOGIC_VECTOR(5 downto 0);
           start_display : in  STD_LOGIC);
end Receiver_Controller;

architecture Behavioral of Receiver_Controller is
    TYPE STATE_TYPE IS (A, B);
    SIGNAL y   : STATE_TYPE;
    
    SIGNAL count : STD_LOGIC_VECTOR(5 downto 0) := "000000";
begin
    
    -- Process for controller the transmitter state
    PROCESS (clk, rst)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            y <= A;
            count <= "000000";
        elsif clk'event and clk = '1' then
            CASE y IS
                -- No display
                -- When start_display is received, move to display state
                WHEN A =>
                    if start_display = '1' then
                        count <= "000000";
                        y <= B;
                    else
                        y <= A;
                    end if;
                -- Display each value once, reset afterwards
                WHEN B =>
                    if count = "111111" then
                        y <= A;
                    else
                        count <= count + '1';
                        y <= B;
                    end if;
            END CASE;
                    
        end if;
    END PROCESS;
    
    display <= count;
    en_dec <= '1';

end Behavioral;

