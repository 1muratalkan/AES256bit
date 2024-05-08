library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity gf_two is 
    Port ( 
        gf_two_i : in STD_LOGIC_VECTOR (7 downto 0);
        gf_two_o : out STD_LOGIC_VECTOR (7 downto 0)
        );    
    end gf_two;

architecture Behavioral of gf_two is

begin

process(gf_two_i)
begin
    gf_two_o <= gf_two_i(6 downto 0) & '0';
    
    if gf_two_i(7) = '1' then
        gf_two_o <= (gf_two_i(6 downto 0) & '0') xor "00011011";   
    end if;      
end process;

end Behavioral;