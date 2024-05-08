library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mixcolumns is
    Port (
        mix_i : in std_logic_vector(127 downto 0);
        mix_o : out std_logic_vector(127 downto 0)       
    );
end mixcolumns;

architecture Behavioral of mixcolumns is

component gf_two is
    Port ( 
        gf_two_i : in STD_LOGIC_VECTOR (7 downto 0);
        gf_two_o : out STD_LOGIC_VECTOR (7 downto 0)
        );    
end component;
    
component gf_three is
    Port (
        gf_three_i : in STD_LOGIC_VECTOR (7 downto 0);
        gf_three_o : out STD_LOGIC_VECTOR (7 downto 0)
     );
end component;
----------------------------------------------------------------------------------------signals

--MSB
signal sixt_2   :  std_logic_vector(7 downto 0); signal sixt_3   :  std_logic_vector(7 downto 0);

signal fift_2   :  std_logic_vector(7 downto 0); signal fift_3   :  std_logic_vector(7 downto 0);

signal fourt_2  :  std_logic_vector(7 downto 0); signal fourt_3  :  std_logic_vector(7 downto 0);

signal thirt_2  :  std_logic_vector(7 downto 0); signal thirt_3  :  std_logic_vector(7 downto 0);

signal twelve_2 :  std_logic_vector(7 downto 0); signal twelve_3 :  std_logic_vector(7 downto 0);

signal eleven_2 :  std_logic_vector(7 downto 0); signal eleven_3 :  std_logic_vector(7 downto 0);

signal ten_2    :  std_logic_vector(7 downto 0); signal ten_3    :  std_logic_vector(7 downto 0);

signal nine_2   :  std_logic_vector(7 downto 0); signal nine_3   :  std_logic_vector(7 downto 0);

signal eight_2  :  std_logic_vector(7 downto 0); signal eight_3  :  std_logic_vector(7 downto 0);
    
signal seven_2  :  std_logic_vector(7 downto 0); signal seven_3  :  std_logic_vector(7 downto 0);

signal six_2    :  std_logic_vector(7 downto 0); signal six_3    :  std_logic_vector(7 downto 0);

signal five_2   :  std_logic_vector(7 downto 0); signal five_3   :  std_logic_vector(7 downto 0);

signal four_2   :  std_logic_vector(7 downto 0); signal four_3   :  std_logic_vector(7 downto 0);

signal three_2  :  std_logic_vector(7 downto 0); signal three_3  :  std_logic_vector(7 downto 0);

signal two_2    :  std_logic_vector(7 downto 0); signal two_3    :  std_logic_vector(7 downto 0);

signal one_2    :  std_logic_vector(7 downto 0); signal one_3    :  std_logic_vector(7 downto 0);
--LSB

begin

sixteen2: gf_two port map (gf_two_i => mix_i(127 downto 120),gf_two_o  => sixt_2(7 downto 0)); 
sixteen3: gf_three port map (gf_three_i => mix_i(119 downto 112),gf_three_o  => sixt_3(7 downto 0)); 
mix_o(127 downto 120) <= sixt_3 xor sixt_2 xor mix_i(111 downto 104) xor mix_i(103 downto 96) ;

fifteen2: gf_two port map (gf_two_i => mix_i(119 downto 112),gf_two_o  => fift_2(7 downto 0)); 
fifteen3: gf_three port map (gf_three_i => mix_i(111 downto 104),gf_three_o  => fift_3(7 downto 0)); 
mix_o(119 downto 112) <= fift_3 xor fift_2 xor mix_i(127 downto 120)   xor mix_i(103 downto 96)  ;

fourteen2 : gf_two port map (gf_two_i => mix_i(111 downto 104),gf_two_o  => fourt_2(7 downto 0));       
fourteen3 : gf_three port map (gf_three_i => mix_i(103 downto 96),gf_three_o  => fourt_3(7 downto 0)); 
mix_o(111 downto 104) <= fourt_3 xor fourt_2 xor mix_i(127 downto 120)   xor mix_i(119 downto 112)  ;

thirteen2 : gf_two port map (gf_two_i => mix_i(103 downto 96),gf_two_o  => thirt_2(7 downto 0));       
thirteen3 : gf_three port map (gf_three_i => mix_i(127 downto 120),gf_three_o  => thirt_3(7 downto 0)); 
mix_o(103 downto 96) <= thirt_3 xor thirt_2 xor mix_i(119 downto 112)   xor mix_i(111 downto 104)  ;
--4 lü 
twelve2: gf_two port map (gf_two_i => mix_i(95 downto 88),gf_two_o  => twelve_2(7 downto 0)); 
twelve3: gf_three port map (gf_three_i => mix_i(87 downto 80),gf_three_o  => twelve_3(7 downto 0)); 
mix_o(95 downto 88) <= twelve_3 xor twelve_2 xor mix_i(79 downto 72)   xor mix_i(71 downto 64)  ;

eleven2: gf_two port map (gf_two_i => mix_i(87 downto 80),gf_two_o  => eleven_2(7 downto 0)); 
eleven3: gf_three port map (gf_three_i => mix_i(79 downto 72),gf_three_o  => eleven_3(7 downto 0)); 
mix_o(87 downto 80) <= eleven_3 xor eleven_2 xor mix_i(95 downto 88)   xor mix_i(71 downto 64)  ;

ten2: gf_two port map (gf_two_i => mix_i(79 downto 72),gf_two_o  => ten_2(7 downto 0)); 
ten3: gf_three port map (gf_three_i => mix_i(71 downto 64),gf_three_o  => ten_3(7 downto 0)); 
mix_o(79 downto 72) <= ten_3 xor ten_2 xor mix_i(87 downto 80)   xor mix_i(95 downto 88)  ;

nine2: gf_two port map (gf_two_i => mix_i(71 downto 64),gf_two_o  => nine_2(7 downto 0)); 
nine3: gf_three port map (gf_three_i => mix_i(95 downto 88),gf_three_o  => nine_3(7 downto 0)); 
mix_o(71 downto 64)<= nine_3 xor nine_2 xor mix_i(87 downto 80)   xor mix_i(79 downto 72)  ;
--4 lü 
eight2: gf_two port map (gf_two_i => mix_i(63 downto 56),gf_two_o  => eight_2(7 downto 0)); 
eight3: gf_three port map (gf_three_i => mix_i(55 downto 48),gf_three_o  => eight_3(7 downto 0)); 
mix_o(63 downto 56) <= eight_3 xor eight_2 xor mix_i(47 downto 40)   xor mix_i(39 downto 32)  ;

seven2: gf_two port map (gf_two_i => mix_i(55 downto 48),gf_two_o  => seven_2(7 downto 0)); 
seven3: gf_three port map (gf_three_i => mix_i(47 downto 40),gf_three_o  => seven_3(7 downto 0)); 
mix_o(55 downto 48)  <= seven_3 xor seven_2 xor mix_i(63 downto 56)   xor mix_i(39 downto 32)  ;

six2: gf_two port map (gf_two_i => mix_i(47 downto 40),gf_two_o  => six_2(7 downto 0)); 
six3: gf_three port map (gf_three_i => mix_i(39 downto 32),gf_three_o  => six_3(7 downto 0)); 
mix_o(47 downto 40) <= six_3 xor six_2 xor mix_i(55 downto 48)   xor mix_i(63 downto 56)  ;

five2: gf_two port map (gf_two_i => mix_i(39 downto 32),gf_two_o  => five_2(7 downto 0)); 
five3: gf_three port map (gf_three_i => mix_i(63 downto 56),gf_three_o  => five_3(7 downto 0)); 
mix_o(39 downto 32)  <= five_3 xor five_2 xor mix_i(47 downto 40) xor mix_i(55 downto 48)  ;
--4 lü
four2: gf_two port map (gf_two_i => mix_i(31 downto 24),gf_two_o  => four_2(7 downto 0)); 
four3: gf_three port map (gf_three_i => mix_i(23 downto 16),gf_three_o  => four_3(7 downto 0)); 
mix_o(31 downto 24) <= four_3 xor four_2 xor mix_i(15 downto 8)   xor mix_i(7 downto 0)  ;

three2: gf_two port map (gf_two_i => mix_i(23 downto 16),gf_two_o  => three_2(7 downto 0)); 
three3: gf_three port map (gf_three_i => mix_i(15 downto 8),gf_three_o  => three_3(7 downto 0)); 
mix_o(23 downto 16) <= three_3 xor three_2 xor mix_i(31 downto 24)   xor mix_i(7 downto 0)  ;

two2: gf_two port map (gf_two_i => mix_i(15 downto 8),gf_two_o  => two_2(7 downto 0)); 
two3: gf_three port map (gf_three_i => mix_i(7 downto 0),gf_three_o  => two_3(7 downto 0)); 
mix_o(15 downto 8)  <= two_3 xor two_2 xor mix_i(31 downto 24)   xor mix_i(23 downto 16)  ;

one2: gf_two port map (gf_two_i => mix_i(7 downto 0),gf_two_o  => one_2(7 downto 0)); 
one3: gf_three port map (gf_three_i => mix_i(31 downto 24),gf_three_o  => one_3(7 downto 0)); 
mix_o(7 downto 0) <= one_3 xor one_2 xor mix_i(23 downto 16) xor mix_i(15 downto 8)  ;

end Behavioral;