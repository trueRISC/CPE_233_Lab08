----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2016 11:51:35 AM
-- Design Name: 
-- Module Name: Stack_Pointer - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Stack_Pointer is
    Port ( RST : in STD_LOGIC;
           LD : in STD_LOGIC;
           INCR : in STD_LOGIC;
           DECR : in STD_LOGIC;
           DATA : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           OUTPUT : in STD_LOGIC_VECTOR (7 downto 0));
end Stack_Pointer;

architecture Behavioral of Stack_Pointer is
    
    -- Signals ----------------------------
    signal s_out : std_logic_vector(7 downto 0) := (others => '1');
    
begin

    process(CLK, RST)
    begin
        if(RST ='0') then
            s_out <= (others => '1');
        elsif(rising_edge(CLK)) then
            if(LD = '1') then
                s_out <= DATA;
            elsif(INCR = '1') then
                s_out <= s_out + 1;
            elsif(DECR = '1') then
                s_out <= s_out - 1;
            end if;
        end if;
    end process;

end Behavioral;
