library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Rcon_table is
    Port (
        input_rcon  : in std_logic_vector(7 downto 0);
        output_rcon : out std_logic_vector(31 downto 0)
    );
end Rcon_table;

architecture Behavioral of Rcon_table is
begin

	process(input_rcon)
	begin
	
		case input_rcon is
			
			--when "00000000"=>output_rcon<=x"00000000";
			when "00000001"=>output_rcon<=x"01000000";
			when "00000010"=>output_rcon<=x"02000000";
			when "00000011"=>output_rcon<=x"04000000";
			when "00000100"=>output_rcon<=x"08000000";
			when "00000101"=>output_rcon<=x"10000000";
			when "00000110"=>output_rcon<=x"20000000";
			when "00000111"=>output_rcon<=x"40000000";
			
			when others=> output_rcon <= x"00000000";
		end case;
	end process;


end Behavioral;