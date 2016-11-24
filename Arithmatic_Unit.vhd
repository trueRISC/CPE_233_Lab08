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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Arithmatic_Unit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end Arithmatic_Unit;

architecture Behavioral of Arithmatic_Unit is
    -- Declare Components
    component RCA_9bit is
    port (   A,B : in std_logic_vector(8 downto 0); 
            Cin : in std_logic;
	         Co : out std_logic; 
		    SUM : out std_logic_vector(8 downto 0)); 
    end component;
    
    component Comparator_9bit is
        Port ( A : in STD_LOGIC_VECTOR (8 downto 0);
               B : in STD_LOGIC_VECTOR (8 downto 0);
               EQ : out STD_LOGIC);
    end component;
    
    component TwosComp_8BitDefinition is
        Port ( INPUT : in STD_LOGIC_VECTOR (7 downto 0);
               Cin : in STD_LOGIC;
               OUTPUT : out STD_LOGIC_VECTOR (8 downto 0));
    end component;
    
    
    -- Signals
    signal s_Cin, s_2Comp_Cin : std_logic;
    signal s_A, s_B, s_RESULT, s_2Comp : std_logic_vector(8 downto 0);
    
begin
    -- Output is always the RCA result
    OUTPUT <= s_RESULT(7 downto 0);
    C <= s_RESULT(8);
    
    -- Define the components
    -- 9 bit rca to acommedate the entire range of 8 bit subtraction
    RCA : RCA_9Bit
    port map ( A => s_A,
               B => s_B,
               Cin => s_Cin,
               Co => open,
               SUM => s_RESULT);
               
    -- Comparator for zero flag
    ZeroComp: Comparator_9bit
    Port map ( A => s_RESULT,
               B => (others => '0'),
              EQ => Z);
              
    -- Twos Complimentor for subtraction
    twosComp: TwosComp_8BitDefinition 
    Port map ( INPUT => B,
                 Cin => s_2Comp_Cin,
              OUTPUT => s_2Comp);
               
    -- MUXs
    -- Cin mux
    process(Cin, SEL)
    begin
        if(SEL = "0001") then
            s_Cin <= Cin;
            s_2Comp_Cin <= '0';
        elsif(SEL = "0011") then
            s_Cin <= '0';
            s_2Comp_Cin <= Cin;
        else
            s_Cin <= '0';
            s_2Comp_Cin <= '0';
        end if;
    end process;
         
    -- A mux
    process (A, SEL)
    begin
        if(SEL = "1110") then
            s_A <= (others => '0');
        else
            s_A <= '0' & A;
        end if;
    end process;
    
    -- B Mux
    process (B, s_2Comp, SEL)
    begin
        if (SEL = "0010") or (SEL = "0011") or (SEL = "0100") then
            s_B <= s_2Comp;
        else
            s_B <= '0' & B;
        end if;
    end process;

end Behavioral;
