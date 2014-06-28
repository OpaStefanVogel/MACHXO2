library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine18 is
  Port (
    SPI_CLK: in STD_LOGIC;
    SPI_MOSI: in STD_LOGIC;
    SPI_MISO: inout STD_LOGIC;--inout
    SPI_SCSN: in STD_LOGIC;
    INT_XY: inout STD_LOGIC;
 --
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

end Platine18;

architecture Kufel of Platine18 is

signal SPI_COUNTER,EMITBYTE: STD_LOGIC_VECTOR (15 downto 0);
signal SPI_BYTE_KOMPLETT,SPI_MISO_SENDEBYTE: STD_LOGIC_VECTOR (7 downto 0);
signal SPI_MISO_SENDEBIT,CSSMERK1,CSSMERK2: STD_LOGIC;
begin


process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2D05" then EMITBYTE<=DAT_I; end if;
  end process;

process begin wait until (SPI_SCSN'event and SPI_SCSN='0');
  CSSMERK1<=not CSSMERK2;
  end process;

process 
variable SPI_COUNT: STD_LOGIC_VECTOR (15 downto 0):=x"0000"; 
variable SPI_BYTE: STD_LOGIC_VECTOR (7 downto 0):=x"00";
begin wait until (SPI_CLK'event and SPI_CLK='1');
  if not(CSSMERK1=CSSMERK2) then SPI_COUNT:=x"0000"; end if;
  CSSMERK2<=CSSMERK1;
  SPI_COUNT:=SPI_COUNT+1;
  SPI_COUNTER<=SPI_COUNT;
  SPI_BYTE:=SPI_BYTE(6 downto 0)&SPI_MOSI;
  SPI_MISO<=SPI_MISO_SENDEBYTE(7);
  SPI_MISO_SENDEBYTE<=SPI_MISO_SENDEBYTE(6 downto 0)&'0';
  if SPI_COUNT(2 downto 0)="000" then
    SPI_BYTE_KOMPLETT<=SPI_BYTE;
    if not(SPI_MISO_SENDEBIT=EMITBYTE(8)) then
      SPI_MISO_SENDEBYTE<=EMITBYTE(7 downto 0);
      SPI_MISO_SENDEBIT<=not SPI_MISO_SENDEBIT;
      end if;
    if SPI_BYTE>x"00" then INT_XY<=not INT_XY; end if;
    end if;
  end process;

with ADR_I select
  DAT_O<=SPI_MISO&SPI_CLK&SPI_MOSI&SPI_SCSN&"000"&SPI_MISO_SENDEBIT&SPI_BYTE_KOMPLETT when x"D031",
         SPI_COUNTER                               when x"D032",
         DAT_I when others;

CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Kufel;
