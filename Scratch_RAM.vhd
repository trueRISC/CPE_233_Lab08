----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/14/2016 12:53:00 PM
-- Design Name: 
-- Module Name: Scratch_RAM - Behavioral
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

entity Scratch_RAM is
    Port ( DATA_IN : in STD_LOGIC_VECTOR (9 downto 0);
           WR : in STD_LOGIC;
           ADDR : in STD_LOGIC_VECTOR (7 downto 0);
           CLK : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR (9 downto 0));
end Scratch_RAM;

architecture Behavioral of Scratch_RAM is
    TYPE memory is array (0 to 255) of std_logic_vector(9 downto 0);
	SIGNAL RAM: memory := (others=>(others=>'0'));
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
	      if (WR = '1') then
			RAM(conv_integer(ADDR)) <= DATA_IN;
		  end if;
		end if;
	end process;

	DATA_OUT <= RAM(conv_integer(ADDR));
    

end Behavioral;
