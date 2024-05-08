library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux is
    Port ( 
        sel_mux : in std_logic_vector(1 downto 0);
        mux_0_i, mux_1_i, mux_2_i : in std_logic_vector(127 downto 0);
        mux_o : out std_logic_vector(127 downto 0)      
    );
end mux;

architecture Behavioral of mux is

begin
    process(sel_mux, mux_0_i, mux_1_i, mux_2_i)
    begin
        case sel_mux is
            when "00" =>
                mux_o <= mux_0_i;
            when "01" =>
                mux_o <= mux_1_i;
            when "10" =>
                mux_o <= mux_2_i;
            when others =>
                mux_o <= (others => '0');
        end case;
    end process;

end Behavioral;