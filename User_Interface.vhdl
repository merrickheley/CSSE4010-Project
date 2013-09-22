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

entity User_Interface is
    Port ( clk :            in  STD_LOGIC;
           rst :            out STD_LOGIC;
           Matrix_Source :  in  STD_LOGIC_VECTOR (3 downto 0);
           Matrix_Sink :    in  STD_LOGIC_VECTOR (3 downto 0);
           slideSwitches :  out STD_LOGIC_VECTOR (7 downto 0);
           dispSink :       out STD_LOGIC;
           dispSource :     out STD_LOGIC;
           transmit :       out STD_LOGIC
          );
end User_Interface;

architecture Behavioral of User_Interface is

begin
    

end Behavioral;

