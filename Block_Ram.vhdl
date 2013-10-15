-------------------------------------------------------------------------------
-- CSSE4010 Project
-- Simple Communication System
--
-- Merrick Heley
-- 2013-10-15
-- 
-- This system implements a communication system between two Nexus 2 FPGA 
-- boards, that sends a 64 character message from one system to the other 
-- using a hamming and manchester coded message.
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity Block_Ram is
    Port (
        clk     : in  std_logic;
        we      : in  std_logic;
        rd_addr : in  std_logic_vector;
        wr_addr : in  std_logic_vector;
        datain  : in  std_logic_vector;
        dataout : out std_logic_vector); 
end Block_Ram;

architecture Behavioral of Block_Ram is

    type ram_type is array (0 to 63) of std_logic_vector(3 downto 0);
    signal ram : ram_type := (others => (others => '0'));
    signal read_address : std_logic_vector(5 downto 0) := "000000";

begin

    PROCESS(clk) is
    BEGIN
        if clk'event and clk = '1' then
            if we = '1' then
                ram(to_integer(unsigned(wr_addr))) <= datain;
            end if;
        
            read_address <= rd_addr;
        end if;
    END PROCESS;

    dataout <= ram(to_integer(unsigned(read_address)));

end Behavioral;