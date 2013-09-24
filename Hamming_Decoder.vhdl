----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:48:50 09/24/2013 
-- Design Name: 
-- Module Name:    Hamming_Decoder - Behavioral 
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

entity Hamming_Decoder is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           input : in  STD_LOGIC_VECTOR (7 downto 0);
           decode_valid : out STD_LOGIC;
           decoded : out  STD_LOGIC_VECTOR (3 downto 0));
end Hamming_Decoder;

architecture Behavioral of Hamming_Decoder is

begin

    -- Process for reading data out of the data source when enable is on
    PROCESS (clk, en, rst)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            decoded <= "0000";
            decode_valid <= '0';
        
        -- This does not currently work and will simply duplicate the data
        elsif clk'event and clk = '1'  then
            if en = '1' then
                decoded <= input (3 downto 0);
                decode_valid <= '1';
            else
                decoded <= "0000";
                decode_valid <= '0';
            end if;
        end if;
    END PROCESS;

end Behavioral;

