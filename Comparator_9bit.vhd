----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2016 12:48:34 PM
-- Design Name: 
-- Module Name: Comparator_9bit - Behavioral
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

entity Comparator_9bit is
    Port ( A : in STD_LOGIC_VECTOR (8 downto 0);
           B : in STD_LOGIC_VECTOR (8 downto 0);
           EQ : out STD_LOGIC);
end Comparator_9bit;

architecture Behavioral of Comparator_9bit is

begin

    process(A,B)
    begin
        if(A(7 downto 0) = B(7 downto 0)) then
            EQ <= '1';
        else
            EQ <= '0';
        end if;
    end process;

end Behavioral;
