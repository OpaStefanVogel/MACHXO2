library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine10 is
--generic (
--   ADRESSE : integer
--);
  Port (
    TAKTZAEHLER: out STD_LOGIC_VECTOR (47 downto 0);
    CLK50_O: out STD_LOGIC;
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

end Platine10;

architecture Brezel of Platine10 is

--
COMPONENT OSCH
  GENERIC (NOM_FREQ: string:="53.2");--Seite 31 in C01
  PORT (
    STDBY: IN  STD_LOGIC;
    OSC:   OUT STD_LOGIC;
    SEDSTDBY: OUT STD_LOGIC);
  END COMPONENT;

signal TAKTZAEHLERI: STD_LOGIC_VECTOR (47 downto 0);
signal CLK_50MHZ,CLK_12,CLK_JJ,CLK_25,ZFLAG: STD_LOGIC;

begin

--ZFLAG<='1';
--ZFLAG<=DAT_I(0) when WE_I='1' and ADR_I=x"2C2C";
--process begin wait until (CLK_50MHZ'event and CLK_50MHZ='0');
--  if WE_I='1' and ADR_I=x"2C2C" then ZFLAG<=DAT_I(0); end if;
 -- end process;
process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C2C" then ZFLAG<=DAT_I(0); end if;
  end process;

OSCInst0: OSCH
  GENERIC MAP (NOM_FREQ => "53.2")
  PORT MAP (STDBY=>'0', OSC=>CLK_50MHZ, SEDSTDBY=>OPEN);

process --50-->12,5 MHz:
begin wait until (CLK_50MHZ'event and CLK_50MHZ='1');
  TAKTZAEHLERI<=TAKTZAEHLERI+1; -- 50 Bit
  CLK_25<=TAKTZAEHLERI(1);
  CLK_12<=TAKTZAEHLERI(3);--normal 1, zum Testen auch 24, 20, 10
  CLK6_O<=TAKTZAEHLERI(2);--momentan immer 2 für seriell RX TX
  if ZFLAG='0' then CLK_O<=CLK_12; else CLK_O<=CLK_25; end if;
  end process;

TAKTZAEHLER<=TAKTZAEHLERI;

CLK50_O<=CLK_50MHZ;
--CLK_25<=TAKTZAEHLERI(1);
--CLK_12<=TAKTZAEHLERI(3);--normal 1, zum Testen auch 24, 20, 10
--CLK6_O<=TAKTZAEHLERI(2);--momentan immer 2 für seriell RX TX
--CLK_O<=CLK_12 when ZFLAG='0' else CLK_25; --25/12,5 MHz

with ADR_I select 
  DAT_O<=TAKTZAEHLERI(39 downto 24) when x"D004",--UHR
         TAKTZAEHLERI(15 downto 00) when x"D00D",
         TAKTZAEHLERI(31 downto 16) when x"D00E",
         TAKTZAEHLERI(47 downto 32) when x"D00F",
         DAT_I when others;

ADR_O<=ADR_I;
WE_O<=WE_I;
end Brezel;
