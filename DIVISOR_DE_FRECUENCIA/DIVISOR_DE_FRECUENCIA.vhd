--Jesús Emiliano García Jiménez
--A01751766
--Divisor de frecuencia para señal de reloj

library IEEE;
use ieee.std_logic_1164.all;

entity DIVISOR_DE_FRECUENCIA is
    port ( CLK, RST : in std_logic;
			         F : out std_logic);
	 end DIVISOR_DE_FRECUENCIA;

architecture RTL of DIVISOR_DE_FRECUENCIA is

	signal Q : std_logic;
	
begin

	 P1: process(CLK, RST)
    begin
        if (RST = '0') then
            Q <= '0';	 
        elsif (CLK'event and CLK = '1') then
            Q <= not Q;
        end if;
    end process P1;
	 
	 F <= Q;

end RTL;