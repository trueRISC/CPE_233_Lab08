----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/24/2016 12:01:50 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end ALU;

architecture Behavioral of ALU is
    -- Define components
    component Arithmatic_Unit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           Cin : in STD_LOGIC;
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
    end component;
    
    component Logic_Unit is
    Port ( A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           SEL : in STD_LOGIC_VECTOR (3 downto 0);
           Cin : in STD_LOGIC;
           OUTPUT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
    end component;
    
    -- Signal definitions
    signal s_Arith_Out, s_Logic_Out : std_logic_vector(7 downto 0);
    signal s_Arith_C, s_Arith_Z, s_Logic_C, s_Logic_Z : std_logic;
begin

    -- Instansiate Components
    Arith_Unit: Arithmatic_Unit
    Port map ( A => A,
               B => B,
               Cin => Cin,
               SEL => SEL,
               OUTPUT => s_Arith_Out,
               C => s_Arith_C,
               Z => s_Arith_Z);

    Log_Unit: Logic_Unit
    Port map ( A => A,
               B => B,
               Cin => Cin,
               SEL => SEL,
               OUTPUT => s_Logic_Out,
               C => s_Logic_C,
               Z => s_Logic_Z);

    -- Mux to decide whether to use the logical output or the arithmatic output
    process(A, B, SEL, Cin)
    begin
        case SEL is
            -- Use Arithmatic outputs
            when "0000" | "0001" | "0010" | "0011" | "0100" | "1110" =>
                RESULT <= s_Arith_Out;
                C <= s_Arith_C;
                Z <= s_Arith_Z;
            
            -- Not defined
            when "1111" => 
                RESULT <= (others => '0');
                C <= '0';
                Z <= '0';
            
            -- Use Logical Output
            when others =>
                RESULT <= s_Logic_Out;
                C <= s_Logic_C;
                Z <= s_Logic_Z;
        end case;
    end process;

end Behavioral;
