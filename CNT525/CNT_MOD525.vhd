--Jesús Emiliano García Jiménez
--A01751766
--Contador de 10 bits modulo 525

library IEEE;
use ieee.std_logic_1164.all;

entity CNT_MOD525 is
    port ( CLK, RST: in std_logic;
			  CUENTA : out std_logic_vector(9 downto 0);
			  Cout : out std_logic);
	 end CNT_MOD525;

architecture RTL of CNT_MOD525 is

signal D, Q : std_logic_vector(9 downto 0);
signal ovl : std_logic;

component MASUNO525 is
    port ( A : in std_logic_vector(9 downto 0);
           Z : out std_logic_vector(9 downto 0);
			  Cout : out std_logic);
end component MASUNO525;

begin

I0 : MASUNO525 port map (Q, D, ovl);

P1: process(CLK, RST)
    begin
        if (RST = '0' or Q = "1000001101") then
            Q <= "0000000000";	 
        elsif (CLK'event and CLK = '1') then
					 Q <= D;
					 Cout <= ovl;
				end if;
    end process P1;
CUENTA <= Q;

end RTL;