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
           outSig : out  STD_LOGIC;
           outBit : out  STD_LOGIC_VECTOR(2 downto 0));
end Manchester_Encoder;

architecture Behavioral of Manchester_Encoder is

TYPE STATE_TOP IS (s0, s1, s2, s3, s4, s5, s6, s7);
SIGNAL stateTop   : STATE_TOP;

TYPE STATE_MID IS (A, B);
SIGNAL stateMid   : STATE_MID;

begin

    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            stateTop <= s0;
            stateMid <= A;
            outSig <= '1';
        -- If the encoder has been disabled wait until the current clock has 
        -- finished before disabling    
        elsif clk'event and clk = '1' and En = '0' then
            stateTop <= s0;
            stateMid <= A;
            outSig <= '1';
            outBit <= "000";
        -- On clock edges move between the states in the state machine
        -- stateTop tracks the bit being used for the transmission
        -- stateMid tracks whether the bit is inverted or not
        elsif clk'event and clk = '1' and En = '1' then
            CASE stateTop IS
                WHEN s0 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(0);
                            stateMid <= B;
                            stateTop <= s0;
                        WHEN B =>
                            outSig <= NOT(input(0));
                            stateMid <= A;
                            stateTop <= s1;
                    END CASE;
                    outBit <= "000";
                WHEN s1 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(1);
                            stateMid <= B;
                            stateTop <= s1;
                        WHEN B =>
                            outSig <= NOT(input(1));
                            stateMid <= A;
                            stateTop <= s2;
                    END CASE;
                    outBit <= "001";
                WHEN s2 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(2);
                            stateMid <= B;
                            stateTop <= s2;
                        WHEN B =>
                            outSig <= NOT(input(2));
                            stateMid <= A;
                            stateTop <= s3;
                    END CASE;
                    outBit <= "010";
                WHEN s3 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(3);
                            stateMid <= B;
                            stateTop <= s3;
                        WHEN B =>
                            outSig <= NOT(input(3));
                            stateMid <= A;
                            stateTop <= s4;
                    END CASE;
                    outBit <= "011";
                WHEN s4 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(4);
                            stateMid <= B;
                            stateTop <= s4;
                        WHEN B =>
                            outSig <= NOT(input(4));
                            stateMid <= A;
                            stateTop <= s5;
                    END CASE;
                    outBit <= "100";
                WHEN s5 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(5);
                            stateMid <= B;
                            stateTop <= s5;
                        WHEN B =>
                            outSig <= NOT(input(5));
                            stateMid <= A;
                            stateTop <= s6;
                    END CASE; 
                    outBit <= "101";                    
                WHEN s6 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(6);
                            stateMid <= B;
                            stateTop <= s6;
                        WHEN B =>
                            outSig <= NOT(input(6));
                            stateMid <= A;
                            stateTop <= s7;
                    END CASE;
                    outBit <= "110";                    
                WHEN s7 =>
                    CASE stateMid IS
                        WHEN A =>
                            outSig <= input(7);
                            stateMid <= B;
                            stateTop <= s7;
                        WHEN B =>
                            outSig <= NOT(input(7));
                            stateMid <= A;
                            stateTop <= s0;
                    END CASE;
                    outBit <= "111";
            END CASE;
        end if;
    END PROCESS;
    
end Behavioral;

