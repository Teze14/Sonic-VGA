--Jesús Emiliano García Jiménez
--A01751766
--Maquina de estados VGA Vertical

library IEEE;
use ieee.std_logic_1164.all;

entity MaquinaEstadosVGA is
    port ( CLK, RST, START: in std_logic;
           CNT : in std_logic_vector(9 downto 0);
			  VSYNC : out std_logic;
			  VSYNCST : out std_logic_vector(1 downto 0));
end MaquinaEstadosVGA;

architecture RTL of MaquinaEstadosVGA is
	 
	 type ESTADOS is (IDLE, PSY, BP, ZV, FP);
	 signal EDO, EDOF: ESTADOS;

	 begin
		P0: process (CLK, RST)  -- Definición de los FlipFlops tipo D
			 begin
				  if (RST = '0') then  -- RST asincrono activo en bajo
						EDO <= IDLE;
				  elsif (CLK'event and CLK = '1') then  -- CLK con flanco de subida
						EDO <= EDOF;
				  end if;
			 end process P0;

		P1: process (EDO, CNT, START) is  -- Transiciones de los estados
			 begin
				  case EDO is
						when IDLE => if START = '1' then
											EDOF <= PSY;
									  else
											EDOF <= IDLE;
									  end if;
									  
						when PSY => if CNT = "0000000001" then
											EDOF <= BP;
									  else
											EDOF <= PSY;
									  end if;
									  
						when BP => if CNT = "0000100010" then
											EDOF <= ZV;
									  else
											EDOF <= BP;
									  end if;
									  
						when ZV => if CNT = "1000000010" then
											EDOF <= FP;
									  else
											EDOF <= ZV;
									  end if;
									  
						when FP => if CNT = "1000001100" then
											EDOF <= IDLE;
									  else
											EDOF <= FP;
									  end if;
						when others => null;
				  end case;
			 end process P1;

		P2: process (EDO) is
			 begin
				 case EDO is
					  when PSY =>  VSYNC <= '0';
										VSYNCST <= "00";
										
					  when BP =>  VSYNC <= '1';
									  VSYNCST <= "01";
										
					  when ZV =>  VSYNC <= '1';
									  VSYNCST <= "10";
										
					  when FP =>  VSYNC <= '1';
									  VSYNCST <= "11";				
										
					  when others => null;
				 end case;
			end process P2;

end RTL;
