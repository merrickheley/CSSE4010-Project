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

entity Manchester_Decoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC;
           decode_valid : out STD_LOGIC;
           decoded : out  STD_LOGIC_VECTOR (7 downto 0));
end Manchester_Decoder;

architecture Behavioral of Manchester_Decoder is
 
-- Idle, sampling clock, recieving.
TYPE STATE_TOP IS (A, B, C);
SIGNAL y   : STATE_TOP;

-- Count the number of samples for half a manchester bit
signal dataSamples : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

-- Count the number of samples in the current half-bit
signal countSamples : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

-- The output being currently built
signal buildingOutput : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

-- Stage trackers
signal buildStage  : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal buildBit    : STD_LOGIC := '0';
signal lastHalfBit : STD_LOGIC := '0';

-- Bins
signal lowBin  : STD_LOGIC_VECTOR(7 downto 0) := "00000000";
signal highBin : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

-- Byte bin
signal lowByteBin : STD_LOGIC_VECTOR(10 downto 0) := "00000000000";

-- Register holding the generated input byte
signal outputReg : STD_LOGIC_VECTOR(7 downto 0) := "00000000";

begin

    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en, rst)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            outputReg <= "00000000";
            decode_valid <= '0';
            y <= A;
        
        -- This does not currently work and will simply duplicate the data
        elsif clk'event and clk = '1' then
            if en = '0' then
                outputReg <= "00000000";
            else
                --outputReg <= buildingOutput;
                CASE y IS
                    -- Idle stage, wait for input to go low
                    WHEN A =>
                        dataSamples <= "00000001";
                        countSamples <= "00000000";
                        if input = '0' then
                            y <= B;
                        else 
                            y <= A;
                        end if;
                    -- Get the #clk's in a sample
                    WHEN B =>
                        if input = '0' then
                            dataSamples <= dataSamples + '1';
                            y <= B;
                        else
                            -- If there was only a single bit it was probably just noise
                            if dataSamples = "00000001" then
                                y <= A;
                            else
                                countSamples <= "00000001";
                                buildingOutput <= "00000000";
                                buildStage <= "000";
                                buildBit <= '1';
                                lastHalfBit <= '0';
                                
                                lowByteBin <= "00000000000";
                                lowBin <= "00000000";
                                highBin <= "00000001";
                                y <= C;
                            end if;
                        end if;
                        
                    -- Receive the data
                    WHEN C =>                        
                        --decoded <= "00000" & buildStage;
                        -- If a full clock cycle has been sampled
                        if (countSamples + '1') = dataSamples then
                            -- If the first half bit has already been received
                            if buildBit  = '1' then
                                
                                -- Add the new bit to the output ass it's being build
                                if lowBin > highBin then
                                    buildingOutput(conv_integer(buildStage)) <= lastHalfBit;
                                else
                                    buildingOutput(conv_integer(buildStage)) <= lastHalfBit;
                                end if;
                                
                                -- Reset the build stages and bits
                                buildBit <= '0';
                                buildStage <= buildStage + '1';
                                
                            -- if we are recieving the first halfbit
                            else
                                -- Log the half bit and increment the build bit
                                if lowBin > highBin then
                                    lastHalfBit <= '0';
                                else
                                    lastHalfBit <= '1';
                                end if;
                                buildBit <= '1';
                            end if;
                            
                            -- Reset the count samples
                            countSamples <= "00000000";
                            lowBin <= "00000000";
                            highBin <= "00000000";
                            
                        else
                            
                            -- If it's the start of a new data bit, output the old bit and check if the signal is high
                            if buildStage = "000" and buildBit = '0' then
                                if countSamples = "00000000" then
                                    -- If less than 8 low samples have been received in a single byte, the line is high
                                    -- reset the fsm
                                    if lowByteBin < "00000001000" then
                                        outputReg <= "00000000";
                                        y <= A;
                                    -- Data is valid, output the data and indicate validity
                                    else
                                        outputReg <= buildingOutput;
                                        decode_valid <= '1';
                                        lowByteBin <= "00000000000";
                                    end if;
                                else
                                    decode_valid <= '0';
                                end if;
                            elsif input = '0' then
                                lowByteBin <= lowByteBin + '1';
                            end if;
                            
                            countSamples <= countSamples + '1';
                            
                            -- Add the bit to the bin
                            if input = '0' then
                                lowBin <= lowBin + '1';
                            else
                                highBin <= highBin + '1';
                            end if;
                        end if;
                END CASE;
            end if;      
        end if;
    END PROCESS;
    
    decoded <= outputReg;

end Behavioral;

