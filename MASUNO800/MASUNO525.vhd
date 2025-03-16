---Jesús Emiliano García Jiménez
--A01751766
--Dispositivo que suma +1 cada ciclo del reloj 10 bits

library ieee;
use ieee.std_logic_1164.all;

entity MASUNO525 is
	port( A: in std_logic_vector(9 downto 0);	--Para definir A y B como entradas "binarias"
			Z: out std_logic_vector(9 downto 0);
			Cout: out std_logic);
end entity; 

architecture RTL of MASUNO525 is 
	-- Usaremos unicamente half adders 
	component HA is
		port( A, B: in std_logic;
				S, Co: out std_logic);
	end component; 
	
	signal C: std_logic_vector(10 downto 1); --para manejar los carrys generados por HA
	signal S:  std_logic_vector(9 downto 0);
	
	begin
		HA0: HA port map (A(0),'1', S(0), C(1));
		HA1: HA port map (A(1), C(1), S(1), C(2));
		HA2: HA port map (A(2), C(2), S(2), C(3));
		HA3: HA port map (A(3), C(3), S(3), C(4));
		HA4: HA port map (A(4), C(4), S(4), C(5));		
		HA5: HA port map (A(5), C(5), S(5), C(6));
		HA6: HA port map (A(6), C(6), S(6), C(7));
		HA7: HA port map (A(7), C(7), S(7), C(8));
		HA8: HA port map (A(8), C(8), S(8), C(9));
		HA9: HA port map (A(9), C(9), S(9), C(10));	
	
		P1: process (S)
			begin
				if (S = "1000001101") then
					Cout <= '1';
				else
					Cout <= '0';
				end if;
		end process;
		Z <= S;
end architecture;
