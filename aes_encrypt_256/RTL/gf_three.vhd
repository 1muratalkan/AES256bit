library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gf_three is
Port (
        gf_three_i : in STD_LOGIC_VECTOR (7 downto 0);
        gf_three_o : out STD_LOGIC_VECTOR (7 downto 0)
     );
end gf_three;

architecture Behavioral of gf_three is

begin

process(gf_three_i)
begin 

    gf_three_o <=  gf_three_i xor  gf_three_i(6 downto 0) & '0' ;
    if gf_three_i(7) = '1' then
        gf_three_o <= (gf_three_i xor  gf_three_i(6 downto 0) & '0') xor "00011011";            
    end if;
    
end process;
end Behavioral;