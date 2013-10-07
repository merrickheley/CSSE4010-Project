-------------------------------------------------------------------------------
-- CSSE4010 Project
-- Simple Communication System
--
-- Merrick Heley
-- 2013-10-07
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Matrix_Driver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC_VECTOR (1 downto 0);
           data_source : in  STD_LOGIC_VECTOR (3 downto 0);
           data_sink : in  STD_LOGIC_VECTOR (3 downto 0);
           led_matrix : out  STD_LOGIC_VECTOR (15 downto 0);
           row_select : out  STD_LOGIC_VECTOR (2 downto 0));
end Matrix_Driver;

architecture Behavioral of Matrix_Driver is

type matrix_number_type is array(0 to 7) of std_logic_vector(3 downto 0);
type matrix_numbers_type is array (0 to 15) of matrix_number_type;

signal matrix_numbers : matrix_numbers_type := (("0110", "1001", "1001", "1001", "1001", "1001", "0110", "0000"),   -- 0
                                                ("0010", "0010", "0010", "0010", "0010", "0010", "0010", "0000"), 	-- 1
                                                ("1111", "0001", "0010", "0100", "1001", "1001", "1110", "0000"),   -- 2
                                                ("0111", "1000", "0100", "0010", "0100", "1000", "0111", "0000"),   -- 3
                                                ("0100", "0100", "0100", "1111", "0101", "0001", "0001", "0000"),   -- 4
                                                ("0111", "1000", "1000", "0110", "0001", "0001", "1111", "0000"),   -- 5
                                                ("1111", "1001", "1001", "1111", "0001", "0001", "1110", "0000"), 	-- 6
                                                ("1000", "1000", "1000", "1000", "1000", "1000", "1111", "0000"),   -- 7
                                                ("1111", "1001", "1001", "1111", "1001", "1001", "1111", "0000"), 	-- 8
                                                ("1000", "1000", "1000", "1111", "1001", "1001", "1111", "0000"), 	-- 9
                                                ("1001", "1001", "1001", "1111", "1001", "1001", "0110", "0000"), 	-- A
                                                ("0111", "1001", "1001", "0111", "1001", "1001", "0111", "0000"), 	-- B
                                                ("1110", "0001", "0001", "0001", "0001", "0001", "1110", "0000"),   -- C
                                                ("0011", "0101", "1001", "1001", "1001", "0101", "0011", "0000"), 	-- D
                                                ("1111", "0001", "0001", "1111", "0001", "0001", "1111", "0000"),   -- E
                                                ("0001", "0001", "0001", "1111", "0001", "0001", "1111", "0000")	-- F       
                                                );
                       
signal digit1 : std_logic_vector(3 downto 0) := "0000";
signal digit2 : std_logic_vector(3 downto 0) := "0000";
signal digit3 : std_logic_vector(3 downto 0) := "0000";

signal row : std_logic_vector(2 downto 0);

begin

   PROCESS (clk, en, rst)
   
   variable row_var    : integer range 0 to 7;
   variable digit1_var : integer range 0 to 15;
   variable digit2_var : integer range 0 to 15;
   variable digit3_var : integer range 0 to 15;
   
   BEGIN
        
        -- On reset set the matrix to 0's
        -- 
        if rst = '1' then
            row <= "000";
            led_matrix <= "0000000000000000";

        elsif clk'event and clk = '1'  then
            row_var    := conv_integer(row);
            digit1_var := conv_integer(digit1);
            digit2_var := conv_integer(digit2);
            digit3_var := conv_integer(digit3);
        
            -- Enable the data source printing
            if    en = "01" then
                row <= "000";
                led_matrix <= "0000000000000000";
            
            -- Enable the data sink printing
            elsif en = "10" then
            
                digit2 <= "0010";
                row <= row + '1';               
                
                led_matrix <= matrix_numbers(digit1_var)(row_var) & '0' &
                              matrix_numbers(digit2_var)(row_var) & '0' &
                              matrix_numbers(digit3_var)(row_var) & '0' & '0';          
                
            -- Print nothing, either not enable or both enabled
            else
                row <= "000";
                led_matrix <= "0000000000000000";
                
            end if;
        end if;
    END PROCESS;
    
    row_select <= row;

end Behavioral;

