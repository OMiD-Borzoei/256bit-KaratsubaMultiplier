LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_signed.ALL;

ENTITY Karatsuba32 IS

	GENERIC (
		wid : INTEGER := 32
	);
	
	PORT(
	     m : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	     r : IN STD_LOGIC_VECTOR(wid - 1 DOWNTO 0);
	     clk : IN STD_LOGIC;
	     rst : IN STD_LOGIC;
	     start : IN STD_LOGIC;
	     result : OUT STD_LOGIC_VECTOR(2 * wid - 1 DOWNTO 0);
	     done   : OUT STD_LOGIC
	);
		  
END Karatsuba32;


ARCHITECTURE k1 OF Karatsuba32 IS 

SIGNAL p1, p2, p3, c, next_p1, next_p2, next_p3    : STD_LOGIC_VECTOR(wid-1 DOWNTO 0);
SIGNAL pp1  : STD_LOGIC_VECTOR(2*wid-1 DOWNTO 0) :=(others => '0');
SIGNAL pp2  : STD_LOGIC_VECTOR(2*wid-1 DOWNTO 0) :=(others => '0');
SIGNAL pp3  : STD_LOGIC_VECTOR(2*wid-1 DOWNTO 0) :=(others => '0');
SIGNAL mL, mR, rL, rR, sM, sR, a, b : STD_LOGIC_VECTOR((wid/2) - 1 DOWNTO 0);
CONSTANT hW : INTEGER := wid/2;
TYPE t_state IS(idle, F, S, T, calc, finish);
SIGNAL state, next_state : t_state;
SIGNAL en1, en2, en3 : STD_LOGIC;

BEGIN
	
	mL <= m(wid   - 1 DOWNTO wid/2);
	mR <= m(wid/2 - 1 DOWNTO 0);
	rL <= r(wid   - 1 DOWNTO wid/2);
	rR <= r(wid/2 - 1 DOWNTO 0);

	sM <= std_logic_vector(unsigned(m(wid - 1 DOWNTO wid/2)) + unsigned(m(wid/2 - 1 DOWNTO 0)));
	sR <= std_logic_vector(unsigned(r(wid - 1 DOWNTO wid/2)) + unsigned(r(wid/2 - 1 DOWNTO 0)));

	pp1(2*wid-1 DOWNTO wid)     <= p1;
	pp2(wid - 1 DOWNTO 0) 	    <= p2;
	pp3(wid + hw - 1 DOWNTO hW) <= std_logic_vector(unsigned(p3) - unsigned(p2) - unsigned(p1));
	result <= std_logic_vector(unsigned(pp1) + unsigned(pp2) + unsigned(pp3)); 
	
	PROCESS(clk, rst) 
	BEGIN
		IF(rst = '1') THEN 
			state <= idle;
			p1 <= (OTHERS => '0');
			p2 <= (OTHERS => '0');
			P3 <= (OTHERS => '0');
		
		ELSIF(clk'EVENT AND clk = '1') THEN
			state <= next_state;	
			IF(en1 = '1') THEN p1 <= next_p1; END IF;
			IF(en2 = '1') THEN p2 <= next_p2; END IF;
			IF(en3 = '1') THEN p3 <= next_p3; END IF;
		END IF;
	END PROCESS;


	PROCESS(state, start, mL, mR, rL, rR, sM, sR, c)
	CONSTANT ZEROS : STD_LOGIC_VECTOR(2*wid - 1 DOWNTO 0) := (OTHERS => '0');
	BEGIN
		CASE state IS
			WHEN idle   => 
				IF(start = '1') THEN next_state <= F;	
				ELSE			     next_state <= idle;
				END IF;			
				done 	<= '0';
				a 		<= (OTHERS => '0');
				b 		<= (OTHERS => '0');
				next_p1 <= (OTHERS => '0');
				next_p2 <= (OTHERS => '0');
				next_p3 <= (OTHERS => '0');
				en1 	<= '0';
				en2 	<= '0';
				en3 	<= '0';
	
			WHEN F  =>  
				next_state <= S; 
				a 		   <= mL; 
				b 		   <= rL; 	
				done 	   <= '0';
				next_p1    <= c;
				next_p2    <= (OTHERS => '0');
				next_p3    <= (OTHERS => '0');
				en1 	   <= '1';
				en2 	   <= '0';
				en3 	   <= '0';
				
			WHEN S  =>  
				next_state <= T; 
				a 		   <= mR; 
				b 		   <= rR;	
				done 	   <= '0';
				next_p1    <= (OTHERS => '0');
				next_p2    <= c;
				next_p3    <= (OTHERS => '0');
				en1 	   <= '0';
				en2 	   <= '1';
				en3 	   <= '0';
				
			WHEN T  =>  
				next_state <= calc; 
				a 		   <= sM; 
				b 		   <= sR;	
				done 	   <= '0';
				next_p1    <= (OTHERS => '0');
				next_p2    <= (OTHERS => '0');
				next_p3    <= c;
				en1 	   <= '0';
				en2 	   <= '0';
				en3 	   <= '1';
				
			WHEN calc  =>  
				next_state <= finish; 
				a 		   <= (OTHERS => '0');
				b 		   <= (OTHERS => '0');	
				done 	   <= '0';
				next_p1    <= (OTHERS => '0');
				next_p2    <= (OTHERS => '0');
				next_p3    <= (OTHERS => '0');
				en1 	   <= '0';
				en2 	   <= '0';
				en3 	   <= '0';
				
			WHEN OTHERS => 
				next_state <= idle;
				a 	       <= (OTHERS => '0');
				b 	       <= (OTHERS => '0');
				done 	   <= '1';
				next_p1    <= (OTHERS => '0');
				next_p2    <= (OTHERS => '0');
				next_p3    <= (OTHERS => '0');
				en1 	   <= '0';
				en2 	   <= '0';
				en3 	   <= '0';
						
		END CASE;	
	END PROCESS;

	A1 : ENTITY work.ArrayMultiplier(a1) GENERIC MAP(16) PORT MAP(a, b, c);
END k1;