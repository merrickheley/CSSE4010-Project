----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:17:25 09/23/2013 
-- Design Name: 
-- Module Name:    Hamming_Encoder - Behavioral 
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

entity Hamming_Encoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (3 downto 0);
           err : in  STD_LOGIC_VECTOR (3 downto 0);
           output : in  STD_LOGIC_VECTOR (7 downto 0));
end Hamming_Encoder;

architecture Behavioral of Hamming_Encoder is
    
    SIGNAL reg : STD_LOGIC_VECTOR(3 downto 0);
    
begin


    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            output <= "00000000";
            
        elsif en = '1' then
            output <= "00000000";
        
        -- This does not currently work and will simply duplicate the data
        elsif clk'event and clk = '1' and en = '1' then
            output <= input & input;            
        end if;
    END PROCESS;
    


end Behavioral;

