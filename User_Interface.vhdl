----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:26:50 09/17/2013 
-- Design Name: 
-- Module Name:    User_Interface - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
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

