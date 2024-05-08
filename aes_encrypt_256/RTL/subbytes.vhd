library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity subbytes is
    port(
        sub_i : in std_logic_vector(127 downto 0);
        sub_o : out std_logic_vector(127 downto 0)
     );
end subbytes;

architecture Behavioral of subbytes is

component s_box is
    Port (
        input_byte : in std_logic_vector(7 downto 0);
        output_byte : out std_logic_vector(7 downto 0)
    );
end component;

begin

s1  : s_box port map (input_byte => sub_i(127 downto 120),output_byte => sub_o(127 downto 120)); 
s2  : s_box port map (input_byte => sub_i(119 downto 112),output_byte => sub_o(119 downto 112)); 
s3  : s_box port map (input_byte => sub_i(111 downto 104),output_byte => sub_o(111 downto 104)); 
s4  : s_box port map (input_byte => sub_i(103 downto  96),output_byte => sub_o(103 downto  96)); 
s5  : s_box port map (input_byte => sub_i( 95 downto  88),output_byte => sub_o( 95 downto  88)); 
s6  : s_box port map (input_byte => sub_i( 87 downto  80),output_byte => sub_o( 87 downto  80)); 
s7  : s_box port map (input_byte => sub_i( 79 downto  72),output_byte => sub_o( 79 downto  72)); 
s8  : s_box port map (input_byte => sub_i( 71 downto  64),output_byte => sub_o( 71 downto  64)); 
s9  : s_box port map (input_byte => sub_i( 63 downto  56),output_byte => sub_o( 63 downto  56)); 
s10 : s_box port map (input_byte => sub_i( 55 downto  48),output_byte => sub_o( 55 downto  48)); 
s11 : s_box port map (input_byte => sub_i( 47 downto  40),output_byte => sub_o( 47 downto  40)); 
s12 : s_box port map (input_byte => sub_i( 39 downto  32),output_byte => sub_o( 39 downto  32)); 
s13 : s_box port map (input_byte => sub_i( 31 downto  24),output_byte => sub_o( 31 downto  24)); 
s14 : s_box port map (input_byte => sub_i( 23 downto  16),output_byte => sub_o( 23 downto  16)); 
s15 : s_box port map (input_byte => sub_i( 15 downto   8),output_byte => sub_o( 15 downto   8)); 
s16 : s_box port map (input_byte => sub_i(  7 downto   0),output_byte => sub_o( 7  downto   0)); 


end Behavioral;