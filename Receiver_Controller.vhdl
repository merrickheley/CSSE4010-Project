----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:45:43 09/24/2013 
-- Design Name: 
-- Module Name:    Receiver_Controller - Behavioral 
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
use IEEE.Numeric_Std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Receiver_Controller is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en_dec : out  STD_LOGIC;
           display : out  STD_LOGIC_VECTOR(5 downto 0);
           start_display : in  STD_LOGIC);
end Receiver_Controller;

architecture Behavioral of Receiver_Controller is
    TYPE STATE_TYPE IS (A, B);
    SIGNAL y   : STATE_TYPE;
    
    SIGNAL count : STD_LOGIC_VECTOR(5 downto 0) := "000000";
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
                    if start_display = '1' then
                        count <= "000000";
                        y <= B;
                    else
                        y <= A;
                    end if;
                WHEN B =>
                    if count = "111111" then
                        y <= A;
                    else
                        count <= count + '1';
                        y <= B;
                    end if;
            END CASE;
                    
        end if;
    END PROCESS;
    
    en_dec <= '1';

end Behavioral;

