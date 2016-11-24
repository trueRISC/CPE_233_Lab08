----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2016 12:15:17 PM
-- Design Name: 
-- Module Name: Arithmatic_Unit - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity Logic_Unit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end Logic_Unit;

architecture Behavioral of Logic_Unit is
    -- Component Definitions
    component Comparator_9bit is
        Port ( A : in STD_LOGIC_VECTOR (8 downto 0);
               B : in STD_LOGIC_VECTOR (8 downto 0);
               EQ : out STD_LOGIC);
    end component;
    
    -- Signals
    signal s_Result : std_logic_vector(7 downto 0);
    signal s_CompRes : std_logic_vector(8 downto 0);
begin

    s_CompRes <= '0' & s_Result;
    OUTPUT <= s_Result;

    -- Component to test for zero flag
    ZeroComp: Comparator_9bit
    Port map ( A => s_CompRes,
               B => (others => '0'),
              EQ => Z);

    -- Logical Process
    process(A, B, SEL)
    begin
        case SEL is
            when "0101" => -- And Case
                s_Result <= A and B;
                C <= '0';
                
            when "0110" => -- Or Case
                s_Result <= A or B;
                C <= '0';
            
            when "0111" => -- Exor
                s_Result <= A xor B;
                C <= '0';
                
            when "1000" => -- Test
                s_Result <= A and B;
                C <= '0';            
            
            when "1001" => -- LSL
                s_Result <= A(6 downto 0) & Cin;
                C <= A(7);    
                
            when "1010" => -- LSR
                s_Result <= Cin & A(7 downto 1);
                C <= A(0);
            
            when "1011" => -- ROL
                s_Result <= A(6 downto 0) & A(7);
                C <= A(7);
            
            when "1100" => -- ROR
                s_Result <= A(0) & A(7 downto 1);
                C <= A(0);
            
            when "1101" => -- ASR
                s_Result <= A(7) & A(7 downto 1);
                C <= A(0);
            
            when others => -- Catch all
                s_Result <= (others => '1');
                C <= '0';
        end case;
    end process;

end Behavioral;
