library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine31 is
  Port (
    IO: inout STD_LOGIC_VECTOR (34 downto 1);
    IO_EXTRA: in STD_LOGIC_VECTOR (40 downto 35);
    INTXY: out STD_LOGIC;
      
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
end Platine31;

architecture Purzel of Platine31 is
signal TAKTZAEHLER: STD_LOGIC_VECTOR (50 downto 0):=(others => '0');
signal TXD,RXD: STD_LOGIC;
signal POS_A,POS_B,YPOS_A,YPOS_B: STD_LOGIC;
signal POSDET1,HALTESTELLE,COUNTER,COUNTER2: STD_LOGIC_VECTOR (31 downto 0);
signal ACOUNTER: STD_LOGIC_VECTOR (15 downto 0);
signal DANF,DSCHRITT,VMAX,VMAX2: STD_LOGIC_VECTOR (15 downto 0);
signal PIDTAKT,LANGSAMTAKT,BIT0,BIT1,DBIT,PAUSENBIT: STD_LOGIC;
signal BTN_W,BTN_E,STELL_A,STELL_B,VSTELL_A,VSTELL_B,YVSTELL_A,YVSTELL_B: STD_LOGIC;
signal FPROP,FPROPI,PW_FREQUENZ: STD_LOGIC_VECTOR (15 downto 0);
signal DIR,PWM: STD_LOGIC;
signal PROG_A,PROG_B: STD_LOGIC;
signal RAMINHALT,RAMINHALTNEU,RAMINHALTB: STD_LOGIC_VECTOR (3 downto 0);
signal RAMADRESSEA,RAMADRESSEB,RAMADRESSEAX,RAMADRESSEBX: STD_LOGIC_VECTOR (15 downto 0);
signal BTN_N,BTN_S: STD_LOGIC;
signal BTN_NORTH_ENTPRELLT,BTN_NORTH_MERK: STD_LOGIC:='0';
signal BTN_SOUTH_ENTPRELLT,BTN_SOUTH_MERK: STD_LOGIC;--:='0';
signal XYBIT,SOLLDIRA,SOLLDIRB: STD_LOGIC;
type ATAB is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal ATABELLE: 
ATAB:=(
x"FFFF",x"FFF6",x"FFD8",x"FFA7",x"FF62",x"FF09",x"FE9D",x"FE1D",
x"FD8A",x"FCE3",x"FC29",x"FB5D",x"FA7D",x"F98A",x"F884",x"F76C",
x"F641",x"F504",x"F3B5",x"F255",x"F0E2",x"EF5F",x"EDCA",x"EC24",
x"EA6D",x"E8A6",x"E6CF",x"E4E8",x"E2F2",x"E0EC",x"DED7",x"DCB4",
x"DA82",x"D842",x"D5F5",x"D39B",x"D133",x"CEBF",x"CC3F",x"C9B4",
x"C71C",x"C47A",x"C1CE",x"BF17",x"BC56",x"B98C",x"B6BA",x"B3DE",
x"B0FB",x"AE11",x"AB1F",x"A826",x"A528",x"A223",x"9F19",x"9C0B",
x"98F8",x"95E2",x"92C8",x"8FAB",x"8C8B",x"896A",x"8647",x"8324",
x"8000",x"7CDB",x"79B8",x"7695",x"7374",x"7054",x"6D37",x"6A1D",
x"6707",x"63F4",x"60E6",x"5DDC",x"5AD7",x"57D9",x"54E0",x"51EE",
x"4F04",x"4C21",x"4945",x"4673",x"43A9",x"40E8",x"3E31",x"3B85",
x"38E3",x"364B",x"33C0",x"3140",x"2ECC",x"2C64",x"2A0A",x"27BD",
x"257D",x"234B",x"2128",x"1F13",x"1D0D",x"1B17",x"1930",x"1759",
x"1592",x"13DB",x"1235",x"10A0",x"0F1D",x"0DAA",x"0C4A",x"0AFB",
x"09BE",x"0893",x"077B",x"0675",x"0582",x"04A2",x"03D6",x"031C",
x"0275",x"01E2",x"0162",x"00F6",x"009D",x"0058",x"0027",x"0009",
x"0000",x"0009",x"0027",x"0058",x"009D",x"00F6",x"0162",x"01E2",
x"0275",x"031C",x"03D6",x"04A2",x"0582",x"0675",x"077B",x"0893",
x"09BE",x"0AFB",x"0C4A",x"0DAA",x"0F1D",x"10A0",x"1235",x"13DB",
x"1592",x"1759",x"1930",x"1B17",x"1D0D",x"1F13",x"2128",x"234B",
x"257D",x"27BD",x"2A0A",x"2C64",x"2ECC",x"3140",x"33C0",x"364B",
x"38E3",x"3B85",x"3E31",x"40E8",x"43A9",x"4673",x"4945",x"4C21",
x"4F04",x"51EE",x"54E0",x"57D9",x"5AD7",x"5DDC",x"60E6",x"63F4",
x"6707",x"6A1D",x"6D37",x"7054",x"7374",x"7695",x"79B8",x"7CDB",
x"8000",x"8324",x"8647",x"896A",x"8C8B",x"8FAB",x"92C8",x"95E2",
x"98F8",x"9C0B",x"9F19",x"A223",x"A528",x"A826",x"AB1F",x"AE11",
x"B0FB",x"B3DE",x"B6BA",x"B98C",x"BC56",x"BF17",x"C1CE",x"C47A",
x"C71C",x"C9B4",x"CC3F",x"CEBF",x"D133",x"D39B",x"D5F5",x"D842",
x"DA82",x"DCB4",x"DED7",x"E0EC",x"E2F2",x"E4E8",x"E6CF",x"E8A6",
x"EA6D",x"EC24",x"EDCA",x"EF5F",x"F0E2",x"F255",x"F3B5",x"F504",
x"F641",x"F76C",x"F884",x"F98A",x"FA7D",x"FB5D",x"FC29",x"FCE3",
x"FD8A",x"FE1D",x"FE9D",x"FF09",x"FF62",x"FFA7",x"FFD8",x"FFF6");
signal I,K,PIDUHR: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal SPEEDBIT: STD_LOGIC:='0';
signal SOLLWERT,YSOLLWERT: STD_LOGIC_VECTOR (31 downto 0);
signal AMP1,AMP2,AMP3,YAMP1,YAMP2,YAMP3: STD_LOGIC_VECTOR (15 downto 0);
signal AMP1_R,AMP2_R,AMP3_R,YAMP1_R,YAMP2_R,YAMP3_R: STD_LOGIC_VECTOR (15 downto 0);
signal PWMZAEHLER,PWMZAEHLERH: STD_LOGIC_VECTOR (15 downto 0);
signal PWMZAEHLER_R,PWMZAEHLERH_R: STD_LOGIC_VECTOR (15 downto 0);
signal YPROG_A,YPROG_B: STD_LOGIC:='0';
signal YSTELL_A,YSTELL_B: STD_LOGIC:='0';
signal YSTELL_A_MERK,YSTELL_B_MERK: STD_LOGIC:='0';
signal XAMP,YAMP: STD_LOGIC_VECTOR (15 downto 0);
signal PSW: STD_LOGIC_VECTOR (3 downto 0);
signal POSDETXW,POSDETYW,YPOSDET1: STD_LOGIC_VECTOR (31 downto 0);
signal DIRXW,DIRYW,YDIR: STD_LOGIC:='0';
signal STELLWERTH,STELLWERTXW,HALTESTELLEXW: STD_LOGIC_VECTOR (15 downto 0);
signal YSTELLWERTH,STELLWERTYW,HALTESTELLEYW: STD_LOGIC_VECTOR (15 downto 0);
signal YHALTESTELLE: STD_LOGIC_VECTOR (31 downto 0);
signal DREIPHASENVERSCHIEBEBIT,LICHTBIT: STD_LOGIC:='0';
signal DREIPHASENVERSCHIEBEBITY: STD_LOGIC:='0';
signal INV_FINTI: STD_LOGIC_VECTOR (15 downto 0);
signal AXG,PXG,AYG,PYG: STD_LOGIC_VECTOR (15 downto 0);
--zum PHY:
signal ADRESSE1,ADRESSE1MERK,ADRESSE1MERKMERK,ADRESSE1MERKMERKMERK: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal ADRESSE2,TX_LOS,TX_ENDADDR: STD_LOGIC_VECTOR (15 downto 0);
signal HERBIT,E_RX_DV_R: STD_LOGIC;
--zum ParallelFlash
signal HER_VOM_FORTH_ALH: STD_LOGIC_VECTOR (25 downto 0);
signal HIN_ZUM_FORTH_DLH: STD_LOGIC_VECTOR (15 downto 0);
--INT
signal INTSX,INTSY: STD_LOGIC;
--neu WISH
signal ZUM_FORTH: STD_LOGIC_VECTOR (15 downto 0);
signal E_RX_B_DAT_O,E_TX_B_DAT_O: STD_LOGIC_VECTOR (7 downto 0);
signal CLK_12,CLK_25: STD_LOGIC;
type RTYPE is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal PD_VOM_RAM,FETCH_VOM_RAM: RTYPE;
signal WE_ZUM_RAM: STD_LOGIC_VECTOR (15 downto 0);

--neu auf DAT_I DAT_O umschreiben
signal HIN_ZUM_FORTH,HER_VOM_FORTH: STD_LOGIC_VECTOR (511 downto 0);


--NOTAUS:
signal NOTAUS: STD_LOGIC:='0';
signal IO_N: STD_LOGIC_VECTOR (34 downto 1);

--DEBUG:
signal DEBUG,DEBUG_R,DEBUGI: STD_LOGIC_VECTOR (15 downto 0);
signal P15BIT: STD_LOGIC;

begin

process
begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' then 
    case ADR_I is
	   when x"2C00" => HER_VOM_FORTH(0)<=DAT_I(0);--POS_A
	   when x"2C01" => HER_VOM_FORTH(1)<=DAT_I(0);--POS_B
	   when x"2C02" => HER_VOM_FORTH(2)<=DAT_I(0);--STELL_A
	   when x"2C03" => HER_VOM_FORTH(3)<=DAT_I(0);--STELL_B
	   when x"2C04" => HER_VOM_FORTH(4)<=DAT_I(0);--  BTN_NORTH_ENTPRELLT
	   when x"2C05" => HER_VOM_FORTH(5)<=DAT_I(0);--  BTN_SOUTH_ENTPRELLT
	   when x"2C06" => HER_VOM_FORTH(6)<=DAT_I(0);--  XYBIT
	   when x"2C07" => HER_VOM_FORTH(7)<=DAT_I(0);--  SPEEDBIT
	   when x"2C15" => HER_VOM_FORTH(21)<=DAT_I(0);--  NOTAUS
	   when x"2C1C" => HER_VOM_FORTH(28)<=DAT_I(0);--  PAUSENBIT
	   when x"2C1D" => HER_VOM_FORTH(29)<=DAT_I(0);--  DREIPHASENVERSCHIEBEBIT
	   when x"2C1E" => HER_VOM_FORTH(30)<=DAT_I(0);--  LICHTBIT
	   when x"2C21" => HER_VOM_FORTH(33)<=DAT_I(0);--  DREIPHASENVERSCHIEBEBITY
	   when x"2D05" => DEBUGI<=DAT_I;--DEBUGI
	   when x"2D17" => HER_VOM_FORTH(127 downto 112)<=DAT_I;--INV_FINTI alt: 2D11
	   when x"2D18" => HER_VOM_FORTH(143 downto 128)<=DAT_I;--XAMP
	   when x"2D19" => HER_VOM_FORTH(159 downto 144)<=DAT_I;--YAMP
	   when x"2D1A" => HER_VOM_FORTH(10*16+15 downto 10*16)<=DAT_I;--  PW_FREQUENZ
	   when x"2D2A" => HER_VOM_FORTH(26*16+15 downto 26*16)<=DAT_I;--  VMAX2
	   when x"2D2B" => HER_VOM_FORTH(27*16+15 downto 27*16)<=DAT_I;--  RAMADRESSEBX
	   when x"2D2C" => HER_VOM_FORTH(28*16+15 downto 28*16)<=DAT_I;--  VMAX
	   when x"2D2D" => HER_VOM_FORTH(29*16+15 downto 29*16)<=DAT_I;--  DSCHRITT
	   when x"2D2E" => HER_VOM_FORTH(30*16+15 downto 30*16)<=DAT_I;--  DANF
	   when x"2D2F" => HER_VOM_FORTH(31*16+15 downto 31*16)<=DAT_I;--FPROPI
	   when others => null;
      end case;
    end if;		
  end process;



--process--Taktgenerator
--begin wait until (CLK6_I'event and CLK6_I='1');
  --TAKTZAEHLER<=TAKTZAEHLER+2; -- 50 Bit
  --PIDTAKT<=TAKTZAEHLER(2); --war schon 7 2, siehe auch unter end process
--  LANGSAMTAKT<=TAKTZAEHLER(17); --war schon 7
  --end process;
PIDTAKT<=CLK6_I; 

process--PID-Regler
variable MERKPOS: STD_LOGIC_VECTOR (3 downto 0);
variable ISTWERT,SOLLWERT: STD_LOGIC_VECTOR (31 downto 0);
variable WSTELL_A,WSTELL_B: STD_LOGIC;
variable STELLWERT,ZAEHLER: STD_LOGIC_VECTOR (15 downto 0);
variable STELLWERT32,SUMMEI: STD_LOGIC_VECTOR (31 downto 0);
variable STELLWERT48: STD_LOGIC_VECTOR (47 downto 0);
variable COUNTER4,ERRN: STD_LOGIC_VECTOR (15 downto 0);
variable ERRN32: STD_LOGIC_VECTOR (31 downto 0);
begin wait until (PIDTAKT'event and PIDTAKT='0');
  ---------
  MERKPOS:=MERKPOS(1 downto 0)&POS_A&POS_B; INTSX<='0';
  case MERKPOS is
    when "0100"|"0010"|"1011"|"1101" => ISTWERT:=ISTWERT+1; INTSX<='1';
    when "1000"|"0001"|"0111"|"1110" => ISTWERT:=ISTWERT-1; INTSX<='1';
    when others => ISTWERT:=ISTWERT;
    end case;
  POSDET1<=ISTWERT;
  HIN_ZUM_FORTH(95 downto 64)<=ISTWERT;
--  DEBUG<=COUNTER4(3 downto 0)&STELL_A&INTSX&POS_A&POS_B&HER_VOM_FORTH(3 downto 0)&MERKPOS;
  ------------
  if STELL_A='1' and WSTELL_A='0' then SOLLWERT:=SOLLWERT+1; INTSX<='1'; end if;
  if STELL_B='1' and WSTELL_B='0' then SOLLWERT:=SOLLWERT-1; INTSX<='1'; end if;
  WSTELL_A:=STELL_A;
  WSTELL_B:=STELL_B;
  HALTESTELLE<=SOLLWERT;
  HIN_ZUM_FORTH(159 downto 128)<=SOLLWERT;
  ------------
  if (INV_FINTI=x"0000") or (SOLLWERT=ISTWERT) then SUMMEI:=x"00000000"; end if;
  if SOLLWERT-ISTWERT<x"00000010" then
    ERRN32:=SOLLWERT-ISTWERT;
    ERRN:=ERRN32(15 downto 0);
    if INV_FINTI>x"0000" then
	  if COUNTER4<INV_FINTI then 
      COUNTER4:=COUNTER4+ERRN;
      else COUNTER4:=x"0000";
        SUMMEI:=SUMMEI+1;--INT5I<=NOT INT5I;
        if SUMMEI<x"FFFE0000" and SUMMEI>x"0001FFFF" then SUMMEI:=x"0001FFFF"; end if;
        end if;
	  end if;
    STELLWERT32:=SUMMEI+ERRN*FPROPI;--SUMMEI+ERRN*FPROPI;
  elsif ISTWERT-SOLLWERT<x"00000010" then
    ERRN32:=ISTWERT-SOLLWERT;
    ERRN:=ERRN32(15 downto 0);
    if INV_FINTI>x"0000" then
     if COUNTER4<=INV_FINTI then 
      COUNTER4:=COUNTER4+ERRN;
      else COUNTER4:=x"0000";--COUNTER4-INV_FINTI;
        SUMMEI:=SUMMEI-1;--INT5I<=NOT INT5I;
        if SUMMEI<x"FFFE0000" and SUMMEI>x"0001FFFF" then SUMMEI:=x"FFFE0000"; end if;
        end if;
	  end if;
    STELLWERT32:=SUMMEI-ERRN*FPROPI;
  else COUNTER4:=x"0000"; SUMMEI:=x"00000000"; STELLWERT32:=x"00000000"; end if;
  -------------
  DIR<=STELLWERT32(31);
--  STELLWERT:=STELLWERT32(15 downto 0);
  if STELLWERT32>x"FFFF0000" then STELLWERT:=x"0000"-STELLWERT32(15 downto 0);
  elsif STELLWERT32>x"0000FFFF" then STELLWERT:=x"FFFF";
  else STELLWERT:=STELLWERT32(15 downto 0); end if;
  -------------
--  DEBUG<=ERRN;
  HIN_ZUM_FORTH(175 downto 160)<=STELLWERT;
  STELLWERTH<=STELLWERT;
  ------
  end process;


--process--PID-Regler Kanal Y
--variable MERKPOS: STD_LOGIC_VECTOR (3 downto 0);
--variable ISTWERT,SOLLWERT: STD_LOGIC_VECTOR (31 downto 0);
--variable YWSTELL_A,YWSTELL_B: STD_LOGIC;
--variable STELLWERT,ZAEHLER: STD_LOGIC_VECTOR (15 downto 0);
--variable STELLWERT32,SUMMEI: STD_LOGIC_VECTOR (31 downto 0);
--variable STELLWERT48: STD_LOGIC_VECTOR (47 downto 0);
--variable COUNTER4,ERRN: STD_LOGIC_VECTOR (15 downto 0);
--variable ERRN32: STD_LOGIC_VECTOR (31 downto 0);
--begin wait until (PIDTAKT'event and PIDTAKT='0');
  -------
  --MERKPOS:=MERKPOS(1 downto 0)&YPOS_A&YPOS_B; INTSY<='0';
  --case MERKPOS is
    --when "0100"|"0010"|"1011"|"1101" => ISTWERT:=ISTWERT+1; INTSY<='1';
    --when "1000"|"0001"|"0111"|"1110" => ISTWERT:=ISTWERT-1; INTSY<='1';
    --when others => ISTWERT:=ISTWERT;
    --end case;
  --YPOSDET1<=ISTWERT;
  --HIN_ZUM_FORTH((16+0)*16+31 downto (16+0)*16)<=ISTWERT;
  --------
  --if YSTELL_A='1' and YWSTELL_A='0' then SOLLWERT:=SOLLWERT+1; INTSY<='1'; end if;
  --if YSTELL_B='1' and YWSTELL_B='0' then SOLLWERT:=SOLLWERT-1; INTSY<='1'; end if;
  --YWSTELL_A:=YSTELL_A;
  --YWSTELL_B:=YSTELL_B;
  --YHALTESTELLE<=SOLLWERT;
  --HIN_ZUM_FORTH((16+10)*16+31 downto (16+10)*16)<=SOLLWERT;
  --------
  --if INV_FINTI=x"0000" then SUMMEI:=x"00000000"; end if;
  --if SOLLWERT-ISTWERT<x"00000010" then
    --ERRN32:=SOLLWERT-ISTWERT;
    --ERRN:=ERRN32(15 downto 0);
    --if COUNTER4<=INV_FINTI-1 then 
      --COUNTER4:=COUNTER4+ERRN;
      --else COUNTER4:=x"0000";
        --SUMMEI:=SUMMEI+1;--INT5I<=NOT INT5I;
        --if SUMMEI<x"FFFE0000" and SUMMEI>x"0001FFFF" then SUMMEI:=x"0001FFFF"; end if;
        --end if;
    --STELLWERT32:=SUMMEI+ERRN*FPROPI;
  --elsif ISTWERT-SOLLWERT<x"00000010" then
    --ERRN32:=ISTWERT-SOLLWERT;
    --ERRN:=ERRN32(15 downto 0);
    --if COUNTER4<=INV_FINTI-1 then 
      --COUNTER4:=COUNTER4+ERRN;
      --else COUNTER4:=x"0000";--COUNTER4-INV_FINTI;
        --SUMMEI:=SUMMEI-1;--INT5I<=NOT INT5I;
        --if SUMMEI<x"FFFE0000" and SUMMEI>x"0001FFFF" then SUMMEI:=x"FFFE0000"; end if;
        --end if;
    --STELLWERT32:=SUMMEI-ERRN*FPROPI;
  --else COUNTER4:=x"0000"; SUMMEI:=x"00000000"; STELLWERT32:=x"00000000"; end if;
  ------
  --YDIR<=STELLWERT32(31);
  --if STELLWERT32>x"FFFF0000" then STELLWERT:=x"0000"-STELLWERT32(15 downto 0);
  --elsif STELLWERT32>x"0000FFFF" then STELLWERT:=x"FFFF";
  --else STELLWERT:=STELLWERT32(15 downto 0); end if;
  --------
  --YSTELLWERTH<=STELLWERT;
  --------
  --end process;

INTSY<='0';--das muss wieder weg, wenn Y angeschaltet wird.
BIT0<='0';
BIT1<='0';
PROG_A<='0';
PROG_B<='0';
process--Tasten entprellen und konstante Eingabedaten für process(CLK)
begin wait until (PIDTAKT'event and PIDTAKT='1');
  POS_A<=HER_VOM_FORTH(0) xor BIT0 xor not IO_EXTRA(36);
  POS_B<=HER_VOM_FORTH(1) xor BIT1 xor not IO_EXTRA(38);
  YPOS_A<=IO_EXTRA(37);
  YPOS_B<=IO_EXTRA(39);
  STELL_A<=HER_VOM_FORTH(2) xor PROG_A;
  STELL_B<=HER_VOM_FORTH(3) xor PROG_B;
  YSTELL_A<=YPROG_A;
  YSTELL_B<=YPROG_B;
  BTN_NORTH_ENTPRELLT<=HER_VOM_FORTH(4);--not(BTN_N xor HER_VOM_FORTH(4)); -- hat funktioniert: xor E_RXD(0);
  BTN_SOUTH_ENTPRELLT<=HER_VOM_FORTH(5);--not(BTN_S xor HER_VOM_FORTH(5)); -- hat funktioniert: xor E_RXD(1);
  XYBIT<=HER_VOM_FORTH(6);
  RAMADRESSEAX<=RAMADRESSEA;
  SPEEDBIT<=HER_VOM_FORTH(7);
  XAMP<=HER_VOM_FORTH(143 downto 128);
  YAMP<=HER_VOM_FORTH(159 downto 144);
  DIRXW<=DIR;
  POSDETXW<=POSDET1;
  STELLWERTXW<=STELLWERTH;
  HALTESTELLEXW<=HALTESTELLE(15 downto 0);
  DIRYW<=YDIR;
  POSDETYW<=YPOSDET1;
  STELLWERTYW<=YSTELLWERTH;
  HALTESTELLEYW<=YHALTESTELLE(15 downto 0);
  FPROPI<=HER_VOM_FORTH(31*16+15 downto 31*16);
  DREIPHASENVERSCHIEBEBIT<=HER_VOM_FORTH(29);
  DREIPHASENVERSCHIEBEBITY<=HER_VOM_FORTH(33);
  INV_FINTI<=HER_VOM_FORTH(127 downto 112);
  LICHTBIT<=HER_VOM_FORTH(30);
  ------zum PID-Prozessor-------
  RAMADRESSEBX<=HER_VOM_FORTH(27*16+15 downto 27*16);--RAMADRESSEB;
  DANF<=HER_VOM_FORTH(30*16+15 downto 30*16);
  DSCHRITT<=HER_VOM_FORTH(29*16+15 downto 29*16);
  VMAX<=HER_VOM_FORTH(28*16+15 downto 28*16);
  VMAX2<=HER_VOM_FORTH(26*16+15 downto 26*16);
  PAUSENBIT<=HER_VOM_FORTH(28);
  PIDUHR<=TAKTZAEHLER(23 downto 8);
  
  NOTAUS<=HER_VOM_FORTH(21);
  end process;


--process--PID-Prozessor
--variable VCOUNT,DCOUNT,XYCOUNT: STD_LOGIC_VECTOR (31 downto 0);
--variable WURZELBIT: STD_LOGIC_VECTOR (1 downto 0);
--variable J,JJ: STD_LOGIC_VECTOR (31 downto 0):=x"00000000";
--variable V,W: STD_LOGIC_VECTOR (47 downto 0);
--variable V64: STD_LOGIC_VECTOR (63 downto 0);
--variable WA,WWA: STD_LOGIC_VECTOR (31 downto 0):=x"00000000";
--variable RAMADRESSEA_L: STD_LOGIC_VECTOR (15 downto 0);
--variable I,K,VM: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
--begin wait until (PIDTAKT'event and PIDTAKT='0');
  --PROG_A<='0'; YPROG_A<='0';
  --PROG_B<='0'; YPROG_B<='0';
  --if JJ>I&x"0000" then 
    --JJ:=JJ-J-J+1;J:=J-1;
    --else 
  	   --JJ:=JJ+J+J+1;J:=J+1; 
      --end if;
  --if WWA>DSCHRITT&x"0000"&"0" then -- & wegen 2a
    --WWA:=WWA-WA-WA+1;WA:=WA-1;
    --else 
  	   --WWA:=WWA+WA+WA+1;WA:=WA+1; 
      --end if;
  
 --if VCOUNT<x"0000005F" then VCOUNT:=VCOUNT+1; else
  --if (I>1 or PAUSENBIT='0') and RAMADRESSEA_L/=RAMADRESSEBX then
    --VCOUNT:=x"00000000";
    --V64:=J*WA;
    --V:=V64(47 downto 0);
    --W:=W+(x"0000"&DANF&x"0000")+V;
    --if WURZELBIT="10" then
      --W:=W+(x"0000"&DANF&x"0000")+V;--(V&x"00");
      --end if;

    --if RAMADRESSEA_L/=W(47 downto 32) then
      --if RAMINHALTNEU(1)='0' then
        --PROG_A<=not RAMINHALTNEU(0);
        --PROG_B<=RAMINHALTNEU(0);
        --WURZELBIT:="01";
        --else
          --if WURZELBIT="01" then WURZELBIT:="10"; 
            --else WURZELBIT:="00"; end if;
          --YPROG_A<=not RAMINHALTNEU(0);
          --YPROG_B<=RAMINHALTNEU(0);
          --end if;
      --if RAMINHALTNEU(2)='1' then VM:=VMAX; else VM:=VMAX2; end if; 
      --if RAMINHALTNEU(3)='1' then
  		  --K:=K+1; 
        --if (x"0000"&DANF)+V(47 downto 16)<VM then I:=I+1; else I:=I-1; end if;
        --else 
		    --if I>K then I:=I-1; end if;
          --if K>0 then K:=K-1; end if;
			 --end if;
      --HIN_ZUM_FORTH(14)<=RAMINHALTNEU(2);
      --XYCOUNT:=XYCOUNT+1;
      --RAMADRESSEA_L:=RAMADRESSEA_L+1;
      --end if;
    --else V:=x"000000000000"; end if;
	--end if;
  --HIN_ZUM_FORTH(127 downto 112)<=I;
----  HIN_ZUM_FORTH((16+14)*16+31 downto (16+14)*16)<=XYCOUNT;--D02E
  --HIN_ZUM_FORTH((16+12)*16+15 downto (16+12)*16)<=(DANF+V(31 downto 16));--D02C
----  HIN_ZUM_FORTH((16+09)*16+15 downto (16+09)*16)<=PIDUHR;--D029-
  --HIN_ZUM_FORTH((16+03)*16+15 downto (16+03)*16)<=RAMADRESSEA_L;--D023
  --RAMADRESSEA<=RAMADRESSEA_L;
  --end process;

process--3-Phasen-Steuerung Motor X
variable PXV: STD_LOGIC_VECTOR (9 downto 0);
variable PXW: STD_LOGIC_VECTOR (7 downto 0);
variable AXW: STD_LOGIC_VECTOR (15 downto 0);
variable AXW32: STD_LOGIC_VECTOR (31 downto 0);
begin wait until (PIDTAKT'event and PIDTAKT='0');
  if DREIPHASENVERSCHIEBEBIT='1' then
--    PXV:=POSDETXW(7 downto 0)+POSDETXW(7 downto 0)+POSDETXW(7 downto 0);  
--    PXW:=PXV(7)&PXV(7)&PXV(7 downto 2); -- sra 2???;
    PXV:=POSDETXW(9 downto 0)+POSDETXW(9 downto 0)+POSDETXW(9 downto 0);
    PXW:=PXV(9 downto 2);
    if DIRXW='0' then PXW:=PXW+x"40"; else PXW:=PXW-x"40"; end if;
    AXW32:=STELLWERTXW*XAMP;
	 AXW:=AXW32(31 downto 16);
    else
--      PXV:=HALTESTELLEXW(7 downto 0)+HALTESTELLEXW(7 downto 0)+HALTESTELLEXW(7 downto 0);
--      PXW:=PXV(7)&PXV(7)&PXV(7 downto 2); -- sra 2???;
      PXV:=HALTESTELLEXW(9 downto 0)+HALTESTELLEXW(9 downto 0)+HALTESTELLEXW(9 downto 0);
      PXW:=PXV(9 downto 2);
      AXW:=XAMP;
      end if;
  PXG<=x"00"&PXW;
  AXG<=AXW;
  end process;
PSW<="1111";

--process--3-Phasen-Steuerung Motor Y
--variable PYV: STD_LOGIC_VECTOR (9 downto 0);
--variable PYW: STD_LOGIC_VECTOR (7 downto 0);
--variable AYW: STD_LOGIC_VECTOR (15 downto 0);
--variable AYW32: STD_LOGIC_VECTOR (31 downto 0);
--begin wait until (PIDTAKT'event and PIDTAKT='0');
  --if DREIPHASENVERSCHIEBEBITY='1' then 
    --PYV:=POSDETYW(9 downto 0)+POSDETYW(9 downto 0)+POSDETYW(9 downto 0);
    --PYW:=PYV(9 downto 2);
    --if DIRYW='0' then PYW:=PYW+x"40"; else PYW:=PYW-x"40"; end if;
    --AYW32:=STELLWERTYW*YAMP;
	 --AYW:=AYW32(31 downto 16);
    --else
      --PYV:=HALTESTELLEYW(9 downto 0)+HALTESTELLEYW(9 downto 0)+HALTESTELLEYW(9 downto 0);
      --PYW:=PYV(9 downto 2);
      --AYW:=YAMP; 
      --end if;
  --PYG<=x"00"&PYW;
  --AYG<=AYW;
  --end process;

process--Sinustabelle lesen
variable YY: STD_LOGIC_VECTOR (31 downto 0);
variable I:integer;
variable A,P,Y: RTYPE;
variable AYW: STD_LOGIC_VECTOR (15 downto 0);
begin wait until (PIDTAKT'event and PIDTAKT='1');
  A(0):=AXG; A(1):=AXG; A(2):=AXG;
  A(3):=AYG; A(4):=AYG; A(5):=AYG;
  P(0):=PXG; P(1):=PXG-x"0055"; P(2):=PXG-x"00AB";
  P(3):=PYG; P(4):=PYG-x"0055"; P(5):=PYG-x"00AB";
  I:=I+1; if I=6 then I:=0; end if;
  YY:=ATABELLE(CONV_INTEGER(P(I)(7 downto 0)))*A(I);
  Y(I):=YY(31 downto 16);
  AMP1<=Y(0)+x"7FFF"-A(0)(15 downto 1);
  AMP2<=Y(1)+x"7FFF"-A(1)(15 downto 1);
  AMP3<=Y(2)+x"7FFF"-A(2)(15 downto 1);
--AMP1<=DEBUGI;
--AMP2<=x"AAAA";
--AMP3<=x"CCCC";
--  HIN_ZUM_FORTH(191 downto 176)<=Y(0);
--  HIN_ZUM_FORTH(207 downto 192)<=Y(1);
  --YAMP1<=Y(3)+x"7FFF"-A(3)(15 downto 1);
  --YAMP2<=Y(4)+x"7FFF"-A(4)(15 downto 1);
  --YAMP3<=Y(5)+x"7FFF"-A(5)(15 downto 1);
----  HIN_ZUM_FORTH(239 downto 224)<=Y(3);
----  HIN_ZUM_FORTH(255 downto 240)<=Y(4);
  end process;
--DEBUG<=PXG;
DEBUG<=AMP2;
--DEBUG<=AXG;


process--PWM-Generator1
begin wait until (CLK50_I'event and CLK50_I='1');
--begin if (LANGSAMTAKT'event and LANGSAMTAKT='1') then --war mal zum Oszillographieren
  PWMZAEHLER <=PWMZAEHLER+PW_FREQUENZ;
  PWMZAEHLERH<=PWMZAEHLER+PW_FREQUENZ-x"051E";--x"028F";--1 Mikrosekunde versetzt
                                              --028E=1A 50MHZTakte * 19 PW_FREQUENZ
  IO_N(26 downto 21)<="000000";
  if     (PWMZAEHLER<AMP1_R)     and (PWMZAEHLERH<AMP1_R) and PSW(1)='1' then IO_N(21)<='1'; end if;
  if not (PWMZAEHLER<AMP1_R) and not (PWMZAEHLERH<AMP1_R) and PSW(1)='1' then IO_N(22)<='1'; end if;
  if     (PWMZAEHLER<AMP2_R)     and (PWMZAEHLERH<AMP2_R) and PSW(2)='1' then IO_N(23)<='1'; end if;
  if not (PWMZAEHLER<AMP2_R) and not (PWMZAEHLERH<AMP2_R) and PSW(2)='1' then IO_N(24)<='1'; end if;
  if     (PWMZAEHLER<AMP3_R)     and (PWMZAEHLERH<AMP3_R) and PSW(3)='1' then IO_N(25)<='1'; end if;
  if not (PWMZAEHLER<AMP3_R) and not (PWMZAEHLERH<AMP3_R) and PSW(3)='1' then IO_N(26)<='1'; end if;
  P15BIT<=PWMZAEHLER(15);
  end process;
--process--PWM-GeneratorX
--begin wait until (CLK50_I'event and CLK50_I='1');
  --IO_N(26 downto 21)<="000000";
  --if     (PWMZAEHLER_R<AMP1_R)     and (PWMZAEHLERH_R<AMP1_R) and PSW(1)='1' then IO_N(21)<='1'; end if;
  --if not (PWMZAEHLER_R<AMP1_R) and not (PWMZAEHLERH_R<AMP1_R) and PSW(1)='1' then IO_N(22)<='1'; end if;
  --if     (PWMZAEHLER_R<AMP2_R)     and (PWMZAEHLERH_R<AMP2_R) and PSW(2)='1' then IO_N(23)<='1'; end if;
  --if not (PWMZAEHLER_R<AMP2_R) and not (PWMZAEHLERH_R<AMP2_R) and PSW(2)='1' then IO_N(24)<='1'; end if;
  --if     (PWMZAEHLER_R<AMP3_R)     and (PWMZAEHLERH_R<AMP3_R) and PSW(3)='1' then IO_N(25)<='1'; end if;
  --if not (PWMZAEHLER_R<AMP3_R) and not (PWMZAEHLERH_R<AMP3_R) and PSW(3)='1' then IO_N(26)<='1'; end if;
  --end process;
--process--PWM-GeneratorY
--begin wait until (CLK50_I'event and CLK50_I='1');
  --IO_N(32 downto 27)<="000000";
  --if     (PWMZAEHLER_R<YAMP1_R)     and (PWMZAEHLERH_R<YAMP1_R) and PSW(1)='1' then IO_N(27)<='1'; end if;
  --if not (PWMZAEHLER_R<YAMP1_R) and not (PWMZAEHLERH_R<YAMP1_R) and PSW(1)='1' then IO_N(28)<='1'; end if;
  --if     (PWMZAEHLER_R<YAMP2_R)     and (PWMZAEHLERH_R<YAMP2_R) and PSW(2)='1' then IO_N(29)<='1'; end if;
  --if not (PWMZAEHLER_R<YAMP2_R) and not (PWMZAEHLERH_R<YAMP2_R) and PSW(2)='1' then IO_N(30)<='1'; end if;
  --if     (PWMZAEHLER_R<YAMP3_R)     and (PWMZAEHLERH_R<YAMP3_R) and PSW(3)='1' then IO_N(31)<='1'; end if;
  --if not (PWMZAEHLER_R<YAMP3_R) and not (PWMZAEHLERH_R<YAMP3_R) and PSW(3)='1' then IO_N(32)<='1'; end if;
  --end process;
process
begin wait until (CLK50_I'event and CLK50_I='0');
  PW_FREQUENZ<=HER_VOM_FORTH(10*16+15 downto 10*16);
  PWMZAEHLER_R<=PWMZAEHLER;
  PWMZAEHLERH_R<=PWMZAEHLERH;
  AMP1_R<=AMP1;
  AMP2_R<=AMP2;
  AMP3_R<=AMP3;
  --YAMP1_R<=YAMP1;
  --YAMP2_R<=YAMP2;
  --YAMP3_R<=YAMP3;
  end process;
--PW_FREQUENZ<=x"0019";--x"0019" ist ca. 20 kHz


--LED(0 to 7)=IO(20 downto 13)
IO_N(13)<='1' when PWMZAEHLER<AMP1 else '0'; --LED0
IO_N(14)<='1' when PWMZAEHLER<AMP2 else '0';
IO_N(15)<='1' when PWMZAEHLER<AMP3 else '0';
IO_N(16)<='Z';--E_RX_DV;
IO_N(17)<='1' when PWMZAEHLER<YAMP1 else '0';
IO_N(18)<='1' when PWMZAEHLER<YAMP2 else '0';
IO_N(19)<='1' when PWMZAEHLER<YAMP3 else '0';
IO_N(20)<=IO_EXTRA(38) xor IO_EXTRA(36); --POS_A und B auf LED7


HIN_ZUM_FORTH(1)<=DIR; -- vom PID-Regler
HIN_ZUM_FORTH(31)<=PWM;
INTXY<=INTSX or INTSY;
HIN_ZUM_FORTH(13)<=IO(34); --INDEX1
IO<=IO_N WHEN NOTAUS='0' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";


   --RAMB16_S4_S4_4000 : RAMB16_S4_S4
-- RAMB 3000..3FFF
   --port map (
      --DOA => FETCH_VOM_RAM(9)(3 downto 0),      -- Port A 4-bit Data Output
      --DOB => RAMINHALTNEU,      -- Port B 4-bit Data Output
      --ADDRA => ADR_I(11 downto 0),--ADRESSE_ZUM_RAM(11 downto 0),  -- Port A 12-bit Address Input
      --ADDRB => RAMADRESSEA(11 downto 0),  -- Port B 12-bit Address Input
      --CLKA => not CLK_I,    -- Port A Clock
      --CLKB => PIDTAKT,    -- Port B Clock
      --DIA => DAT_I(3 downto 0),--STORE_ZUM_RAM(3 downto 0),      -- Port A 4-bit Data Input
      --DIB => "0000",      -- Port B 4-bit Data Input
      --ENA => '1',      -- Port A RAM Enable Input
      --ENB => '1',      -- Port B RAM Enable Input
      --SSRA => '0',    -- Port A Synchronous Set/Reset Input
      --SSRB => '0',    -- Port B Synchronous Set/Reset Input
      --WEA => WE_ZUM_RAM(9),      -- Port A Write Enable Input
      --WEB => '0'       -- Port B Write Enable Input
   --);

 --   End of RAMB16_S4_S4_inst4000 instantiation
WE_ZUM_RAM(9)<=WE_I when ADR_I="0011------------" else '0';--3000/3FFF;


process--asynchrone Rueckgabewerte
begin wait until (CLK_I'event and CLK_I='0');
  HIN_ZUM_FORTH(15)<=P15BIT; -- 50 Bit
  DEBUG_R<=DEBUG;
  end process;

with ADR_I select 
  DAT_O<=--x"000"&FETCH_VOM_RAM(9)(3 downto 0) when "0011------------",--3000/3FFF;
         "01"&IO(32 downto 27)&"01"&IO(26 downto 21) when x"D005",--PORTSCA
         HIN_ZUM_FORTH(79 downto 64) when x"D014",--ISTWERT1L
         HIN_ZUM_FORTH(95 downto 80) when x"D015",--ISTWERT1H
         DEBUG_R when x"D016",--DEBUG
         HIN_ZUM_FORTH(127 downto 112) when x"D017",--I
         HIN_ZUM_FORTH(143 downto 128) when x"D018",--SOLLWERT1L
         HIN_ZUM_FORTH(159 downto 144) when x"D019",--SOLLWERT1H
         HIN_ZUM_FORTH(175 downto 160) when x"D01A",--STELLWERT1
         HIN_ZUM_FORTH((16+0)*16+15 downto (16+0)*16+00) when x"D020",--ISTWERT2L
         HIN_ZUM_FORTH((16+0)*16+31 downto (16+0)*16+16) when x"D021",--ISTWERT2H
         HIN_ZUM_FORTH((16+10)*16+15 downto (16+10)*16+00) when x"D02A",--SOLLWERT2L
         HIN_ZUM_FORTH((16+10)*16+31 downto (16+10)*16+16) when x"D02B",--SOLLWERT2H
         HIN_ZUM_FORTH((16+12)*16+15 downto (16+12)*16) when x"D02C",--DANF+V         
         HIN_ZUM_FORTH((16+03)*16+15 downto (16+03)*16) when x"D023",--RAMADRESSEA_L         DAT_I when others;
         x"000"&"000"&HIN_ZUM_FORTH(1) when x"D101",--DIR -- vom PID-Regler
         x"000"&"000"&HIN_ZUM_FORTH(13) when x"D10D",--INDEX1
         x"000"&"000"&HIN_ZUM_FORTH(14) when x"D10E",--RAMINHALTNEU(2);
         x"000"&"000"&HIN_ZUM_FORTH(15) when x"D10F",--PWMZAEHLER(15);
         x"000"&"000"&HIN_ZUM_FORTH(31) when x"D11F",--PWM
         DAT_I when others;


CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Purzel;

