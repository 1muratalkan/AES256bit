----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Murat ALKAN 
-- 
-- Create Date: 03/18/2024 02:33:41 PM
-- Design Name: 
-- Module Name: aes_encrypt_256 - Behavioral
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

entity aes_encrypt_256 is
    Port (
     clk_i                : in std_logic;
     reset_i              : in std_logic;
     --
     plain_text_i       : in std_logic_vector(127 downto 0);
     plain_text_vld_i   : in std_logic;
     plain_text_ready_o : out std_logic;
     --
     key_i              : in std_logic_vector(127 downto 0);
     key_vld_i          : in std_logic;
     key_ready_o        : out std_logic; 
     --
     cipher_text_o      : out std_logic_vector(127 downto 0);
     cipher_text_vld_o  : out std_logic;
     cipher_text_ready_i: in std_logic        
    
     );
end aes_encrypt_256;

architecture Behavioral of aes_encrypt_256 is
 
--Mux
component mux is
    Port ( 
        sel_mux : in std_logic_vector(1 downto 0);
        mux_0_i, mux_1_i, mux_2_i : in std_logic_vector(127 downto 0);
        mux_o : out std_logic_vector(127 downto 0)    
    );
end component;

--AddRoundKey
component add_round_key is
    port (
          add_1_i : in std_logic_vector(127 downto 0); 
          add_2_i : in std_logic_vector(127 downto 0);
          add_o : out std_logic_vector(127 downto 0)
    );
end component;

--SubBytes
component subbytes is
    port(
        sub_i : in std_logic_vector(127 downto 0);
        sub_o : out std_logic_vector(127 downto 0)
     );
end component;

--ShiftRows
component ShiftRows is
port (
      shift_i : in std_logic_vector(127 downto 0); 
      shift_o : out std_logic_vector(127 downto 0) 
 );
end component;

--MixColumns
component MixColumns is
    Port (
        mix_i : in std_logic_vector(127 downto 0);
        mix_o : out std_logic_vector(127 downto 0)       
    );
     
end component;

--Control_unit
component control_unit is
port (
    clk_i               : in std_logic;
    reset_i             : in std_logic;
    plain_text_vld_i    : in std_logic;
    key_vld_i           : in std_logic;
    cipher_text_ready_i : in std_logic;
    sel_mux             : out std_logic_vector(1 downto 0);
    enc_finish          : out std_logic;
    sel_key             : out std_logic;
    key_exp_start       : out std_logic;
    plain_text_ready_o  : out std_logic;
    key_ready_o         : out std_logic;
    cipher_text_vld_o   : out std_logic
);
end component;

component key_expansion is
port(
    clk_i           : in std_logic;
    reset_i         : in std_logic;
    input_key_exp   : in std_logic_vector( 127 downto 0);
    sel_key         : in std_logic;
    key_vld_i       : in std_logic;
    key_exp_start   : in std_logic;
    key_ready_o     : in std_logic;
    output_key_exp  : out std_logic_vector (127 downto 0)
);
end component;

-----------------------------------------------------------------------------------------
signal mux_to_reg           : std_logic_vector(127 downto 0);
signal reg_to_add           : std_logic_vector(127 downto 0);
signal add_to_sub           : std_logic_vector(127 downto 0);
signal key_to_sub           : std_logic_vector(127 downto 0);
signal enc_finish           :  std_logic;
signal add_to_cip           : std_logic_vector(127 downto 0);
signal sub_to_shift         : std_logic_vector(127 downto 0);
signal shift_to_mix         : std_logic_vector(127 downto 0);
signal mix_to_mux           : std_logic_vector(127 downto 0);
signal control_to_mux       : std_logic_vector(1 downto 0);
signal control_to_key       : std_logic;
signal control_to_start     : std_logic;
signal exp_to_add           : std_logic_vector(127 downto 0);
signal r_reg,r_next         : std_logic_vector (127 downto 0);
signal c_o_reg,c_o_next     : std_logic_vector (127 downto 0);
signal cipher_text_vld_o_o  : std_logic;
signal plain_text_ready_o_o : std_logic;
signal key_ready_o_o        : std_logic;
---------------------------------------------------------------------------------------

begin

mux_inst : mux 
        port map(
          sel_mux   => control_to_mux,
          mux_0_i   => plain_text_i,
          mux_1_i   => mix_to_mux,
          mux_2_i   => shift_to_mix,
          mux_o     => mux_to_reg                
        );

 add_round_key_inst :add_round_key 
        port map(
		  add_1_i => r_reg,
		  add_2_i => exp_to_add,
		  add_o => add_to_sub
		);

 subbytes_inst : subbytes
        port map (
           sub_i =>add_to_sub,
           sub_o =>sub_to_shift
        );
        
	
 shiftrows_inst : ShiftRows
        port map (
          shift_i =>sub_to_shift,
          shift_o =>shift_to_mix
        );
    
 mixcolumns_inst : MixColumns
        port map (
          mix_i =>shift_to_mix,
          mix_o =>mix_to_mux
        );

control_unit_inst : control_unit
        port map(
          clk_i               => clk_i ,
          reset_i             => reset_i,
          plain_text_vld_i    => plain_text_vld_i,
          key_vld_i           => key_vld_i,
          cipher_text_ready_i => cipher_text_ready_i,
          sel_mux             => control_to_mux,
          sel_key             => control_to_key,
          enc_finish          => enc_finish,
          key_exp_start       => control_to_start,
          plain_text_ready_o  => plain_text_ready_o_o,
          key_ready_o         => key_ready_o_o,
          cipher_text_vld_o   => cipher_text_vld_o_o
        );
        
key_expansion_inst : key_expansion
    port map (
    clk_i           => clk_i,
    reset_i         => reset_i,
    input_key_exp   => key_i  ,
    sel_key         => control_to_key,
    key_vld_i       => key_vld_i,
    key_ready_o     => key_ready_o_o,
    key_exp_start   => control_to_start,
    output_key_exp  => exp_to_add
    );


process(clk_i)
    begin 
        if (rising_edge(clk_i)) then
            r_reg <= r_next ;
            c_o_reg <= c_o_next ;
        end if;
end process;

r_next <= (others => '0') when reset_i = '1' else
          plain_text_i when  plain_text_vld_i = '1' and plain_text_ready_o_o ='1' else
          mux_to_reg  when control_to_mux /= "00" else
          r_reg;
                  
c_o_next <= (others => '0') when reset_i = '1' else
            add_to_sub when enc_finish = '1' else
            c_o_reg;
     
cipher_text_vld_o <= cipher_text_vld_o_o;
plain_text_ready_o <= plain_text_ready_o_o;

cipher_text_o <= c_o_reg;
key_ready_o <= key_ready_o_o;

end Behavioral;