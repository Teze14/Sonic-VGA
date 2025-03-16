--Jesús Emiliano García Jiménez
--A01751766
--Contador de 10 bits modulo 800

library IEEE;
use ieee.std_logic_1164.all;

entity CNT_MOD800 is
    port ( CLK, RST: in std_logic;
			  CUENTA : out std_logic_vector(9 downto 0);
			  Cout : out std_logic);
	 end CNT_MOD800;

architecture RTL of CNT_MOD800 is

signal D, Q : std_logic_vector(9 downto 0);
signal ovl8 : std_logic;

component MASUNO10 is
    port ( A : in std_logic_vector(9 downto 0);
           Z : out std_logic_vector(9 downto 0);
			  Cout : out std_logic);
end component MASUNO10;

begin

I0 : MASUNO10 port map (Q, D, ovl8);

P1: process(CLK, RST)
    begin
        if (RST = '0' or Q = "1100100000") then
            Q <= "0000000000";	 
        elsif (CLK'event and CLK = '1') then
					 Q <= D;
					 Cout <= ovl8;
        end if;
    end process P1;
CUENTA <= Q;
end RTL;