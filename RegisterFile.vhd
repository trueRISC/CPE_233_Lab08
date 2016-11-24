----------------------------------------------------------------------------------
-- Company:  RAT Technologies 
-- Engineer:  James Ratner
-- 
-- Create Date:    20:09:32 01/24/2013 
-- Design Name: 
-- Module Name:    RegisterFile
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:  Example dual-port RAM. This RAM can read from 
--               two different locations and write one location (the 
--               "X" channel). 
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

entity RegisterFile is
    Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
           DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
           ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
           ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
           WR     : in     STD_LOGIC;
           CLK    : in     STD_LOGIC);
end RegisterFile;

architecture Behavioral of RegisterFile is
	TYPE memory is array (0 to 31) of std_logic_vector(7 downto 0);
	SIGNAL REG: memory := (others=>(others=>'0'));
begin

	process(clk)
	begin
		if (rising_edge(clk)) then
	          if (WR = '1') then
			REG(conv_integer(ADRX)) <= D_IN;
		  end if;
		end if;
	end process;

	DX_OUT <= REG(conv_integer(ADRX));
	DY_OUT <= REG(conv_integer(ADRY));
	
end Behavioral;
