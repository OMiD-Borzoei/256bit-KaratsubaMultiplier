LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY ArrayMultiplier IS
	GENERIC(
		x : INTEGER := 32
		);
	PORT( a, b : IN STD_LOGIC_VECTOR(x-1 DOWNTO 0);
		mult : OUT STD_LOGIC_VECTOR(2*x-1 DOWNTO 0));
END ArrayMultiplier;

ARCHITECTURE a1 OF ArrayMultiplier IS
TYPE twoD IS ARRAY (INTEGER RANGE<>) OF STD_LOGIC_VECTOR(x-1 DOWNTO 0);
TYPE twoD2 IS ARRAY (INTEGER RANGE<>) OF STD_LOGIC_VECTOR(x DOWNTO 0);


SIGNAL vs : twoD2(0 TO x+1) := (OTHERS => (OTHERS => '0'));
SIGNAL ab : twoD(0 TO x-1);
SIGNAL vc : twoD(0 TO x+1) := (OTHERS => (OTHERS => '0'));
SIGNAL fh : STD_LOGIC_VECTOR(x-1 DOWNTO 0);

BEGIN
	q0: FOR i IN 0 TO x GENERATE
		i1: IF(i < x) GENERATE
			q1: FOR j IN 0 TO x-1 GENERATE
				ab(i)(j) <= a(i) AND b(j); 
				vs(i+1)(j) <= ab(i)(j) XOR vs(i)(j+1) XOR vc(i)(j);
				vc(i+1)(j) <= (ab(i)(j) AND vs(i)(j+1)) OR (ab(i)(j) AND vc(i)(j)) OR (vc(i)(j) AND vs(i)(j+1));
			END GENERATE q1;
		END GENERATE i1;
		i2: IF(i = x) GENERATE
			q2: FOR j IN 0 TO x-1 GENERATE
				i3: IF(j = 0) GENERATE
					vs(i+1)(j) <= '0' XOR vs(i)(j+1) XOR vc(i)(j);
					vc(i+1)(j) <= ('0' AND vs(i)(j+1)) OR ('0' AND vc(i)(j)) OR (vc(i)(j) AND vs(i)(j+1));
				END GENERATE i3;
				i4: IF(j > 0) GENERATE
					vs(i+1)(j) <= vs(i)(j+1) XOR vc(i)(j) XOR vc(i+1)(j-1);
					vc(i+1)(j) <= (vs(i)(j+1) AND vc(i)(j)) OR (vs(i)(j+1) AND vc(i+1)(j-1)) OR (vc(i+1)(j-1) AND vc(i)(j));
				END GENERATE i4;
			END GENERATE q2;
		END GENERATE i2;
	END GENERATE q0;

	PROCESS(vs) BEGIN
		FOR i IN 1 TO x LOOP
			fh(i-1) <= vs(i)(0);
		END LOOP;
	END PROCESS;

	mult <= vs(x+1)(x-1 DOWNTO 0) & fh;
END a1;