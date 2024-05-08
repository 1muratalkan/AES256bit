library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity add_round_key is
    port (
          add_1_i : in std_logic_vector(127 downto 0); 
          add_2_i : in std_logic_vector(127 downto 0);
          add_o : out std_logic_vector(127 downto 0)
    );
end add_round_key;

architecture Behavioral of add_round_key is

begin
    add_o <= add_1_i xor add_2_i ;    
end Behavioral;