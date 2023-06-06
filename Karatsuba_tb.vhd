LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY Karatsuba_tb IS END Karatsuba_tb;
ARCHITECTURE test1 OF Karatsuba_tb IS
  COMPONENT Karatsuba256 IS
    GENERIC (
		wid : INTEGER := 256
		);
    PORT(
        m : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	r : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	start : IN STD_LOGIC;
	result : OUT STD_LOGIC_VECTOR(2*wid - 1 DOWNTO 0);
	done : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT Karatsuba128 IS
    GENERIC (
		wid : INTEGER := 128
		);
    PORT(
        m : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	r : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	start : IN STD_LOGIC;
	result : OUT STD_LOGIC_VECTOR(2*wid - 1 DOWNTO 0);
	done : OUT STD_LOGIC
    );
  END COMPONENT;
  COMPONENT Karatsuba64 IS
    GENERIC (
		wid : INTEGER := 64
		);
    PORT(
        m : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	r : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	clk : IN STD_LOGIC;
	rst : IN STD_LOGIC;
	start : IN STD_LOGIC;
	result : OUT STD_LOGIC_VECTOR(2*wid - 1 DOWNTO 0);
	done : OUT STD_LOGIC
    );
  END COMPONENT;
  SIGNAL t_rst    : std_logic;
  SIGNAL t_clk    : std_logic := '0';
  SIGNAL t_start  : std_logic;
  SIGNAL t_m128	     : std_logic_vector(127 DOWNTO 0);
  SIGNAL t_r128      : std_logic_vector(127 DOWNTO 0);
  SIGNAL t_result256 : std_logic_vector(255 DOWNTO 0);	
  SIGNAL t_m64	     : std_logic_vector(63 DOWNTO 0);
  SIGNAL t_r64       : std_logic_vector(63 DOWNTO 0);
  SIGNAL t_result128 : std_logic_vector(127 DOWNTO 0);
  SIGNAL t_m256      : std_logic_vector(255 DOWNTO 0);  
  SIGNAL t_r256      : std_logic_vector(255 DOWNTO 0); 	
  SIGNAL t_result512 : std_logic_vector(511 DOWNTO 0);
  SIGNAL t_done   : std_logic;	
BEGIN
  t_clk <= NOT t_clk AFTER 5 ns;
  t_rst <= '1', '0' AFTER 30 ns;
  
  PROCESS 
  BEGIN
  t_start <= '0';
  t_m128 <= X"0000000000000000000000007FF866B3"; --X"0000000000000000000000000000007B";  --X"0123456789ABCDEF0123456789ABCDEF";
  t_r128 <= X"00000000000000000000000077361F23"; --X"0000000000000000000000000000007B";  --X"123456789ABCDEF0123456789ABCDEF0";
  t_m256 <= X"000000000000000000000000000000000000000000000000000000000000007B";
  t_r256 <= X"000000000000000000000000000000000000000000000000000000000000007B";
  t_m64  <= X"0123456789ABCDEF";
  t_r64  <= X"123456789ABCDEF0";
  WAIT FOR 50 ns;
  t_start <= '1';
  WAIT FOR 10 ns;
  t_start <= '0';
  WAIT FOR 2200 ns;
  t_start <= '1';
  t_m128 <= X"23456789ABCDEF0123456789ABCDEF01";
  t_r128 <= X"3456789ABCDEF0123456789ABCDEF012";
  t_m256 <= X"000000000000000000000000000000000000000000000000000000007FF866B3";
  t_r256 <= X"0000000000000000000000000000000000000000000000000000000077361F23";
  t_m64  <= X"000000007FF866B3"; --X"23456789ABCDEF01";
  t_r64  <= X"0000000077361F23"; --X"3456789ABCDEF012";
  WAIT FOR 10 ns;
  t_start <= '0';
  WAIT FOR 2200 ns;
  t_start <= '1';
  t_m128 <= X"23456789ABCDEF0123456789ABCDEF01";
  t_r128 <= X"3456789ABCDEF0123456789ABCDEF012";
  t_m256 <= X"0000000000000000000000000000000000000000000000000000000000000003";
  t_r256 <= X"0000000000000000000000000000000000000000000000000000000000000005";
  t_m64  <= X"000000007FF866B3"; --X"23456789ABCDEF01";
  t_r64  <= X"0000000077361F23"; --X"3456789ABCDEF012";
  WAIT;
  END PROCESS;

  --MULT128 : Karatsuba128 PORT MAP(t_m128, t_r128, t_clk, t_rst, t_start, t_result256, t_done);
  MULT256   : Karatsuba256 PORT MAP(t_m256, t_r256, t_clk, t_rst, t_start, t_result512, t_done);
  --MULT64  : Karatsuba64  PORT MAP(t_m64, t_r64, t_clk, t_rst, t_start, t_result128, t_done);
 
END test1;
	
	


	
	
