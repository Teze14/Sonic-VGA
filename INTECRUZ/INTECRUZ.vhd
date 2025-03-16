--Jesús Emiliano García Jiménez
--A01751766
--Dispositivo para crear una cruz en una pantalla VGA 640x480

library IEEE;
use ieee.std_logic_1164.all;

entity INTECRUZ is
    port ( CLK, RST, START, JUMP, SWF, SWB, PER: in std_logic;
			  VSYNC, HSYNC : out std_logic;
			  R, G, B : out std_logic_vector(3 downto 0));
	 end INTECRUZ;

architecture RTL of INTECRUZ is

	component DIVISOR_DE_FRECUENCIA is
		 port ( CLK, RST : in std_logic;
							F : out std_logic);
	end component;
	 
	component CNT_MOD800 is
		 port ( CLK, RST: in std_logic;
				  CUENTA : out std_logic_vector(9 downto 0);
				  Cout : out std_logic);
	end component;
	
	component CNT_MOD525 is
		 port ( CLK, RST: in std_logic;
				  CUENTA : out std_logic_vector(9 downto 0);
				  Cout : out std_logic);
	end component;
	
	component MaquinaEstadosVGA is
		 port ( CLK, RST, START: in std_logic;
				  CNT : in std_logic_vector(9 downto 0);
				  VSYNC : out std_logic;
				  VSYNCST : out std_logic_vector(1 downto 0));
	end component;
	
	component MaquinaEstadosVGAH is
		 port ( CLK, RST, START: in std_logic;
				  CNT800, CNT525 : in std_logic_vector(9 downto 0);
				  VSYNCST : in std_logic_vector(1 downto 0);
				  InB, InR : in std_logic_vector(3 downto 0);
				  HSYNC : out std_logic;
				  R, G, B : out std_logic_vector(3 downto 0));
	end component;
		
	component MaquinaEstadosHP is 
	port( CLOCK,RESET,START,JUMP,SWF,SWB,VSINC,PER: in std_logic;
			XCOUNT,YCOUNT: in std_logic_vector(9 downto 0);	
			YSTATE: in std_logic_vector(1 downto 0);
			R,G,B: out std_logic_vector(3 downto 0);
			HSINC: out std_logic);
   end component;

	
	signal F, Ov, Ov525: std_logic;
	signal CUENTA800, CUENTA525 : std_logic_vector(9 downto 0);
	signal VSYNCST : std_logic_vector(1 downto 0);
	signal YSYNC: std_logic;
	--signal Rs, Gs, Bs : std_logic_vector(3 downto 0);

	begin

		I0 : DIVISOR_DE_FRECUENCIA port map (CLK, RST, F);
		I1 : CNT_MOD800 port map (F, RST, CUENTA800, Ov);
		I2 : CNT_MOD525 port map (Ov, RST, CUENTA525, Ov525);
		I3 : MaquinaEstadosVGA port map (F, RST, START, CUENTA525, YSYNC, VSYNCST);
		I4 : MaquinaEstadosHP port map (F, RST, START, JUMP, SWF, SWB, YSYNC, PER, CUENTA800, CUENTA525, VSYNCST, R, G, B, HSYNC);
		VSYNC<=YSYNC;


end RTL;