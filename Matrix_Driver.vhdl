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

entity Matrix_Driver is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           en : in  STD_LOGIC;
           data_source : in  STD_LOGIC_VECTOR (3 downto 0);
           data_source_err : in STD_LOGIC_VECTOR (7 downto 0);
           data_sink : in  STD_LOGIC_VECTOR (3 downto 0);
           data_sink_err : in STD_LOGIC_VECTOR (7 downto 0);
           valid_sink : in STD_LOGIC;
           led_matrix : out  STD_LOGIC_VECTOR (14 downto 0);
           row_select : out  STD_LOGIC_VECTOR (2 downto 0));
end Matrix_Driver;

architecture Behavioral of Matrix_Driver is

type matrix_number_type is array(6 downto 0) of std_logic_vector(3 downto 0);
type matrix_numbers_type is array (0 to 15) of matrix_number_type;

signal matrix_numbers : matrix_numbers_type := (("0110", "0110", "1001", "1001", "1001", "1001", "1001"),   -- 0
                                                ("0010", "0010", "0010", "0010", "0010", "0010", "0010"),   -- 1
                                                ("1110", "1111", "0001", "0010", "0100", "1001", "1001"),   -- 2
                                                ("0111", "0111", "1000", "0100", "0010", "0100", "1000"),   -- 3
                                                ("0001", "0100", "0100", "0100", "1111", "0101", "0001"),   -- 4
                                                ("1111", "0111", "1000", "1000", "0110", "0001", "0001"),   -- 5
                                                ("1110", "1111", "1001", "1001", "1111", "0001", "0001"),   -- 6
                                                ("1111", "1000", "1000", "1000", "1000", "1000", "1000"),   -- 7
                                                ("1111", "1111", "1001", "1001", "1111", "1001", "1001"),   -- 8
                                                ("1111", "1000", "1000", "1000", "1111", "1001", "1001"),   -- 9
                                                ("0110", "1001", "1001", "1001", "1111", "1001", "1001"),   -- A
                                                ("0111", "0111", "1001", "1001", "0111", "1001", "1001"),   -- B
                                                ("1110", "1110", "0001", "0001", "0001", "0001", "0001"),   -- C
                                                ("0011", "0011", "0101", "1001", "1001", "1001", "0101"),   -- D
                                                ("1111", "1111", "0001", "0001", "1111", "0001", "0001"),   -- E
                                                ("0111", "0001", "0001", "0001", "0111", "0001", "0001"));  -- F        
                                                
                                                
type matrix_err_type is array(6 downto 0) of std_logic_vector(4 downto 0);                                                
type matrix_errs_type is array (0 to 1) of matrix_err_type;

signal error_numbers : matrix_errs_type :=    (("00000", "00000", "01110", "10001", "00000", "01010", "01010"),    -- :)
                                               ("00000", "00000", "10001", "01110", "00000", "01010", "01010"));   -- :(

                       
signal digit1 : std_logic_vector(3 downto 0) := "0000";
signal digit2 : std_logic_vector(3 downto 0) := "0000";
signal digit3 : std_logic := '0';

signal digit1_err : std_logic_vector(6 downto 0) := "0000000";
signal digit2_err : std_logic_vector(6 downto 0) := "0000000";

signal input : std_logic_vector(3 downto 0) := "0000";

signal row : std_logic_vector(2 downto 0);

begin

   PROCESS (clk, en, rst)
   
   variable row_var    : integer range 0 to 7;
   variable digit1_var : integer range 0 to 15;
   variable digit2_var : integer range 0 to 15;
   variable digit3_var : integer range 0 to 1;
   
   BEGIN
        
        -- On reset set the matrix to 0's
        -- 
        if rst = '1' then
            row <= "000";
            led_matrix <= "000000000000000";

        elsif clk'event and clk = '1'  then
            row_var    := conv_integer(row);
            digit1_var := conv_integer(digit1);
            digit2_var := conv_integer(digit2);
            digit3_var := conv_integer(digit3);
        
            -- Do nothing
            if    en = '0' then
                row <= "000";
                led_matrix <= "000000000000000";
            
            -- Enable the data display
            -- Combine the digits with their error, and display 2-bit error with :) or :(
            else
            
                digit1 <= data_source;
                digit1_err <= data_source_err(0) & data_source_err(6 downto 1);
            
                digit2 <= data_sink;
                digit2_err <= data_sink_err(0) & data_sink_err(6 downto 1);
                
                if (row = "110") then
                    row <= "000";
                else
                    row <= row + '1';
                end if;
                 
                
                digit3 <= valid_sink;
                
                -- Build the row of the LED matrix to output
                led_matrix <= not(digit1_err(row_var) & matrix_numbers(digit1_var)(row_var) &
                                  digit2_err(row_var) & matrix_numbers(digit2_var)(row_var) &
                                  error_numbers(digit3_var)(row_var));

            end if;
        end if;
    END PROCESS;
    
    row_select <= row;

end Behavioral;

