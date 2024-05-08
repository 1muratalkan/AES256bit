library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shiftrows is
port (
      shift_i : in std_logic_vector(127 downto 0); 
      shift_o : out std_logic_vector(127 downto 0) 
 );
end shiftrows;

architecture Behavioral of shiftrows is

begin

  -- 0. blok 16-12-8-4 <-- 16-12-8-4 
  --there are no shift in here
  shift_o(127 downto 120) <= shift_i(127 downto 120);
  shift_o(95  downto  88) <= shift_i(95  downto  88);
  shift_o(63  downto  56) <= shift_i(63  downto  56); 
  shift_o(31  downto  24) <= shift_i(31  downto  24);
  
  -- 1. blok 11-7-3-15 <-- 15-11-7-3
  shift_o(23  downto  16) <= shift_i(119 downto 112);
  shift_o(119 downto 112) <= shift_i(87  downto  80);
  shift_o(87  downto  80) <= shift_i(55  downto  48); 
  shift_o(55  downto  48) <= shift_i(23  downto  16);
   
  -- 2. blok 6-2-14-10 <-- 14-10-6-2
  shift_o(47  downto  40) <= shift_i(111 downto 104);
  shift_o(15  downto   8) <= shift_i(79  downto  72);
  shift_o(111 downto 104) <= shift_i(47  downto  40);
  shift_o(79  downto  72) <= shift_i(15  downto   8);
   
  -- 3. blok 1-13-9-5 <-- 13-9-5-1
  shift_o(71  downto  64) <= shift_i(103 downto  96); 
  shift_o(39  downto  32) <= shift_i(71  downto  64);   
  shift_o(7   downto   0) <= shift_i(39  downto  32);   
  shift_o(103 downto  96) <= shift_i(7   downto   0);   
   
end Behavioral;