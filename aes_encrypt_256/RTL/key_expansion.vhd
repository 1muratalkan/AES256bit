library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity key_expansion is
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
end key_expansion;

architecture Behavioral of key_expansion is

--register sinyallerim
signal flag_reg, flag_next : std_logic;
signal output_reg, output_next : std_logic_vector(255 downto 0);
signal i_reg, i_next   : unsigned(7 downto 0) := "00000000"; --rcon icin yaptim rounda göre sectirme eklenecek!!!

--Key expansion islemlerim
signal key_256 : std_logic_vector (255 downto 0);
signal key_256_out : std_logic_vector (255 downto 0);
signal RotWord : std_logic_vector(31 downto 0);
signal RotWord1 : std_logic_vector(31 downto 0);
signal Rcon : std_logic_vector(31 downto 0);
signal w0  : std_logic_vector(31 downto 0); 
signal w1  : std_logic_vector(31 downto 0); 
signal w2  : std_logic_vector(31 downto 0); 
signal w3  : std_logic_vector(31 downto 0); 
signal w4  : std_logic_vector(31 downto 0); 
signal w5  : std_logic_vector(31 downto 0); 
signal w6  : std_logic_vector(31 downto 0); 
signal w7  : std_logic_vector(31 downto 0); 
signal key_0 : std_logic_vector(31 downto 0);
signal key_1 : std_logic_vector(31 downto 0);
signal key_2 : std_logic_vector(31 downto 0);
signal key_3 : std_logic_vector(31 downto 0);
signal key_4 : std_logic_vector(31 downto 0);
signal key_5 : std_logic_vector(31 downto 0);
signal key_6 : std_logic_vector(31 downto 0);
signal key_7 : std_logic_vector(31 downto 0);


--Component Parts
component s_box is
    Port (
        input_byte : in std_logic_vector(7 downto 0);
        output_byte : out std_logic_vector(7 downto 0)
    );
end component;

component Rcon_table is
    Port (
        input_rcon  : in std_logic_vector(7 downto 0);
        output_rcon : out std_logic_vector(31 downto 0)
    );
end component;

begin

s_pro: process(clk_i)
    begin 
		 if (rising_edge(clk_i)) then
		    i_reg <= i_next;
            output_reg <= output_next; 
            flag_reg <= flag_next;
		end if;
end process s_pro;

--------------------------------------------------------------------------------
--ilk 128 128 alarak 256 bite donusum  
--------------------------------------------------------------------------------
flag_next <= '0' when reset_i = '1' else 
      not(flag_reg) when key_vld_i = '1' and key_ready_o ='1' else
      flag_reg;

i_next <= (others => '0') when reset_i = '1' or (key_vld_i ='1' and key_ready_o ='1') else 
    i_reg + 1 when sel_key = '0' and key_exp_start = '1' else 
    i_reg;
    
      
output_next(255 downto 128) <= input_key_exp when ((key_vld_i = '1') and (key_ready_o ='1') and (flag_reg = '0')) else 
    key_256_out(255 downto 128) when sel_key = '1' else 
    output_reg(255 downto 128);
    
output_next(127 downto 0) <= input_key_exp  when ((key_vld_i = '1')  and (key_ready_o ='1') and (flag_reg = '1')) else
    key_256_out(127 downto 0) when sel_key = '1' else 
    output_reg(127 downto 0);


----------------------------------------------------------------------------------------------------------------
--- Key_Expansion Part
----------------------------------------------------------------------------------------------------------------
key_256 <= output_reg; 

s1  : s_box port map (input_byte => key_256(23 downto 16),output_byte => RotWord(31 downto 24));
s2  : s_box port map (input_byte => key_256(15 downto 8),output_byte => RotWord(23 downto 16));
s3  : s_box port map (input_byte => key_256(7 downto 0),output_byte => RotWord(15 downto 8));
s4  : s_box port map (input_byte => key_256(31 downto 24),output_byte => RotWord(7 downto 0));

rcon_inst : Rcon_table port map(input_rcon => std_logic_vector(i_reg ), output_rcon => Rcon);

w0 <= key_256(255 downto 224) ; key_0 <= w0 xor Rotword xor Rcon;
w1 <= key_256(223 downto 192) ; key_1 <= w1 xor key_0;
w2 <= key_256(191 downto 160) ; key_2 <= w2 xor key_1;
w3 <= key_256(159 downto 128) ; key_3 <= w3 xor key_2;

s5 :s_box port map(input_byte => key_3(31 downto 24), output_byte => RotWord1(31 downto 24));
s6 :s_box port map(input_byte => key_3(23 downto 16), output_byte => RotWord1(23 downto 16));
s7 :s_box port map(input_byte => key_3(15 downto 8), output_byte => RotWord1(15 downto 8));
s8 :s_box port map(input_byte => key_3(7 downto 0), output_byte => RotWord1(7 downto 0));

w4 <= key_256(127 downto 96) ; key_4 <= w4 xor Rotword1;
w5 <= key_256(95 downto 64) ; key_5 <= w5 xor key_4;
w6 <= key_256(63 downto 32) ; key_6 <= w6 xor key_5;
w7 <= key_256(31 downto 0) ; key_7 <= w7 xor key_6;

key_256_out <= key_0 & key_1 & key_2 & key_3 & key_4 & key_5 & key_6 & key_7 ;

----------------------------------------------------------------------------------------------------------------
output_key_exp <= output_reg(127 downto 0) when sel_key = '1' else output_reg(255 downto 128);

end Behavioral;