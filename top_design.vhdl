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
-- Updates:
--
--     Milestone 1: 2013-09-17
--
-- Question: Do we have to be able to display source and sink data simultaneously?
-- Question: Do we have to be able to display the message and send the data simultaneously?
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Declaration for top entity
entity top_design is
    Port (  ssegAnode :         out STD_LOGIC_VECTOR (3 downto 0);  -- 7seg output
            ssegCathode :       out STD_LOGIC_VECTOR (7 downto 0);  -- 7seg output
            slideSwitches :     in  STD_LOGIC_VECTOR (7 downto 0);  -- Slide switches input
            pushButtons :       in  STD_LOGIC_VECTOR (3 downto 0);  -- Push button input
            LEDs :              out STD_LOGIC_VECTOR (7 downto 0);  -- LED's on the board
            clk50mhz :          in  STD_LOGIC;                      -- 50mhz system clock
            logic_analyzer :    out STD_LOGIC_VECTOR (7 downto 0)   -- Output for the logic analyser
); end top_design;

architecture Behavioral of top_design is

-- Component for driving the 7seg display
-- This is purely for testing, and is not part of the final project
component ssegDriver port (
              clk :             in  std_logic;
              rst :             in  std_logic;
              cathode_p :       out std_logic_vector(7 downto 0);
              digit1_p :        in  std_logic_vector(3 downto 0);
              anode_p :         out std_logic_vector(3 downto 0);
              digit2_p :        in  std_logic_vector(3 downto 0);
              digit3_p :        in  std_logic_vector(3 downto 0);
              digit4_p :        in  std_logic_vector(3 downto 0)
); end component;  

-------------------------------------------------------------------------------
-- 
-- Placeholder for Data source
--
-- The data source will store the message and output char by char to out1 
-- and out2
--
-- component Data_Source port (
--            clk  :            in  std_logic;
--            rst  :            in  std_logic;
--            en   :            in  std_logic;
--            out1 :            out std_logic_vector(3 downto 0);
--            out2 :            out std_logic_vector(3 downto 0);
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Hamming encoder
--
-- The hamming encoder will take a character as input, and will output the 
-- hamming encoded (with parity bit) signal.
--
-- component Hamming_Encoder port (
--            clk    :          in  std_logic;
--            rst    :          in  std_logic;
--            en     :          in  std_logic;
--            input  :          in  std_logic_vector(3 downto 0);
--            err    :          in  std_logic_vector(3 downto 0);
--            output :          out std_logic_vector(7 downto 0);
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Manchester encoder
--
-- The manchester encoder will take an input signal, and will output the 
-- manchester encoded signal. Should take a clock that is 16x faster than
-- the clock for the input signal.
--
-- component Manchesterr_Encoder port (
--            clk    :          in  std_logic;
--            rst    :          in  std_logic;
--            en     :          in  std_logic;
--            input  :          in  std_logic_vector(7 downto 0);
--            outSig :          out std_logic;
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Manchester decoder
--
-- The manchester decoder will take an input signal, and will output the 
-- signal 8 bits at a time. Should take a clock that is significantly 
-- faster than the expected clock for the source
--
-- component Manchester_Decoder port (
--            clk     :          in  std_logic;
--            rst     :          in  std_logic;
--            en      :          in  std_logic;
--            input   :          in  std_logic;
--            decoded :          out std_logic_vector(7 downto 0);
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Hamming decoder
--
-- The hamming decoder will take an input signal, and will output the 
-- hamming corrected signal.
--
-- component Hamming_Decoder port (
--            clk     :          in  std_logic;
--            rst     :          in  std_logic;
--            en      :          in  std_logic;
--            input   :          in  std_logic_vector(7 downto 0;
--            decoded :          out std_logic_vector(3 downto 0);
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Data sink
--
-- The data source will store the received message and output char by char 
-- to out1
--
-- component Data_Source port (
--            clk   :            in  std_logic;
--            rst   :            in  std_logic;
--            en    :            in  std_logic;
--            input :            in  std_logic_vector(3 downto 0);
--            out1  :            out std_logic_vector(3 downto 0);
-- ); end component;
--
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- 
-- Placeholder for Transmitter controller
--
-- The transmitter controller will control when data will be sent and the
-- various encoders
--
-- component Transmitter_Controller port (
--            clk  :            in  std_logic;
--            rst  :            in  std_logic;
--            st_Transmit :     in  std_logic;
--            st_Disp :         in  std_logic;
--            en_Data :         out std_logic;
--            en_Enc1 :         out std_logic;
--            en_Enc2 :         out std_logic;
-- ); end component;
--
-------------------------------------------------------------------------------

-- receiver controller

-- ui

----------------------------------
-- Clock signals
----------------------------------
signal masterReset  : std_logic;                            -- Master reset signal
signal clockScalers : std_logic_vector (26 downto 0);       -- Counter for the 50mhz clock
signal slowClock    : std_logic;                            -- Slow clock for reading memory
signal fastClock    : std_logic;                            -- 16x faster than slowclock, for sending data
signal secClock     : std_logic;                            -- Generates a pulse every second

----------------------------------
-- Data source signals
----------------------------------
signal En_Source     : std_logic;                           -- Enable signal for data source
signal Raw_Source    : std_logic_vector(3 downto 0);        -- Raw source output for hamming
signal Matrix_Source : std_logic_vector(3 downto 0);        -- Source output for matrix

----------------------------------
-- Hamming encoder signals
----------------------------------
signal En_Hamming_Encoder : std_logic;                      -- Enable the hamming encoder
signal Encoded_Hamming    : std_logic_vector(7 downto 0);   -- Output of the hamming encoder

----------------------------------
-- Manchester encoder signals
----------------------------------
signal En_Manchester_Encoder : std_logic;                   -- Enable the manchester encoder
signal Coded_Output          : std_logic;                   -- Coded output of the manchester encoder

----------------------------------
-- Manchester decoder signals
----------------------------------
signal En_Manchester_Decoder : std_logic;                   -- Enable the manchester decoder
signal Decoded_Manchester    : std_logic_vector(7 downto 0);-- Output decoded manchester (encoded hamming)

----------------------------------
-- Hamming decoder signals
----------------------------------
signal En_Hamming_Decoder : std_logic;                      -- Enable the hamming decoder
signal Raw_Sink           : std_logic(3 downto 0);          -- Decoded hamming (raw data)

----------------------------------
-- Data source signals
----------------------------------
signal En_Source          : std_logic;                      -- Enable the data source
signal Matrix_Source      : std_logic_vector(3 downto 0);   -- Output for the matrix display

----------------------------------
-- Data sink signals
----------------------------------
signal En_Sink            : std_logic;                      -- Enable the data sink
signal Matrix_Sink        : std_logic_vector(3 downto 0);   -- Output for the matrix display

----------------------------------
-- User interface signals 
----------------------------------
signal Transmit           : std_logic;                      -- Begin transmission of data
signal Hamming_Error      : std_logic_vector(7 downto 0);   -- Error to be introduced on hamming encoder
signal Disp_Source        : std_logic;                      -- Begin displaying the source
signal Disp_Sink          : std_logic;                      -- Begin displaying the sink

----------------------------------
-- 7seg digit inputs
-- This is test code and can be removed
----------------------------------
signal digit1 : std_logic_vector(3 downto 0);
signal digit2 : std_logic_vector(3 downto 0);
signal digit3 : std_logic_vector(3 downto 0);
signal digit4 : std_logic_vector(3 downto 0);

begin

slowClock <= clockScalers(12);
resetFsm <= masterReset or secClock;

-- Process for 50mhz clock, incremements the clockScalers variable
process (clk50mhz, masterReset) begin
    if (masterReset = '1') then
        clockScalers <= "000000000000000000000000000";
    elsif (clk50mhz'event and clk50mhz = '1') then
        clockScalers <= clockScalers + '1';
        
        -- Send a pulse every second
        if (clockScalers+1) = 50000000 then
            clockScalers <= "000000000000000000000000000";
            secClock <= '1';
        else
            secClock <= '0';
        end if;
    end if;
end process;

-- Instance for the 7 Seg Driver
-- This is test code and can be removed
u1 : ssegDriver port map (
      clk => slowClock,
      rst => masterReset,
      cathode_p => ssegCathode,
      digit1_p => digit1,
      anode_p => ssegAnode,
      digit2_p => digit2,
      digit3_p => digit3,
      digit4_p => digit4
);

LEDs(7 downto 0) <= "00000000";
logic_analyzer(7 downto 0) <= "00000000";
		 
end Behavioral;