----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23.8.2013 
-- Design Name: 
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine11 is
  Port (
    LED: out STD_LOGIC_VECTOR (7 downto 0);
    TAKTZAEHLER: in STD_LOGIC_VECTOR (47 downto 0);

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

end Platine11;

architecture Lichtel of Platine11 is
signal C,REVCOUNTER,REVCOUNTERI: STD_LOGIC_VECTOR (11 downto 0);
signal LEDX: STD_LOGIC_VECTOR (7 downto 0);
type REG is array(0 to 7) of STD_LOGIC_VECTOR (11 downto 0);
signal WLED: REG;


begin

--process begin wait until (CLK_I'event and CLK_I='0');
  --if WE_I='1' then if ADR_I=x"2D20" then WLED(0)<=DAT_I(15 downto 4);
    --elsif WE_I='1' and ADR_I=x"2D21" then WLED(1)<=DAT_I(15 downto 4);
    --elsif WE_I='1' and ADR_I=x"2D22" then WLED(2)<=DAT_I(15 downto 4);
    --elsif WE_I='1' and ADR_I=x"2D23" then WLED(3)<=DAT_I(15 downto 4); 
    --elsif WE_I='1' and ADR_I=x"2D24" then WLED(4)<=DAT_I(15 downto 4); 
    --elsif WE_I='1' and ADR_I=x"2D25" then WLED(5)<=DAT_I(15 downto 4);
    --elsif WE_I='1' and ADR_I=x"2D26" then WLED(6)<=DAT_I(15 downto 4);
    --elsif WE_I='1' and ADR_I=x"2D27" then WLED(7)<=DAT_I(15 downto 4); 
    --elsif WE_I='1' and ADR_I=x"2D04" then LEDX<=DAT_I(7 downto 0); 
    --end if; end if;
  --REVCOUNTER<=REVCOUNTERI;
  --end process;

--C<=TAKTZAEHLER(13 downto 2);
--REVCOUNTERI<=C(0)&C(1)&C(2)&C(3)&C(4)&C(5)&C(6)&C(7)&C(8)&C(9)&C(10)&C(11);
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(0)&WLED(0)<REVCOUNTER&'1' then LED(0)<='0'; else LED(0)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(1)&WLED(1)<REVCOUNTER&'1' then LED(1)<='0'; else LED(1)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(2)&WLED(2)<REVCOUNTER&'1' then LED(2)<='0'; else LED(2)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(3)&WLED(3)<REVCOUNTER&'1' then LED(3)<='0'; else LED(3)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(4)&WLED(4)<REVCOUNTER&'1' then LED(4)<='0'; else LED(4)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(5)&WLED(5)<REVCOUNTER&'1' then LED(5)<='0'; else LED(5)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(6)&WLED(6)<REVCOUNTER&'1' then LED(6)<='0'; else LED(6)<='1'; end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='1');
  --if LEDX(7)&WLED(7)<REVCOUNTER&'1' then LED(7)<='0'; else LED(7)<='1'; end if;
  --end process;



--das war der alte Inhalt von ABWAERTS_98/P11.vhd:
--ergaenzt um 2Cxx
process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' then
    if ADR_I=x"2D04" then LEDX<=DAT_I(7 downto 0); 
    --elsif ADR_I=x"2C20" then LED(0)<=DAT_I(0); 
    --elsif ADR_I=x"2C21" then LED(1)<=DAT_I(0); 
    --elsif ADR_I=x"2C22" then LED(2)<=DAT_I(0); 
    --elsif ADR_I=x"2C23" then LED(3)<=DAT_I(0); 
    --elsif ADR_I=x"2C24" then LED(4)<=DAT_I(0); 
    --elsif ADR_I=x"2C25" then LED(5)<=DAT_I(0); 
    --elsif ADR_I=x"2C26" then LED(6)<=DAT_I(0); 
    --elsif ADR_I=x"2C27" then LED(7)<=DAT_I(0); 
    end if; end if;
  end process;
LED<=LEDX;

with ADR_I select 
  DAT_O<="00000000"&LEDX when x"D00C",
         --x"0"&REVCOUNTER when x"D020",
         --x"0"&WLED(1) when x"D021",
         DAT_I when others;

CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Lichtel;
