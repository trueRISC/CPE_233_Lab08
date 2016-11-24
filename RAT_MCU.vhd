----------------------------------------------------------------------------------
-- Company: Ratner Engineering
-- Engineer: James Ratner
-- 
-- Create Date:    20:59:29 02/04/2013 
-- Design Name: 
-- Module Name:    RAT_MCU - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Starter MCU file for RAT MCU. 
--
-- Dependencies: 
--
-- Revision: 3.00
-- Revision: 4.00 (08-24-2016): removed support for multibus
-- Revision: 4.01 (11-01-2016): removed PC_TRI reference
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RAT_MCU is
    Port ( IN_PORT  : in  STD_LOGIC_VECTOR (7 downto 0);
           RESET    : in  STD_LOGIC;
           CLK      : in  STD_LOGIC;
           INT      : in  STD_LOGIC;
           OUT_PORT : out  STD_LOGIC_VECTOR (7 downto 0);
           PORT_ID  : out  STD_LOGIC_VECTOR (7 downto 0);
           IO_STRB  : out  STD_LOGIC);
end RAT_MCU;



architecture Behavioral of RAT_MCU is

   component prog_rom  
      port (     ADDRESS : in std_logic_vector(9 downto 0); 
             INSTRUCTION : out std_logic_vector(17 downto 0); 
                     CLK : in std_logic);  
   end component;

   component ALU
       Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
              B : in  STD_LOGIC_VECTOR (7 downto 0);
              Cin : in  STD_LOGIC;
              SEL : in  STD_LOGIC_VECTOR(3 downto 0);
              C : out  STD_LOGIC;
              Z : out  STD_LOGIC;
              RESULT : out  STD_LOGIC_VECTOR (7 downto 0));
   end component;

   component CONTROL_UNIT 
       Port ( CLK           : in   STD_LOGIC;
              C             : in   STD_LOGIC;
              Z             : in   STD_LOGIC;
              INT           : in   STD_LOGIC;
              RESET         : in   STD_LOGIC; 
              OPCODE_HI_5   : in   STD_LOGIC_VECTOR (4 downto 0);
              OPCODE_LO_2   : in   STD_LOGIC_VECTOR (1 downto 0);
              
              PC_LD         : out  STD_LOGIC;
              PC_INC        : out  STD_LOGIC;
              PC_MUX_SEL    : out  STD_LOGIC_VECTOR (1 downto 0);		  

              SP_LD         : out  STD_LOGIC;
              SP_INCR       : out  STD_LOGIC;
              SP_DECR       : out  STD_LOGIC;
 
              RF_WR         : out  STD_LOGIC;
              RF_WR_SEL     : out  STD_LOGIC_VECTOR (1 downto 0);

              ALU_OPY_SEL   : out  STD_LOGIC;
              ALU_SEL       : out  STD_LOGIC_VECTOR (3 downto 0);

              SCR_WR        : out  STD_LOGIC;
              SCR_ADDR_SEL  : out  STD_LOGIC_VECTOR (1 downto 0);

              FLG_C_LD      : out  STD_LOGIC;
              FLG_C_SET     : out  STD_LOGIC;
              FLG_C_CLR     : out  STD_LOGIC;
              FLG_SHAD_LD   : out  STD_LOGIC;
              FLG_LD_SEL    : out  STD_LOGIC;
              FLG_Z_LD      : out  STD_LOGIC;
              
              I_FLAG_SET    : out  STD_LOGIC;
              I_FLAG_CLR    : out  STD_LOGIC;

              RST           : out  STD_LOGIC;
              IO_STRB       : out  STD_LOGIC);
   end component;

   component RegisterFile 
       Port ( D_IN   : in     STD_LOGIC_VECTOR (7 downto 0);
              DX_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              DY_OUT : out    STD_LOGIC_VECTOR (7 downto 0);
              ADRX   : in     STD_LOGIC_VECTOR (4 downto 0);
              ADRY   : in     STD_LOGIC_VECTOR (4 downto 0);
              WR     : in     STD_LOGIC;
              CLK    : in     STD_LOGIC);
   end component;

   component PC 
      port ( RST,CLK,PC_LD,PC_INC : in std_logic; 
             FROM_IMMED : in std_logic_vector (9 downto 0); 
             FROM_STACK : in std_logic_vector (9 downto 0); 
             FROM_INTRR : in std_logic_vector (9 downto 0); 
             PC_MUX_SEL : in std_logic_vector (1 downto 0); 
             PC_COUNT   : out std_logic_vector (9 downto 0)); 
   end component; 
   
   component FlagReg
       Port ( D    : in  STD_LOGIC; --flag input
              LD   : in  STD_LOGIC; --load Q with the D value
              SET  : in  STD_LOGIC; --set the flag to '1'
              CLR  : in  STD_LOGIC; --clear the flag to '0'
              CLK  : in  STD_LOGIC; --system clock
              Q    : out  STD_LOGIC); --flag output
   end component;
   
   component Stack_Pointer
       Port ( RST : in STD_LOGIC;
              LD : in STD_LOGIC;
              INCR : in STD_LOGIC;
              DECR : in STD_LOGIC;
              DATA : in STD_LOGIC_VECTOR (7 downto 0);
              CLK : in STD_LOGIC;
              OUTPUT : in STD_LOGIC_VECTOR (7 downto 0));
   end component;

   -- intermediate signals ----------------------------------
   signal s_pc_ld : std_logic := '0'; 
   signal s_pc_inc : std_logic := '0'; 
   signal s_rst : std_logic := '0'; 
   signal s_pc_mux_sel : std_logic_vector(1 downto 0) := "00"; 
   signal s_pc_count : std_logic_vector(9 downto 0) := (others => '0');   
   signal s_inst_reg : std_logic_vector(17 downto 0) := (others => '0'); 
   signal s_DX_OUT, s_DY_OUT : std_logic_vector(7 downto 0);
   signal s_ALU_B : std_logic_vector(7 downto 0);
   signal s_C, s_Z : std_logic;
   signal s_ALU_C, s_ALU_Z : std_logic;
   signal s_ALU_RESULT : std_logic_vector(7 downto 0);
   signal s_ALU_SEL : std_logic_vector(3 downto 0);
   signal s_RF_WR : std_logic;
   signal s_RF_WR_SEL : std_logic_vector(1 downto 0);
   signal s_REG_IMMED_SEL : std_logic;
   signal s_FLG_C_SET, s_FLG_C_LD, S_FLG_C_CLR : std_logic;
   signal s_FLG_LD_SEL : std_logic;
   signal s_FLG_Z_LD : std_logic;
   signal s_IO_STRB : std_logic;
   signal s_REG_IN_MUX : std_logic_vector(7 downto 0);
   signal s_SCR_OUT : std_logic_vector(9 downto 0);
   signal s_SP_LD, s_SP_INCR, s_SP_DECR : std_logic;
   signal s_SP_OUT : std_logic_vector(7 downto 0);

   -- helpful aliases ------------------------------------------------------------------
   alias s_ir_immed_bits : std_logic_vector(9 downto 0) is s_inst_reg(12 downto 3); 
   
   

begin

   PORT_ID <= s_inst_reg(7 downto 0);
   OUT_PORT <= s_DX_OUT(7 downto 0);

   my_prog_rom: prog_rom  
   port map(     ADDRESS => s_pc_count, 
             INSTRUCTION => s_inst_reg, 
                     CLK => CLK); 

   my_alu: ALU
   port map ( A => s_DX_OUT,       
              B => s_ALU_B,       
              Cin => s_C,     
              SEL => s_ALU_SEL,     
              C => s_ALU_C,       
              Z => s_ALU_Z,       
              RESULT => s_ALU_RESULT); 


   my_cu: CONTROL_UNIT
   port map ( CLK           => CLK, 
              C             => s_C, 
              Z             => s_Z, 
              INT           => '0', 
              RESET         => RESET, 
              OPCODE_HI_5   => s_inst_reg(17 downto 13), 
              OPCODE_LO_2   => s_inst_reg(1 downto 0), 
              
              PC_LD         => s_pc_ld, 
              PC_INC        => s_pc_inc,  
              PC_MUX_SEL    => s_pc_mux_sel, 

              SP_LD         => s_SP_LD, 
              SP_INCR       => s_SP_INCR, 
              SP_DECR       => s_SP_DECR, 

              RF_WR         => s_RF_WR, 
              RF_WR_SEL     => s_RF_WR_SEL, 

              ALU_OPY_SEL   => s_REG_IMMED_SEL, 
              ALU_SEL       => s_ALU_SEL, 
              SCR_WR        => open, 
              SCR_ADDR_SEL  => open,              

              FLG_C_LD      => s_FLG_C_LD, 
              FLG_C_SET     => s_FLG_C_SET, 
              FLG_C_CLR     => s_FLG_C_CLR, 
              FLG_SHAD_LD   => open, 
              FLG_LD_SEL    => s_FLG_LD_SEL, 
              FLG_Z_LD      => s_FLG_Z_LD, 
              I_FLAG_SET    => open, 
              I_FLAG_CLR    => open,  

              RST           => open,
              IO_STRB       => IO_STRB);
              

   my_regfile: RegisterFile 
   port map ( D_IN   => s_REG_IN_MUX,   
              DX_OUT => s_DX_OUT,   
              DY_OUT => s_DY_OUT,   
              ADRX   => s_inst_reg(12 downto 8),   
              ADRY   => s_inst_reg(7 downto 3),     
              WR     => s_RF_WR,   
              CLK    => CLK); 


   my_PC: PC 
   port map ( RST        => s_RST,
              CLK        => CLK,
              PC_LD      => s_PC_LD,
              PC_INC     => s_PC_INC,
              FROM_IMMED => s_inst_reg(12 downto 3),
              FROM_STACK => s_SCR_OUT,
              FROM_INTRR => (others => '1'),
              PC_MUX_SEL => s_PC_MUX_SEL,
              PC_COUNT   => s_PC_COUNT); 

    C_FLAG: FlagReg
    port map ( D    => s_ALU_C,
               LD   => s_FLG_C_LD,
               SET  => s_FLG_C_SET,
               CLR  => s_FLG_C_CLR,
               CLK  => clk,
               Q    => s_C);
               
    Z_FLAG: FlagReg
    port map ( D    => s_ALU_Z,
               LD   => s_FLG_Z_LD,
               SET  => '0',
               CLR  => '0',
               CLK  => clk,
               Q    => s_Z);
               
    SP: Stack_Pointer
    port map ( RST => s_rst,
               LD => s_SP_LD,
               INCR => s_SP_INCR,
               DECR => s_SP_DECR,
               DATA => s_DX_OUT,
               CLK => CLK,
               OUTPUT => s_SP_OUT);

    -- The ALU Reg_Immed Selection Mux
    process(s_REG_IMMED_SEL, s_DY_OUT, s_inst_reg)
    begin
        if(s_REG_IMMED_SEL = '0') then
            s_ALU_B <= s_DY_OUT;
        else
            s_ALU_B <= s_inst_reg(7 downto 0);
        end if;
    end process;
    
    -- The REG_FILE Input mux
    process(IN_PORT, s_SCR_OUT, s_ALU_RESULT, s_RF_WR_SEL)
    begin
        if(s_RF_WR_SEL = "00") then
            s_REG_IN_MUX <= s_ALU_RESULT;
        elsif(s_RF_WR_SEL = "01") then
            s_REG_IN_MUX <= s_SCR_OUT(7 downto 0);
        elsif(s_RF_WR_SEL = "10") then
            s_REG_IN_MUX <= (others => '0');
        else
            s_REG_IN_MUX <= IN_PORT;
        end if;
    end process;

end Behavioral;

