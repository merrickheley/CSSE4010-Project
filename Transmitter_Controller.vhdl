----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:42:23 09/23/2013 
-- Design Name: 
-- Module Name:    Transmitter_Controller - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Transmitter_Controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           st_Transmit : in  STD_LOGIC;
           st_Disp : in  STD_LOGIC;
           en_Data : out  STD_LOGIC;
           en_Enc : out  STD_LOGIC;
           en_Enc2 : out  STD_LOGIC);
end Transmitter_Controller;

architecture Behavioral of Transmitter_Controller is

TYPE STATE_TYPE IS (A, B, C, D);
SIGNAL y   : STATE_TYPE;

signal count : std_logic_vector(5 downto 0);

begin
    -- Process for controller the transmitter state
    PROCESS (clk, rst)
    BEGIN
        
        -- On reset set the controller back to initial state
        if rst = '1' then
            y <= A;
            count <= "000000";
        elsif clk'event and clk = '1' then
            CASE y IS
                WHEN A =>
                    if st_Transmit = '1' then
                        y <= B;
                    else
                        y <= A;
                    end if;
                WHEN B =>
                    y <= C;
                WHEN C =>
                    if count = "111111" then
                        count <= "000000";
                        y <= D;
                    else 
                        count <= count + '1';
                        y <= C;
                    end if;
                WHEN D =>
                    y <= A;
            END CASE;
        end if;
        
    END PROCESS;
         
    en_Data <= '1' WHEN y = C ELSE '0';    
    en_Enc <= '1' WHEN y = C ELSE '0';
    en_Enc2 <= '1' WHEN y = C ELSE '0';

end Behavioral;

