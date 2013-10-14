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
--     Milestone 1: 2013-09-17 (v0.2)
--
-- Question: Do we have to be able to display source and sink data simultaneously?
-- Question: Do we have to be able to display the message and send the data simultaneously?
--
--     Milestone 2: 2013-09-24 
--
-- Added data source, shell for hamming encoder and decoder, and manchester encoder and 
-- decoder are tested and working. Todo: Matrix driver, hamming encoder/decoder
--
--     Milestone 2 (cont): 2013-10-07 (v0.3)
-- Hamming encoder and decoder completed, tested and working.
--
--
--    Draft Version: 2013-10-14 (v0.4)
-- Adding playback from data source
-- Fixing data sink's ability to display messages with error.
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
            logic_analyzer :    out STD_LOGIC_VECTOR (6 downto 0);  -- Output for the logic analyser
            encoded_input :     in  STD_LOGIC;                      -- Input for the manchester demodulator
            row_select :        out STD_LOGIC_VECTOR (2 downto 0);  -- Row select for the matrix driver
            led_matrix :        out STD_LOGIC_VECTOR (14 downto 0)  -- Matrix output for the row
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

-- Component for the data source
-- The data source will store the message and output char by char to out1 
-- and out2
COMPONENT Data_Source
PORT(
    clk :  IN  std_logic;
    rst :  IN  std_logic;
    en :   IN  std_logic;          
    out1 : OUT std_logic_vector(3 downto 0);
    out2 : OUT std_logic_vector(3 downto 0)
    );
END COMPONENT;
    
-- Component for the hamming encoding
-- The hamming encoder will take a character as input, and will output the 
-- hamming encoded (with parity bit) signal.
component Hamming_Encoder port (
    clk    :          in  std_logic;
    rst    :          in  std_logic;
    en     :          in  std_logic;
    input  :          in  std_logic_vector(3 downto 0);
    err    :          in  std_logic_vector(7 downto 0);
    output :          out std_logic_vector(7 downto 0)
    ); 
end component;

-- Component for Manchester encoder
-- The manchester encoder will take an input signal, and will output the 
-- manchester encoded signal. Should take a clock that is 16x faster than
-- the clock for the input signal.
COMPONENT Manchester_Encoder
PORT(
    clk : IN std_logic;
    rst : IN std_logic;
    en : IN std_logic;
    input : IN std_logic_vector(7 downto 0);          
    outSig : OUT std_logic
    );
END COMPONENT;

-- Component for Manchester decoder
-- The manchester decoder will take an input signal, and will output the 
-- signal 8 bits at a time. Should take a clock that is significantly 
-- faster than the expected clock for the source
component Manchester_Decoder port (
           clk     :          in  std_logic;
           rst     :          in  std_logic;
           en      :          in  std_logic;
           input   :          in  std_logic;
           decode_valid :     out std_logic;
           decoded :          out std_logic_vector(7 downto 0)
); end component;

-------------------------------------------------------------------------------

-- Component for hamming decoder
-- The hamming decoder will take an input signal, and will output the 
-- hamming corrected signal.
component Hamming_Decoder port (
        clk     :          in  std_logic;
        rst     :          in  std_logic;
        en      :          in  std_logic;
        input   :          in  std_logic_vector(7 downto 0);
        decode_valid :     out std_logic;
        decoded :          out std_logic_vector(3 downto 0)
); end component;

-- Component for data sink
-- The data sink will store the received message in a circular buffer and
-- will output the value of the read_ram to out1
component Data_Sink port (
           clk   :            in  std_logic;
           rst   :            in  std_logic;
           en    :            in  std_logic;
           input :            in  std_logic_vector(3 downto 0);
           input_err :        in  std_logic_vector(7 downto 0);
           read_ram :         in  STD_LOGIC_VECTOR (5 downto 0);
           out1  :            out std_logic_vector(3 downto 0);
           out2  :            out std_logic_vector(7 downto 0)
); end component;

-- Component for Transmitter controller
-- The transmitter controller will control when data will be sent and the
-- various encoders
component Transmitter_Controller port (
           clk  :            in  std_logic;
           rst  :            in  std_logic;
           st_Transmit :     in  std_logic;
           st_Disp :         in  std_logic;
           en_Data :         out std_logic;
           en_Enc  :         out std_logic;
           en_Enc2 :         out std_logic
); end component;

-- Component for the receiver controller
-- The receiver controller will control when data will be logged and when 
-- to display
component Receiver_Controller port (
           clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en_dec : out  STD_LOGIC;
           display : out  STD_LOGIC_VECTOR(5 downto 0);
           start_display : in  STD_LOGIC
); end component;

----------------------------------
-- User Interface
----------------------------------
-- Handle any hardware output that is essential for the project
--COMPONENT User_Interface
--PORT(
--            clk :            in  STD_LOGIC;
--            rst :            out STD_LOGIC;
--            Matrix_Source :  in  STD_LOGIC_VECTOR (3 downto 0);
--            Matrix_Sink :    in  STD_LOGIC_VECTOR (3 downto 0);
--            slideSwitches :  out STD_LOGIC_VECTOR (7 downto 0);
--            dispSink :       out STD_LOGIC;
--            dispSource :     out STD_LOGIC;
--            transmit :       out STD_LOGIC
--    );
--END COMPONENT;

----------------------------------
-- Matrix Driver
----------------------------------
-- Display digits to the LED matrix
-- en 00/11 : do nothing
-- en 01    : data source input
-- en 10    : data sink input
COMPONENT Matrix_Driver PORT(
    clk : IN std_logic;
    rst : IN std_logic;
    en : IN std_logic_vector(1 downto 0);
    data_source : IN std_logic_vector(3 downto 0);
    data_sink : IN std_logic_vector(3 downto 0);
    data_sink_err : IN std_logic_vector(7 downto 0);
    led_matrix : OUT std_logic_vector(14 downto 0);
    row_select : OUT std_logic_vector(2 downto 0)
    );
END COMPONENT;


----------------------------------
-- Clock signals
----------------------------------
signal masterReset  : std_logic;                            -- Master reset signal
signal clockScalers : std_logic_vector (26 downto 0);       -- Counter for the 50mhz clock
signal slowClock    : std_logic;                            -- Slow clock for reading memory
signal fastClock    : std_logic;                            -- 16x faster than slowclock, for sending data
signal sampleClock  : std_logic;                            -- Significantly faster than all other clocks
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
signal Coded_Input           : std_logic;                   -- Coded output of a manchester decoder
signal En_Manchester_Decoder : std_logic;                   -- Enable the manchester decoder
signal Decoded_Manchester    : std_logic_vector(7 downto 0);-- Output decoded manchester (encoded hamming)

----------------------------------
-- Hamming decoder signals
----------------------------------
signal En_Hamming_Decoder : std_logic;                      -- Enable the hamming decoder
signal Raw_Sink           : std_logic_vector(3 downto 0);          -- Decoded hamming (raw data)

----------------------------------
-- Data sink signals
----------------------------------
signal En_Sink            : std_logic;                      -- Enable the data sink
signal Matrix_Sink        : std_logic_vector(3 downto 0);   -- Output for the matrix display
signal Read_Ram           : std_logic_vector(5 downto 0);   -- Read a value out of the sink ram
signal Read_Err           : std_logic_vector(7 downto 0);   -- Error output by the hamming decoder
signal Matrix_Err         : std_logic_vector(7 downto 0);   -- Error input for matrix encoder

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

----------------------------------
-- Test enable
-- This is test code and can be removed
----------------------------------
signal enMatrix : std_logic_vector(1 downto 0);


begin

-- Use these for implementation
slowClock  <= clockScalers(16);
fastClock  <= clockScalers(12);
sampleClock <= clockScalers(7);

-- Use these for simulation
--slowClock <= clockScalers(5);
--fastClock <= clockScalers(1);


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

-- Instance for the user interface
-- This handles hardware output that is essential for the project
--Inst_User_Interface: User_Interface PORT MAP(
--    clk => slowClock,
--    rst => masterReset,
--    Matrix_Source => Matrix_Source,
--    Matrix_Sink => Matrix_Sink,
--    slideSwitches => Hamming_Error,
--    dispSource => Disp_Source,
--    dispSink => Disp_Sink,
--    transmit => Transmit
--);

Inst_Transmitter_Controller: Transmitter_Controller PORT MAP(
    clk => slowClock,
    rst => masterReset,
    st_Transmit => Transmit,
    st_Disp => Disp_Source,
    en_Data => En_Source,
    en_Enc => En_Hamming_Encoder,
    en_Enc2 => En_Manchester_Encoder
);

-- Instance for the data source
-- This pushes data to the outputs on clock cycles
Inst_Data_Source: Data_Source PORT MAP(
    clk => slowClock,
    rst => masterReset,
    en => En_Source,
    out1 => Raw_Source,
    out2 => Matrix_Source
);

-- Instance for the hamming encoder
-- Currently this just duplicates its input for the 'encoded' message
Inst_Hamming_Encoder: Hamming_Encoder PORT MAP(
    clk => slowClock,
    rst => masterReset,
    en => En_Hamming_Encoder,
    input => Raw_Source,
    err => Hamming_Error,
    output => Encoded_Hamming
);

-- Instance for the manchester encoder
-- Must be run at 16x the clock speed of the hamming encoder
Inst_Manchester_Encoder: Manchester_Encoder PORT MAP(
    clk => fastClock,
    rst => masterReset,
    en => En_Manchester_Encoder,
    input => Encoded_Hamming,
    outSig => Coded_Output
);

-- Instance for the manchester decoder
-- Must be run at a significantly faster clock than the manchester encoder
Inst_Manchester_Decoder: Manchester_Decoder PORT MAP(
    clk => sampleClock,
    rst => masterReset,
    en => En_Manchester_Decoder,
    input => Coded_Input,
    decode_valid => En_Hamming_Decoder,
    decoded => Decoded_Manchester
);

-- Instance for the hamming decoder
-- Must be run at the same clock speed as the manchester decoder
Inst_Hamming_Decoder: Hamming_Decoder PORT MAP(
    clk => sampleClock,
    rst => masterReset,
    en => En_Hamming_Decoder,
    input => Decoded_Manchester,
    decode_valid => En_Sink,
    decoded => Raw_Sink
);

-- Instance for the data sink.
-- Store the values sent by the manchester encoder in a circular buffer
Inst_Data_Sink: Data_Sink PORT MAP(
    clk => sampleClock,
    rst => masterReset,
    en => En_Sink,
    input => Raw_Sink,
    input_err => Decoded_Manchester,
    read_ram => Read_Ram,
    out1 => digit1,
    out2 => Matrix_Err
);

-- Instance of reciever controller
-- Enables the manchester decoder (always on), and controls data sink display line.
Inst_Receiver_Controller: Receiver_Controller PORT MAP(
    clk => secClock,
    rst => masterReset,
    en_dec => En_Manchester_Decoder,
    display => Read_Ram,
    start_display => Disp_Sink
);

-- Instance of the matrix driver
-- Used to play back the 
enMatrix <= "10";
Inst_Matrix_Driver: Matrix_Driver PORT MAP(
    clk => fastClock,
    rst => masterReset,
    en => enMatrix,
    data_source => digit4,
    data_sink => digit1,
    data_sink_err => Matrix_Err,
    led_matrix => led_matrix,
    row_select => row_select
);

-- Instance for the user interface
digit2 <= "0000";
digit3 <= "0000";
digit4 <= "0000";

-- Map the input (slideswitches and pushbuttons)
Hamming_Error <= slideSwitches;
masterReset   <= pushButtons(3);
Disp_Sink     <= pushButtons(2);
Disp_Source   <= pushButtons(1);
Transmit      <= pushButtons(0);

-- Map the LED's
LEDs(7) <= En_Source;
LEDs(6) <= slowClock;
LEDs(5) <= En_Hamming_Decoder;
LEDS(4 downto 1) <= Raw_Source;
LEDs(0) <= Coded_Output;

-- Map the logic_analyzer port (excluding the last pin)
logic_analyzer(6 downto 1) <= "000000";
logic_analyzer(0) <= Coded_Output;

-- Map the final pin of the logic analyzer port to be an input
-- Receives a manchester encoded message
Coded_Input <= encoded_input;
		 
end Behavioral;