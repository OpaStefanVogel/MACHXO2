library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine15 is
  Port ( 
    SPI_MISO: in STD_LOGIC;
    SPI_MOSI: out STD_LOGIC;
    SPI_SCK: out STD_LOGIC; -- Clock

    CLK50_I: in STD_LOGIC;
    CLK50_O: out STD_LOGIC;
    CLK6_I: in STD_LOGIC;
    CLK6_O: out STD_LOGIC;

    CLK_I: in STD_LOGIC;
    ADR_I: in STD_LOGIC_VECTOR (15 downto 0);
    DAT_I: in STD_LOGIC_VECTOR (15 downto 0);
    WE_I: in STD_LOGIC;

    CLK_O: out STD_LOGIC;
    ADR_O: out STD_LOGIC_VECTOR (15 downto 0);
    DAT_O: out STD_LOGIC_VECTOR (15 downto 0);
    WE_O: out STD_LOGIC
    );
end Platine15;

architecture Schturzel of Platine15 is
----SPI
signal SPANNU: STD_LOGIC_VECTOR (15 downto 0);
signal SPI_SCKI,SPI_SCKG: STD_LOGIC;

--fuer's schnelle SPI
signal SPI_MOSI1,SPI_MOSI2,RST,VARIANTE: STD_LOGIC;
signal SPI_FLAG: STD_LOGIC;
signal SPI_INPUT: STD_LOGIC_VECTOR (63 downto 0);
signal SPI_OUTPUT: STD_LOGIC_VECTOR (63 downto 0);

begin

process
begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' then 
    case ADR_I is
	   --when x"2C2B" => SPI_MOSI1<=DAT_I(0);
	   --when x"2C09" => SPI_SCKI<=DAT_I(0);
	   --when x"2C10" => VARIANTE<=DAT_I(0);
	   
	   when x"2C11" => RST<=DAT_I(0);
	   when x"2D10" => SPI_INPUT(15 downto 0)<=DAT_I;
	   when x"2D11" => SPI_INPUT(31 downto 16)<=DAT_I;
	   when x"2D12" => SPI_INPUT(47 downto 32)<=DAT_I;
	   when others => null;
      end case;
    end if;		
  end process;

SPI_SCK<=SPI_SCKG;
--SPI_SCKG<=SPI_SCKI when VARIANTE='0' else CLK_I and SPI_FLAG;
--SPI_MOSI<=SPI_MOSI1 when VARIANTE='0' else SPI_MOSI2;
SPI_SCKG<=CLK50_I and SPI_FLAG;
SPI_MOSI<=SPI_MOSI2;

process
variable COUNTS: integer;
begin wait until (CLK50_I'event and CLK50_I='0');
  if RST='0' then COUNTS:=48; SPI_FLAG<='0'; else
    if (COUNTS>0 and SPI_INPUT(16)='0') or (COUNTS>8 and SPI_INPUT(16)='1') then
	  COUNTS:=COUNTS-1;
	  SPI_FLAG<='1'; 
      SPI_MOSI2<=SPI_INPUT(COUNTS);
	else SPI_FLAG<='0'; end if; end if;
  end process;

process
variable spannungen: STD_LOGIC_VECTOR (15 downto 0):=x"0001";
begin wait until (SPI_SCKG'event and SPI_SCKG='0');
  spannungen:=spannungen+spannungen;
  spannungen(0):=SPI_MISO;
  SPANNU<=spannungen;--x"D014"
  end process;

with ADR_I select 
  DAT_O<=--x"000"&"000"&SPI_MISO when x"D108",
         SPANNU when x"D028",
         DAT_I when others;


CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Schturzel;

