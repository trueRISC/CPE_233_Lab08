----------------------------------------------------------------------------------
-- Company: Cal Poly CPE 233 
-- Engineer: Benjamin Davis Kayla  Foyt
-- 
-- Create Date: 09/30/2016 12:26:06 PM
-- Design Name: Program Counter
-- Module Name: PC - Behavioral
-- Project Name: Experiment 
-- Target Devices: Simulator
-- Tool Versions: 
-- Description: This is a basic implememntation of the program counter for assignment 1
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

entity PC is
    Port ( FROM_IMMED : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_STACK : in STD_LOGIC_VECTOR (9 downto 0);
           FROM_INTRR : in STD_LOGIC_VECTOR (9 downto 0);
           PC_MUX_SEL : in STD_LOGIC_VECTOR (1 downto 0);
           PC_LD : in STD_LOGIC;
           PC_INC : in STD_LOGIC;
           RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           PC_COUNT : out STD_LOGIC_VECTOR (9 downto 0));
end PC;

architecture Behavioral of PC is
    signal D_IN : STD_LOGIC_VECTOR(9 downto 0);
    signal s_count : STD_LOGIC_VECTOR(9 downto 0) := "0000000001";
begin

    mux: process(PC_MUX_SEL, FROM_IMMED, FROM_STACK)
    begin
        case PC_MUX_SEL is
            when "00" =>
                D_IN <= FROM_IMMED;
            when "01" =>
                D_IN <= FROM_STACK;
            when "10" =>
                D_IN <= FROM_INTRR;
            when others =>
                D_IN <= (OTHERS => '0');
        end case;
    end process;
    
    counter: process(D_IN, PC_LD, PC_INC, RST, CLK)
    begin
        if (RST = '1') then
            s_count <= (others => '0');
        elsif(rising_edge(CLK)) then
            if(PC_LD = '1') then
                s_count <= D_IN;
            elsif(PC_INC = '1') then
                s_count <= s_count + 1;
            end if;
        end if;
    end process;
    
    PC_COUNT <= s_count;

end Behavioral;
