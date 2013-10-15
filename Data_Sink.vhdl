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

entity Data_Sink is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (3 downto 0);
           input_err : in STD_LOGIC_VECTOR (7 downto 0);
           input_val : in STD_LOGIC;
           read_ram : in STD_LOGIC_VECTOR (5 downto 0);
           out1 : out  STD_LOGIC_VECTOR (3 downto 0);
           out2 : out  STD_LOGIC_VECTOR (7 downto 0);
           out3 : out  STD_LOGIC);
           
    attribute RAM_STYLE : string;
    attribute RAM_STYLE of Data_Sink: entity is "BLOCK" ;
end Data_Sink;

architecture Behavioral of Data_Sink is

	COMPONENT Block_Ram
	PORT(
		clk      : IN  std_logic;
		we       : IN  std_logic;
        rd_addr  : IN  std_logic_vector;
        wr_addr  : IN  std_logic_vector;
		datain   : IN  std_logic_vector;          
		dataout  : OUT std_logic_vector
		);
	END COMPONENT;

    signal index : STD_LOGIC_VECTOR(5 downto 0) := "000000";

    signal ram_input : std_logic_vector(12 downto 0);
    signal ram_output : std_logic_vector(12 downto 0);

begin

    -- Use block ram to store/retrieve data
	Inst_Block_Ram: Block_Ram PORT MAP(
		clk => clk,
		we => en,
		rd_addr => read_ram,
        wr_addr => index,
		datain => ram_input,
		dataout => ram_output
	);

    -- Process for writing data to the sink when enable is on
    PROCESS (clk, en, rst)
    BEGIN
        
        if (rst = '1') then
            index <= "000000";
            
        elsif clk'event and clk = '1' then
            -- If enabled, store data in a circular buffer
            
            if en = '1' then
                index <= index + '1';
            end if;
            
        end if;

    END PROCESS;
    
    -- Concatenate and split the RAM I/O to enable compressed storage
    ram_input <= input_val & input_err & input;
    out1 <= ram_output(3 downto 0);
    out2 <= ram_output(11 downto 4);
    out3 <= ram_output(12);

end Behavioral;

