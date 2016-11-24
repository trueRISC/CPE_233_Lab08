----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2016 12:48:34 PM
-- Design Name: 
-- Module Name: TwosComp_8BitDefinition - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TwosComp_8BitDefinition is
    Port ( INPUT : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (8 downto 0));
end TwosComp_8BitDefinition;

architecture Behavioral of TwosComp_8BitDefinition is
    signal s_Comp : std_logic_vector(9 downto 0);
begin
    
    OUTPUT <= ("111111111" xor ('0' & (INPUT + Cin))) + 1;

end Behavioral;
