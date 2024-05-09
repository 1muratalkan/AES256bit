library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use std.textio.all;
use IEEE.std_logic_textio.all;

entity tb_aes_encrypt_256 is
--  Port ( );
end tb_aes_encrypt_256;

architecture Behavioral of tb_aes_encrypt_256 is

component aes_encrypt_256 is
     port ( 
     clk_i                : in std_logic;
     reset_i              : in std_logic;
     --
     plain_text_i         : in std_logic_vector(127 downto 0);
     plain_text_vld_i     : in std_logic;
     plain_text_ready_o   : out std_logic;
     --
     key_i                : in std_logic_vector(127 downto 0);
     key_vld_i            : in std_logic;
     key_ready_o          : out std_logic; 
     --
     cipher_text_o        : out std_logic_vector(127 downto 0);
     cipher_text_vld_o    : out std_logic;
     cipher_text_ready_i  : in std_logic               
    );
end component;

signal  clk_i                : std_logic :='1';
signal  reset_i              : std_logic :='1';
signal  plain_text_i         : std_logic_vector(127 downto 0);
signal  plain_text_vld_i     : std_logic :='0';
signal  plain_text_ready_o   : std_logic;
signal  key_i                : std_logic_vector(127 downto 0);
signal  key_vld_i            : std_logic:='0';
signal  key_ready_o          : std_logic;
signal  cipher_text_o        : std_logic_vector(127 downto 0);
signal  cipher_text_vld_o    : std_logic;
signal  cipher_text_ready_i  : std_logic:='0';

-- Clock period definition
constant clk_period : time := 10 ns; -- 100 MHz

constant TEST_FILE_RD           :string  := "/home/murat/Documents/Uygulamalar/vivado/my_projects/aes_encrypt_256/aes_encrypt_256/aes_encrypt_256.srcs/sim_1/new/test_vectors.txt";
constant ECBGFSbox256_FILE_RD   :string  := "/home/murat/Documents/Uygulamalar/vivado/my_projects/aes_encrypt_256/aes_encrypt_256/aes_encrypt_256.srcs/sim_1/new/ECBGFSbox256.txt";
constant ECBVarKey256_FILE_RD   :string  := "/home/murat/Documents/Uygulamalar/vivado/my_projects/aes_encrypt_256/aes_encrypt_256/aes_encrypt_256.srcs/sim_1/new/ECBVarKey256.txt";
constant ECBVarTxt256_FILE_RD   :string  := "/home/murat/Documents/Uygulamalar/vivado/my_projects/aes_encrypt_256/aes_encrypt_256/aes_encrypt_256.srcs/sim_1/new/ECBVarTxt256.txt";
constant ECBKeySbox256_FILE_RD  :string  := "/home/murat/Documents/Uygulamalar/vivado/my_projects/aes_encrypt_256/aes_encrypt_256/aes_encrypt_256.srcs/sim_1/new/ECBKeySbox256.txt";

begin

    aes_encrypt_256_port : aes_encrypt_256
    port map (
        clk_i                =>   clk_i                ,
        reset_i              =>   reset_i              ,
        --                 
        plain_text_i         =>   plain_text_i         ,
        plain_text_vld_i     =>   plain_text_vld_i     ,
        plain_text_ready_o   =>   plain_text_ready_o   ,
        --                          
        key_i                =>   key_i                ,
        key_vld_i            =>   key_vld_i            ,
        key_ready_o          =>   key_ready_o          ,
        --                  
        cipher_text_o        =>   cipher_text_o        ,
        cipher_text_vld_o    =>   cipher_text_vld_o    ,
        cipher_text_ready_i  =>   cipher_text_ready_i                
    );

    -- clock process definitions
    clk_process : process
    begin
        clk_i <= '1';
        wait for clk_period/2;
        clk_i <= '0';
        wait for clk_period/2;
    end process clk_process;

    test_process : process
    
        procedure aes_procedure ( constant VECTOR_FILE : string;
                                  constant VECTOR_TYPE : string) is
        
        variable input_line   : line;
        variable COUNT        : integer;
        variable str_count    : string(1 to 8);             
        variable str_key      : string(1 to 6);             
        variable str_plain    : string(1 to 12);             
        variable str_cipher   : string(1 to 13); 
        variable PLAINTEXT    : std_logic_vector(127 downto 0);
        variable KEY          : std_logic_vector(255 downto 0);
        variable CIPHERTEXT   : std_logic_vector(127 downto 0);     
        
        file input_file : text open read_mode is VECTOR_FILE;
        
        begin
        
            while not endfile(input_file) loop
            
                readline(input_file, input_line);-- Read a row from the text file
              
                if input_line.all'length = 0 or input_line.all(1) = '#' then
                         next;
                end if;
                
                if input_line.all(1 to 9) = "[ENCRYPT]" then
                         next;
                
                elsif input_line.all(1 to 9) = "[DECRYPT]" then 
                         exit;
                end if;

                if input_line(1 to 8) = "COUNT = " then
                         read(input_line,str_count);
                         read(input_line,COUNT);
                         readline(input_file, input_line);
                end if;      
                   
                if input_line.all(1 to 6) = "KEY = " then
                         read(input_line,str_key);
                         hread(input_line,KEY);
                         readline(input_file, input_line);
                end if;     
                
                if input_line.all(1 to 12) = "PLAINTEXT = " then
                         read(input_line,str_plain);
                         hread(input_line,PLAINTEXT);
                         readline(input_file, input_line);
                 end if;
                   
                 if input_line.all(1 to 13) = "CIPHERTEXT = " then
                         read(input_line,str_cipher);
                         hread(input_line,CIPHERTEXT);
                         readline(input_file, input_line);        
                 end if;
                 
                --  
                wait for clk_period; wait for clk_period;wait for clk_period;wait for clk_period;
                plain_text_i <= PLAINTEXT; 
                plain_text_vld_i <= '1';  
                wait for clk_period;
                plain_text_i <= (others => '0');
                plain_text_vld_i <= '0';
                wait for clk_period;
                wait for clk_period;wait for clk_period;wait for clk_period; wait for clk_period;wait for clk_period;wait for clk_period;
                key_vld_i <= '1';
                key_i <= KEY(255 downto 128);--  
                wait for clk_period;
                key_i <= KEY(127 downto 0);--
                plain_text_i <= PLAINTEXT;
                wait for clk_period;
                key_i <= (others => '0');
                key_vld_i <= '0';
                key_i <= KEY(127 downto 0);--
                wait for clk_period*20;     
                cipher_text_ready_i <= '1';
                wait for clk_period;
                wait for clk_period;wait for clk_period; wait for clk_period;wait for clk_period;wait for clk_period;
                cipher_text_ready_i <= '0'; 
                --
            
               if cipher_text_o = CIPHERTEXT then
                   report VECTOR_TYPE & "File " & integer'image(COUNT) & ": SUCCESSFUL";
               else    
                   report VECTOR_TYPE & "File " & integer'image(COUNT) & ": FAIL";
               end if;
            
            end loop;
         
            file_close(input_file);
               
        end procedure aes_procedure;
        
         
    begin
                
        reset_i <= '1';
        wait for clk_period;
        reset_i <= '0';
        wait for clk_period;
        
        aes_procedure(TEST_FILE_RD, "TEST");
        aes_procedure(ECBGFSbox256_FILE_RD, "ECBGFSbox256");
        aes_procedure(ECBVarKey256_FILE_RD, "ECBVarKey256");
        aes_procedure(ECBVarTxt256_FILE_RD, "ECBVarTxt256");
        aes_procedure(ECBKeySbox256_FILE_RD, "ECBKeySbox256");
        
        report "--------------Simulation completed--------------" severity note;
        assert FALSE report "--------------Testbench completed--------------" severity FAILURE;
        
          
    end process test_process;


end Behavioral;
