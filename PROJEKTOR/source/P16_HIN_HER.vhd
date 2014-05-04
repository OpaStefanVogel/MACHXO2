library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine16 is
  Port (
    OUTPUT: inout STD_LOGIC_VECTOR (23 downto 0);
    INPUT: in STD_LOGIC_VECTOR (31 downto 0);

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

end Platine16;

architecture Wurzel of Platine16 is
signal INPUT_R: STD_LOGIC_VECTOR (31 downto 0);

begin

process begin wait until (CLK_I'event and CLK_I='0');
  --if WE_I='1' and ADR_I=x"2D14" then OUTPUT(15 downto 0)<=DAT_I; end if;
  --if WE_I='1' and ADR_I=x"2D15" then OUTPUT(23 downto 16)<=DAT_I(7 downto 0); end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C40" then 
    if DAT_I(2)='0' then OUTPUT(0)<=DAT_I(0);
      else OUTPUT(0)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C41" then 
    if DAT_I(2)='0' then OUTPUT(1)<=DAT_I(0);
      else OUTPUT(1)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C42" then 
    if DAT_I(2)='0' then OUTPUT(2)<=DAT_I(0);
      else OUTPUT(2)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C43" then 
    if DAT_I(2)='0' then OUTPUT(3)<=DAT_I(0);
      else OUTPUT(3)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C44" then 
    if DAT_I(2)='0' then OUTPUT(4)<=DAT_I(0);
      else OUTPUT(4)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C45" then 
    if DAT_I(2)='0' then OUTPUT(5)<=DAT_I(0);
      else OUTPUT(5)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C46" then 
    if DAT_I(2)='0' then OUTPUT(6)<=DAT_I(0);
      else OUTPUT(6)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C47" then 
    if DAT_I(2)='0' then OUTPUT(7)<=DAT_I(0);
      else OUTPUT(7)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C48" then 
    if DAT_I(2)='0' then OUTPUT(8)<=DAT_I(0);
      else OUTPUT(8)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C49" then 
    if DAT_I(2)='0' then OUTPUT(9)<=DAT_I(0);
      else OUTPUT(9)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4A" then 
    if DAT_I(2)='0' then OUTPUT(10)<=DAT_I(0);
      else OUTPUT(10)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4B" then 
    if DAT_I(2)='0' then OUTPUT(11)<=DAT_I(0);
      else OUTPUT(11)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4C" then 
    if DAT_I(2)='0' then OUTPUT(12)<=DAT_I(0);
      else OUTPUT(12)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4D" then 
    if DAT_I(2)='0' then OUTPUT(13)<=DAT_I(0);
      else OUTPUT(13)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4E" then 
    if DAT_I(2)='0' then OUTPUT(14)<=DAT_I(0);
      else OUTPUT(14)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C4F" then 
    if DAT_I(2)='0' then OUTPUT(15)<=DAT_I(0);
      else OUTPUT(15)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C50" then 
    if DAT_I(2)='0' then OUTPUT(16)<=DAT_I(0);
      else OUTPUT(16)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C51" then 
    if DAT_I(2)='0' then OUTPUT(17)<=DAT_I(0);
      else OUTPUT(17)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C52" then 
    if DAT_I(2)='0' then OUTPUT(18)<=DAT_I(0);
      else OUTPUT(18)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C53" then 
    if DAT_I(2)='0' then OUTPUT(19)<=DAT_I(0);
      else OUTPUT(19)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C54" then 
    if DAT_I(2)='0' then OUTPUT(20)<=DAT_I(0);
      else OUTPUT(20)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C55" then 
    if DAT_I(2)='0' then OUTPUT(21)<=DAT_I(0);
      else OUTPUT(21)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C56" then 
    if DAT_I(2)='0' then OUTPUT(22)<=DAT_I(0);
      else OUTPUT(22)<='Z'; end if; end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2C57" then 
    if DAT_I(2)='0' then OUTPUT(23)<=DAT_I(0);
      else OUTPUT(23)<='Z'; end if; end if;
  end process;



process--asynchrone Rueckgabewerte
begin wait until (CLK_I'event and CLK_I='0');
  INPUT_R<=INPUT; -- 32 Bit
  end process;


with ADR_I select 
  DAT_O<=OUTPUT(15 downto 0) when x"D010",
         x"00"&OUTPUT(23 downto 16) when x"D011",
         INPUT(15 downto 0) when x"D012",--hier ueberall INPUT_P startet einfach nicht
         INPUT(31 downto 16) when x"D013",
         "000000000000000"&INPUT(0) when x"D140",
         "000000000000000"&INPUT(1) when x"D141",
         "000000000000000"&INPUT(2) when x"D142",
         "000000000000000"&INPUT(3) when x"D143",
         "000000000000000"&INPUT(4) when x"D144",
         "000000000000000"&INPUT(5) when x"D145",
         "000000000000000"&INPUT(6) when x"D146",
         "000000000000000"&INPUT(7) when x"D147",
         "000000000000000"&INPUT(8) when x"D148",
         "000000000000000"&INPUT(9) when x"D149",
         "000000000000000"&INPUT(10) when x"D14A",
         "000000000000000"&INPUT(11) when x"D14B",
         "000000000000000"&INPUT(12) when x"D14C",
         "000000000000000"&INPUT(13) when x"D14D",
         "000000000000000"&INPUT(14) when x"D14E",
         "000000000000000"&INPUT(15) when x"D14F",
         "000000000000000"&INPUT(16) when x"D150",
         "000000000000000"&INPUT(17) when x"D151",
         "000000000000000"&INPUT(18) when x"D152",
         "000000000000000"&INPUT(19) when x"D153",
         "000000000000000"&INPUT(20) when x"D154",
         "000000000000000"&INPUT(21) when x"D155",
         "000000000000000"&INPUT(22) when x"D156",
         "000000000000000"&INPUT(23) when x"D157",
         "000000000000000"&INPUT(24) when x"D158",
         "000000000000000"&INPUT(25) when x"D159",
         "000000000000000"&INPUT(26) when x"D15A",
         "000000000000000"&INPUT(27) when x"D15B",
         "000000000000000"&INPUT(28) when x"D15C",
         "000000000000000"&INPUT(29) when x"D15D",
         "000000000000000"&INPUT(30) when x"D15E",
         "000000000000000"&INPUT(31) when x"D15F",
         DAT_I when others;

CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Wurzel;
