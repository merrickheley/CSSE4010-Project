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
signal lastHalfBit : STD_LOGIC := '0';
TYPE STATE_BUILD IS (A, B);
signal buildBit : STATE_BUILD := B;

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

        elsif clk'event and clk = '1' and en = '1' then
            --outputReg <= buildingOutput;
            CASE y IS
                -- Idle stage, wait for input to go low
                WHEN A =>
                    dataSamples     <= "00000000";
                    countSamples    <= "00000001";
                    buildingOutput  <= "00000000";
                    buildStage      <= "000";
                    buildBit        <= B;
                    lastHalfBit     <= '0';
                    
                    lowByteBin      <= "00000000000";
                    lowBin          <= "00000000";
                    highBin         <= "00000001";

                    if input = '0' then
                        y <= B;
                    else 
                        y <= A;
                    end if;
                -- Get the #clk's in a sample
                WHEN B =>
                    -- Count the number of clock cycles input is low for
                    if input = '0' then
                        dataSamples <= dataSamples + '1';
                        y <= B;
                    else
                        -- If there was only a single bit it was probably just noise
                        if dataSamples = "00000000" then
                            y <= A;
                        else
                            y <= C;
                        end if;
                    end if;
                    
                -- Receive the data
                WHEN C =>
                    -- If a full clock cycle has been sampled
                    if countSamples = dataSamples then
                        
                        CASE buildBit IS
                            -- if we are receiving the first halfbit
                            -- log the half bit and increment the build bit
                            WHEN A =>
                            
                                if lowBin > highBin then
                                    lastHalfBit <= '0';
                                else
                                    lastHalfBit <= '1';
                                end if;
                                
                                buildBit <= B;
                            
                            -- If the first half bit has already been received
                            WHEN B =>
                                -- Add the new bit to the output ass it's being build
                                if buildStage = "111" then 
                                    -- If enough low bytes have been recieved, this is a valid signal
                                    if lowByteBin > "00000000100" then
                                        outputReg       <= lastHalfBit & buildingOutput(6 downto 0);
                                        decode_valid    <= '1';
                                        lowByteBin      <= "00000000000";
                                    -- Not enough low bytes have been received, the signal is probably held high
                                    else
                                        outputReg       <= "00000000";
                                        y               <= A;
                                    end if;
                                else
                                    buildingOutput(conv_integer(buildStage)) <= lastHalfBit;
                                end if;
                                
                                -- Reset the build stages and bits
                                buildBit     <= A;
                                buildStage   <= buildStage + '1';
                                
                        END CASE;
                        
                        -- Reset the count samples
                        countSamples <= "00000000";
                        lowBin       <= "00000000";
                        highBin      <= "00000000";
                        
                    else
                        decode_valid <= '0';
                        
                        countSamples <= countSamples + '1';
                        
                        lowByteBin <= lowByteBin + not(Input);
                        lowBin     <= lowBin + not(Input);
                        highBin    <= highBin + Input;
                        
                    end if;
            END CASE;  
        end if;
    END PROCESS;
    
    decoded <= outputReg;

end Behavioral;