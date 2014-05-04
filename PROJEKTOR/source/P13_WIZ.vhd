library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine13 is
  Port (
    WIZ_nSS: out STD_LOGIC:='1';
    WIZ_nINT: in STD_LOGIC;
    WIZ_PWDN: out STD_LOGIC:='1';
    WIZ_nRESET: out STD_LOGIC:='1';

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

end Platine13;

architecture Witzel of Platine13 is

begin

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C08" then WIZ_nSS<=not DAT_I(0); end if;
  if WE_I='1' and ADR_I=x"2C0A" then WIZ_PWDN<=DAT_I(0); end if;
  if WE_I='1' and ADR_I=x"2C0B" then WIZ_nRESET<=not DAT_I(0); end if;
  end process;

with ADR_I select 
  DAT_O<=x"000"&"000"&WIZ_nINT when x"D109",
         DAT_I when others;

CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Witzel;
