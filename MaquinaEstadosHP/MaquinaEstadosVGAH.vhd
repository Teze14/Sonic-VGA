--Jesús Emiliano García Jiménez
--A01751766
--Maquina de estados VGA Horizontal

library IEEE;
use ieee.std_logic_1164.all;

entity MaquinaEstadosVGAH is
    port ( CLK, RST, START: in std_logic;
           CNT800, CNT525 : in std_logic_vector(9 downto 0);
			  VSYNCST : in std_logic_vector(1 downto 0);
			  InB, InR : in std_logic_vector(3 downto 0);
			  HSYNC : out std_logic;
			  R, G, B : out std_logic_vector(3 downto 0));
end MaquinaEstadosVGAH;

architecture RTL of MaquinaEstadosVGAH is
	 
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

		P1: process (EDO, CNT800, START) is  -- Transiciones de los estados
			 begin
				  case EDO is
						when IDLE => if START = '1' then
											EDOF <= PSY;
									  else
											EDOF <= IDLE;
									  end if;
									  
						when PSY => if CNT800 = "0001011111" then
											EDOF <= BP;
									  else
											EDOF <= PSY;
									  end if;
									  
						when BP => if CNT800 = "0010001111" then
											EDOF <= ZV;
									  else
											EDOF <= BP;
									  end if;
									  
						when ZV => if CNT800 = "1100001111" then
											EDOF <= FP;
									  else
											EDOF <= ZV;
									  end if;
									  
						when FP => if CNT800 = "1100011111" then
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
				  when PSY =>  
						HSYNC <= '0'; -- Pulso de sincronización horizontal activo bajo
						R <= "0000"; -- Negro
						G <= "0000";
						B <= "0000";

				  when BP =>  
						HSYNC <= '1'; -- Back Porch (señal inactiva)
						R <= "0000"; -- Negro
						G <= "0000";
						B <= "0000";

				  when ZV =>  
						HSYNC <= '1'; -- Activa la señal en la zona visible
						if (VSYNCST = "00" OR VSYNCST = "01" OR VSYNCST = "11") then
							 R <= "0000"; -- Negro
							 G <= "0000";
							 B <= "0000";
						elsif ((CNT800 > "0111000010" AND CNT800 < "0111001100") OR (CNT525 > "0011111110" AND CNT525 < "0100001001" )) then
						--AND CNT525 < "0010000100"
							 R <= "1111"; -- Blanco
							 G <= "1111";
							 B <= "1111";
						else
							 R <= InR; -- Color de entrada (Rojo)
							 G <= "1111"; -- Verde máximo
							 B <= InB; -- Color de entrada (Azul)
						end if;

				  when FP =>  
						HSYNC <= '1'; -- Front Porch
						R <= "0000"; -- Negro
						G <= "0000";
						B <= "0000";          

				  when others => 
						HSYNC <= '1';
						R <= "0000";
						G <= "0000";
						B <= "0000";
			 end case;
		end process P2;


end RTL;
