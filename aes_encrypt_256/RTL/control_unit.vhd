library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_unit is
port (
--input
clk_i               : in std_logic;
reset_i             : in std_logic;
plain_text_vld_i    : in std_logic;
key_vld_i           : in std_logic;
cipher_text_ready_i : in std_logic;
--output
sel_mux             : out std_logic_vector(1 downto 0);
sel_key             : out std_logic;
enc_finish          : out std_logic;
key_exp_start       : out std_logic;
plain_text_ready_o  : out std_logic;
key_ready_o         : out std_logic;
cipher_text_vld_o   : out std_logic
);
end control_unit;

architecture Behavioral of control_unit is

type state_type  is (PLAIN_TEXT_WAIT, KEY_WAIT_1,KEY_WAIT_2, FIRST_ROUND , MIDDLE_ROUND, ROUND_14, FINAL, DONE);

signal state_reg, state_next: state_type ;
signal round_value_reg , round_value_next : unsigned(3 downto 0);

begin

seq : process(clk_i)
begin
    if (rising_edge(clk_i)) then	
	   state_reg <= state_next;
	   round_value_reg  <= round_value_next;			
    end if;	
end process seq;

com1 : process(all)
begin
    if reset_i='1' then
        round_value_next <=  "0000";    
        plain_text_ready_o <= '0';
        cipher_text_vld_o <= '0';
        key_exp_start <='0';
        key_ready_o <= '0';
        sel_key<= '0';
        enc_finish <='0';
        round_value_next <= round_value_reg;--  
        sel_mux<="00";     
    else 
        --default assignments
        plain_text_ready_o <= '0';
        cipher_text_vld_o <= '0';
        key_exp_start <='0';
        key_ready_o <= '0';
        sel_key<= '0';
        enc_finish <='0';
        round_value_next <= round_value_reg;--
        sel_mux<="00";  
        case state_reg is
        
                when PLAIN_TEXT_WAIT => 
              
                        plain_text_ready_o <= '1'; 
                        round_value_next <= (others =>'0');
                        
                when KEY_WAIT_1 =>                             
                        key_ready_o <= '1';
 
                when KEY_WAIT_2 =>
                        key_ready_o <= '1';                                         

                when FIRST_ROUND => 
                        round_value_next <= round_value_reg + 1;    
                                            
                when MIDDLE_ROUND => 
                        key_exp_start <='1'; 				
                        sel_mux<= "01";
                        
                        if round_value_next(0) ='1' then 
                            sel_key<= '1';                    
                        end if;
                        round_value_next <= round_value_reg + 1; 
          
                when ROUND_14 =>
                        key_exp_start <='1';        
                        sel_mux<="10";
                        sel_key<= '1'; 
    
                when FINAL => 
                        key_exp_start <='1'; 
                        enc_finish <='1';
                        sel_mux<="10";
                when DONE => 
                        key_exp_start <='1'; 		       
                        cipher_text_vld_o <= '1';
                        sel_mux<="10";
    end case;
    end if;
end process com1;


com2 : process(all)
begin
    if reset_i ='1' then
        state_next <=  PLAIN_TEXT_WAIT;
        state_next <= state_reg;  
    else 
        state_next <= state_reg;       
        case state_reg is
        
                    when PLAIN_TEXT_WAIT =>
                        if plain_text_vld_i ='1'   then 
                            state_next <= KEY_WAIT_1 ; 
                        end if;
        
                    when KEY_WAIT_1 =>
                        if   key_vld_i='1' then 
                            state_next <= KEY_WAIT_2 ;
                        end if;   
                                    
                    when KEY_WAIT_2 =>
                        if key_vld_i ='1'  then 
                            state_next <= FIRST_ROUND ;
                        end if;              
                                
                    when FIRST_ROUND =>                       
                        state_next <= MIDDLE_ROUND ;
                    
                    when MIDDLE_ROUND =>
                        if round_value_next = "1110" then 
                            state_next <= ROUND_14;  
                        end if;
                    when ROUND_14 =>
                        state_next <= FINAL ;
                    
                    when FINAL =>
                        state_next <= DONE; 
              
                    when DONE =>
                        if cipher_text_ready_i ='1' then
                            state_next <= PLAIN_TEXT_WAIT; 
                        end if;
                                
    end case;
    end if;
end process com2;

end Behavioral;
