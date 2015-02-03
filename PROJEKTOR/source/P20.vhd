library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine20 is
  Port (
    RxD: in  STD_LOGIC:='1';  -- serieller Eingang: 115200/odd/8/1/Xon/Xoff
    TxD: out STD_LOGIC;  -- serieller Ausgang: ebenso
    INTXY: in  STD_LOGIC;
    
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
    WE_O: out STD_LOGIC;
    
  SIM_PC: out STD_LOGIC_VECTOR (15 downto 0)
    
    
   );
end Platine20;

architecture CR4000 of Platine20 is
signal TAKTZAEHLER: STD_LOGIC_VECTOR (50 downto 0):=(others => '0');
type REG is array(0 to 3) of STD_LOGIC_VECTOR (15 downto 0);
type RTYPE is array(0 to 15) of STD_LOGIC_VECTOR (15 downto 0);
signal PD_VOM_RAM,FETCH_VOM_RAM: RTYPE;
signal PC_ZUM_RAM,ADRESSE_ZUM_RAM,EXFET,ZUM_FORTH: STD_LOGIC_VECTOR (15 downto 0);
signal PDNT: STD_LOGIC_VECTOR (15 downto 0):=x"0000";
signal STORE_ZUM_RAM: STD_LOGIC_VECTOR (15 downto 0);
signal WE_ZUM_RAM: STD_LOGIC_VECTOR (15 downto 0);
signal RP_ZUM_RAM,SP_ZUM_RAM,RPC_ZUM_RAM,RPCC_VOM_RAM: STD_LOGIC_VECTOR (15 downto 0);
signal RW_ZUM_RAM: STD_LOGIC;
signal HOLE_VOM_STAPEL,STORE_ZUM_STAPEL,ADRESSE_ZUM_STAPEL: REG;
signal WE_ZUM_STAPEL: STD_LOGIC_VECTOR (3 downto 0);

--serielle Ausgabe
signal dbOutput,HIN_ZUR_AUSGABE: STD_LOGIC_VECTOR (7 downto 0):=x"00"; -- die auszugebende Hexzahl
signal SCHREIBBIT1_ZUR_AUSGABE,SCHREIBBIT2_X,P19SCHREIBBIT1,SCHREIBBIT2_RUHEND: STD_LOGIC:='0';

--serielle Eingabe
signal dbInput,HER_VOM_RAM: STD_LOGIC_VECTOR (7 downto 0):=x"00"; -- die auszugebende Hexzahl
signal XOFFbit,XOFFInput,XOFF_INPUT_RUHEND: STD_LOGIC:='0';
signal RXDI: STD_LOGIC:='1';

--INPUT/OUTPUT
signal FETCHX: STD_LOGIC_VECTOR (15 downto 0);
signal WSTORE_ZUM_RAM: STD_LOGIC;
--STRG Tasten:
signal STRG,STRG_RUHEND,STRG_M,STRG_MERK,STRG_MERK_RUHEND: STD_LOGIC:='0';
signal dbInput_RUHEND,dbInput_M: STD_LOGIC_VECTOR (7 downto 0):=x"00"; -- die auszugebende Hexzahl

--INT:
signal INTXY_INT,INTXY_MERK: STD_LOGIC:='0';

----IO-Ersatz:
--signal INTXY: STD_LOGIC;
--signal CLK6_I: STD_LOGIC;
--signal ADR_O: STD_LOGIC_VECTOR (15 downto 0);
--signal DAT_I: STD_LOGIC_VECTOR (15 downto 0);
--signal DAT_O: STD_LOGIC_VECTOR (15 downto 0);
--signal WE_O: STD_LOGIC;

---unterschiedliche Taktfrequenz
--signal CLK_I: STD_LOGIC;


--Distributed RAM
type STAPELTYPE is array(0 to 31) of STD_LOGIC_VECTOR (15 downto 0);
signal stap1,stap2,stap3,stap0: STAPELTYPE;

function P (SP : integer) return integer is begin
--  return CONV_INTEGER(CONV_STD_LOGIC_VECTOR(SP,1024)(1 downto 0));
  return CONV_INTEGER(CONV_UNSIGNED(SP,2));
  end;

-- parameterized module component declaration
component ram0000bis1FFF
    port (DataInA: in  std_logic_vector(15 downto 0); 
        DataInB: in  std_logic_vector(15 downto 0); 
        AddressA: in  std_logic_vector(12 downto 0); 
        AddressB: in  std_logic_vector(12 downto 0); 
        ClockA: in  std_logic; ClockB: in  std_logic; 
        ClockEnA: in  std_logic; ClockEnB: in  std_logic; 
        WrA: in  std_logic; WrB: in  std_logic; ResetA: in  std_logic; 
        ResetB: in  std_logic; QA: out  std_logic_vector(15 downto 0); 
        QB: out  std_logic_vector(15 downto 0));
end component;

-- parameterized module component declaration
component ram2C00bis2FFF
    port (DataInA: in  std_logic_vector(15 downto 0); 
        DataInB: in  std_logic_vector(15 downto 0); 
        AddressA: in  std_logic_vector(9 downto 0); 
        AddressB: in  std_logic_vector(9 downto 0); 
        ClockA: in  std_logic; ClockB: in  std_logic; 
        ClockEnA: in  std_logic; ClockEnB: in  std_logic; 
        WrA: in  std_logic; WrB: in  std_logic; ResetA: in  std_logic; 
        ResetB: in  std_logic; QA: out  std_logic_vector(15 downto 0); 
        QB: out  std_logic_vector(15 downto 0));
end component;

-- parameterized module component declaration
component ramE000bisFFFF
    port (Clock: in  std_logic; ClockEn: in  std_logic; 
        Reset: in  std_logic; WE: in  std_logic; 
        Address: in  std_logic_vector(12 downto 0); 
        Data: in  std_logic_vector(7 downto 0); 
        Q: out  std_logic_vector(7 downto 0));
end component;

signal EXTRATAKT:  STD_LOGIC;
signal DUMPD: STD_LOGIC_VECTOR (15 downto 0);
begin


-- neu WB:
ADR_O<=ADRESSE_ZUM_RAM;
DAT_O<=STORE_ZUM_RAM;
WE_O<=WSTORE_ZUM_RAM;

--FSuch
--SIM_PC<=PC_ZUM_RAM;
SIM_PC<=SP_ZUM_RAM;
--SIM_PC<=DUMPD;






process --ruhende Eingabedaten:
begin wait until (CLK_I'event and CLK_I='0');
  SCHREIBBIT2_RUHEND<=SCHREIBBIT2_X;
  XOFF_INPUT_RUHEND<=XOFFinput;
  STRG_M<=STRG;
  STRG_RUHEND<=STRG_M;
  dbInput_M<=dbInput;
  dbInput_RUHEND<=dbInput_M;
  INTXY_INT<=INTXY;
  end process;




----
process
variable PC,PD,RPC,RPCC: STD_LOGIC_VECTOR (15 downto 0);
variable RP: STD_LOGIC_VECTOR (15 downto 0):=x"3000";
variable SP: integer:=0;
variable R: REG; --array(0 to 3) of STD_LOGIC_VECTOR (15 downto 0);
variable W: STD_LOGIC_VECTOR (3 downto 0);
variable RW: STD_LOGIC;
variable U: STD_LOGIC_VECTOR (31 downto 0);
variable STAP: STD_LOGIC_VECTOR (67 downto 0);
variable EMIT: STD_LOGIC_VECTOR (15 downto 0);
variable SCHREIBBIT1,SCHREIBBIT2,XOFF_INPUT_L: STD_LOGIC;
variable KEYCODE,KEYCODE_L: STD_LOGIC_VECTOR (7 downto 0);
variable FETCH,STORE: STD_LOGIC_VECTOR (15 downto 0);
variable WSTORE: STD_LOGIC;
variable SUMME: STD_LOGIC_VECTOR (31 downto 0);
variable CRC_SUMME: STD_LOGIC_VECTOR (39 downto 0);
variable DISTANZ: STD_LOGIC_VECTOR (15 downto 0);
variable XOBIT_L: STD_LOGIC;
variable A,B,C,D: STD_LOGIC_VECTOR (15 downto 0);
variable T: integer range 0 to 4;
variable STAK: STD_LOGIC_VECTOR (7 downto 0);
variable LADR1,LADR2: integer;
variable WL1,WL2: STD_LOGIC;
variable STOREADRESSE: STD_LOGIC_VECTOR (15 downto 0);
--variable I: RTYPE;

begin wait until (CLK_I'event and CLK_I='1');
  if STRG_RUHEND/=STRG_MERK then 
--    PD:=x"4030"+dbInput_RUHEND+
    KEYCODE_L:=dbInput_RUHEND;
    PD:=x"4016";
    STRG_MERK<=STRG_RUHEND;
  elsif INTXY_INT/=INTXY_MERK then
    PD:=x"4014";
    INTXY_MERK<=INTXY_INT;
    else PC:=PC+1; PD:=PDNT; end if;
  R:=HOLE_VOM_STAPEL;
  W:="0000";
  RPCC:=RPCC_VOM_RAM;
  SCHREIBBIT2:=SCHREIBBIT2_RUHEND;
  XOFF_INPUT_L:=XOFF_INPUT_RUHEND;
  RW:='0';
  KEYCODE:=HER_VOM_RAM;
  FETCH:=FETCHX;
  WSTORE:='0';
  DISTANZ:=PD(11)&PD(11)&PD(11)&PD(11)&PD(11 downto 0);
  WL1:='0';
  WL2:='0';
  
  D:=R(P(SP-1));
  C:=R(P(SP-2));
  B:=R(P(SP-3));
  A:=R(P(SP-4));
  T:=0;
 
  --if PD="101-1-----------" then  --Returnbit auswerten
    --PC:=RPCC; RP:=RP+1; PD(11):='0';
    --els
  if PD(15 downto 14)="01" then -- 4000-7FFF Unterprogrammaufruf
--    when "010-------------" => -- 4000-5FFF Unterprogrammaufruf
      RPC:=PC;
      PC:=PD and x"3FFF";
      RP:=RP-1;
      RW:='1';
    elsif PD(15 downto 12)="1000" then -- 8000-8FFF unbedingter relativer Sprung
      PC:=PC+DISTANZ;
    elsif PD(15 downto 12)="1001" then -- 9000-9FFF bedingter relativer Sprung
      if R(P(SP-1))=x"0000" then
        PC:=PC+DISTANZ;
        end if;
      SP:=SP-1;
    elsif PD=x"A003" then -- ; Rückkehr aus Unterprogramm
      PC:=RPCC; 
      RP:=RP+1;
    elsif PD=x"A00D" then -- 0= Vergleich ob gleich Null
      if D=x"0000" then D:=x"FFFF"; 
        else D:=x"0000"; end if;
      T:=1;
    elsif PD=x"A00F" then -- 0< Vergleich ob kleiner Null
      if D>=x"8000" then D:=x"FFFF";
        else D:=x"0000"; end if;
      T:=1;
    elsif PD=x"A000" then -- MINUS Vorzeichen wechseln
      D:=(not D)+1;
      T:=1;
    elsif PD=x"A00B" then -- NOT Bitweises Komplement
      D:=not D;
      T:=1;
    elsif PD=x"A008" then -- AND Bitweises Und
      D:=C and D; 
      T:=1;
      SP:=SP-1;
    elsif PD=x"A00E" then -- OR Bitweises Oder
      D:=C or D; 
      T:=1;
      SP:=SP-1;
    elsif PD=x"A007" then -- + Addition
      D:=C+D; 
      T:=1;
      SP:=SP-1;
    elsif PD=x"A001" then -- U+ Addition mit Übertrag
      U:=(x"0000"&B)+(x"0000"&C)+(x"0000"&D);
      C:=U(31 downto 16);
      D:=U(15 downto 0);
      T:=2;
      SP:=SP-1;
    elsif PD=x"A002" then -- U* Multiplikation mit Übertrag
      U:=(x"0000"&B)+C*D;
      C:=U(31 downto 16);
      D:=U(15 downto 0);
      T:=2;
      SP:=SP-1;
    elsif PD=x"A005" then -- EMIT Zeichen ausgeben
      if (SCHREIBBIT1=SCHREIBBIT2) and XOFF_INPUT_L='0' then
        EMIT:=D;
        SCHREIBBIT1:=not SCHREIBBIT2;
        T:=0;
        SP:=SP-1;
        else PC:=PC-1; end if; -- warten
    elsif PD=x"A009" then -- STORE Speicheradresse beschreiben
      STORE:=C;STOREADRESSE:=D;
      case STOREADRESSE is
        when "1101000000000001" => SP:=CONV_INTEGER(C);
        when "1101000000000010" => RP:=C;
        when "1101000000000011" => PC:=C;
        when others => WSTORE:='1' ;
        end case;
      T:=0;
      SP:=SP-2;
    elsif PD=x"A00A" then -- FETCH Speicheradresse lesen
      case D is
        when x"D000" => D:=x"00"&KEYCODE_L;
        when x"D001" => D:=CONV_STD_LOGIC_VECTOR(SP,16);
--        when x"D001" => D:=CONV_UNSIGNED(SP,16);
        when x"D002" => D:=RP;
        when x"D003" => D:=PC;
        when others => D:=EXFET;
        end case;
      T:=1;
----ab hier noch frei 4 6 C
----von 1652 (9312) 5513 (9312) 3334 (4656) nach PAR
----auf 1691        5624        3385                  mit BRAM
--    elsif PD=x"A00C" then -- LVAR schreiben und lesen
--	   T:=0;SP:=SP-1;
--      if D(13)='1' then SP:=SP-1; STORE_ZU_LVAR2<=B; WL2:='1'; end if;
--      if D( 5)='1' then SP:=SP-1; STORE_ZU_LVAR1<=C; WL1:='1'; end if;
--      if D(12)='1' then SP:=SP+1; C:=FETCH_VON_LVAR2; T:=T+1; end if;
--      if D( 4)='1' then SP:=SP+1; D:=FETCH_VON_LVAR1; T:=T+1; end if;
    elsif PD(15 downto 12)="1011" then -- neues Umstapeln
      STAK:="00000000";
      if PD(7)='1' then STAK:=STAK(5 downto 0)&"11"; T:=T+1; end if;
      if PD(6)='1' then STAK:=STAK(5 downto 0)&"10"; T:=T+1; end if;
      if PD(5)='1' then STAK:=STAK(5 downto 0)&"01"; T:=T+1; end if;
      if PD(4)='1' then STAK:=STAK(5 downto 0)&"00"; T:=T+1; end if;
      if PD(3)='1' then STAK:=STAK(5 downto 0)&"11"; T:=T+1; end if;
      if PD(2)='1' then STAK:=STAK(5 downto 0)&"10"; T:=T+1; end if;
      if PD(1)='1' then STAK:=STAK(5 downto 0)&"01"; T:=T+1; end if;
      if PD(0)='1' then STAK:=STAK(5 downto 0)&"00"; T:=T+1; end if;
      D:=R(P(SP-1-CONV_INTEGER(STAK(1 downto 0))));
      C:=R(P(SP-1-CONV_INTEGER(STAK(3 downto 2))));
      B:=R(P(SP-1-CONV_INTEGER(STAK(5 downto 4))));
      A:=R(P(SP-1-CONV_INTEGER(STAK(7 downto 6))));
--  DUMPD<=CONV_STD_LOGIC_VECTOR(CONV_INTEGER(PD(11 downto 8)),16);
      --SP:=SP+CONV_INTEGER(PD(11 downto 8))-4;
      if PD(11 downto 8)="0010" then SP:=SP-2;
      elsif PD(11 downto 8)="0011" then SP:=SP-1;
      elsif PD(11 downto 8)="0101" then SP:=SP+1;
      elsif PD(11 downto 8)="0110" then SP:=SP+2;
      end if;



--EXTRAS
 --elsif PD=x"A012" then --D+ 32 BIT ADDITION
    --SUMME:=(A&B)+(C&D);
    --C:=SUMME(31 downto 16);
    --D:=SUMME(15 downto 0);
    --SP:=SP-2;T:=2;
 --elsif PD=x"A013" then --D- 32 BIT SUBTRAKTION
    --SUMME:=(A&B)-(C&D);
    --C:=SUMME(31 downto 16);
    --D:=SUMME(15 downto 0);
    --T:=2;
    --SP:=SP-2;
 --elsif PD=x"A014" then -- DIVISION_MIT_REST 32B/16B=16R/16Q
    --B:=B(14 downto 0)&C(15);
    --C:=C(14 downto 0)&'0';
    --if B>=D then

   --B:=B-D;
      --C(0):='1';
      --end if;
    --T:=3;
 --elsif PD=x"A016" then -- TOGGLE
      --STORE:=not EXFET;STOREADRESSE:=D;
      --WSTORE:='1' ;
      --T:=0;
 --elsif PD=x"A015" then -- CRC32 modifiziert
    --CRC_SUMME:="00000000"&A(7 downto 0)&B(7 downto 0)&C(7 downto 0)&D(7 downto 0);
    --if D(0)/=D(8) then
      --CRC_SUMME:=CRC_SUMME xor "0000000111011011011100010000011001000001";
          -- -- --            -------111011011011100010000011001000001
          -- --- --- --- G(x) = x32x26x23x22x16x12x11x10x8x7x5x4x2x1x0
      --end if;
    --D:="0"&D(15 downto 9)&CRC_SUMME(8 downto 1);
    --C:="00000000"&CRC_SUMME(16 downto 9);
    --B:="00000000"&CRC_SUMME(24 downto 17);
    --A:="00000000"&CRC_SUMME(32 downto 25);
    --T:=4;

    --elsif PD=x"A01B" then -- MCR
      --case R(P(SP-1)) is
        --when "----------101000"--noch auf if ummachen wenn benoetigt
        --| "----------111010"
        --| "----------010111"
        --| "----------000101"
        --| "--------01101111"
        --| "--------11110110"
        --| "--------10010000"
        --| "--------00001001" => R(P(SP-1)):=x"FFFF";
        --when others => R(P(SP-1)):=x"0000";
        --end case;
      --W(P(SP-1)):='1';

-- else 
--    STAK:=x"0000";
--    if PD(3)='1' then STAK:=STAK or (SX and SY); end if;
--    if PD(2)='1' then STAK:=STAK or (not SX and SY); end if;
--    if PD(1)='1' then STAK:=STAK or (SX and not SY); end if;
--    if PD(0)='1' then STAK:=STAK or (not SX and not SY); end if;
--    T(J(-2)):=STAK;
--    W(J(-2)):='1';
--    RSPBYTE:=-1;
-----------
    else
      D:=PD; 
      T:=1;
      SP:=SP+1;
    end if;
  if T>0 then R(P(SP-1)):=D;W(P(SP-1)):='1'; end if;
  if T>1 then R(P(SP-2)):=C;W(P(SP-2)):='1'; end if;
  if T>2 then R(P(SP-3)):=B;W(P(SP-3)):='1'; end if;
  if T>3 then R(P(SP-4)):=A;W(P(SP-4)):='1'; end if;
  PC_ZUM_RAM<=PC;
  SP_ZUM_RAM<=CONV_STD_LOGIC_VECTOR(SP,16);
  ADRESSE_ZUM_STAPEL(0)<=CONV_STD_LOGIC_VECTOR(SP-1,16) and x"FFFD";
  ADRESSE_ZUM_STAPEL(1)<=CONV_STD_LOGIC_VECTOR(SP-2,16) and x"FFFD";
  ADRESSE_ZUM_STAPEL(2)<=CONV_STD_LOGIC_VECTOR(SP-3,16) or x"0002";
  ADRESSE_ZUM_STAPEL(3)<=CONV_STD_LOGIC_VECTOR(SP-4,16) or x"0002";
  --ADRESSE_ZUM_STAPEL(0)<=CONV_UNSIGNED(SP-1,16) and x"FFFD";
  --ADRESSE_ZUM_STAPEL(1)<=CONV_UNSIGNED(SP-2,16) and x"FFFD";
  --ADRESSE_ZUM_STAPEL(2)<=CONV_UNSIGNED(SP-3,16) or x"0002";
  --ADRESSE_ZUM_STAPEL(3)<=CONV_UNSIGNED(SP-4,16) or x"0002";
  STORE_ZUM_STAPEL(0)<=R(0);
  STORE_ZUM_STAPEL(1)<=R(1);
  STORE_ZUM_STAPEL(2)<=R(2);
  STORE_ZUM_STAPEL(3)<=R(3);
  WE_ZUM_STAPEL<=W;
  RP_ZUM_RAM<=RP;
  RPC_ZUM_RAM<=RPC;
  RW_ZUM_RAM<=RW;
  SCHREIBBIT1_ZUR_AUSGABE<=SCHREIBBIT1;
  HIN_ZUR_AUSGABE<=EMIT(7 downto 0);
  if WSTORE='0' then ADRESSE_ZUM_RAM<=R(P(SP-1));
    else ADRESSE_ZUM_RAM<=STOREADRESSE; end if;
  STORE_ZUM_RAM<=STORE;
  WSTORE_ZUM_RAM<=WSTORE;
  end process;

--ab 2014:
--TxD<=RxD;
process 
variable xcount1: STD_LOGIC_VECTOR (15 downto 0);
variable xcount2: STD_LOGIC_VECTOR (3 downto 0);
variable OutBit: STD_LOGIC_VECTOR (18 downto 9):="1111111111";
variable XOFFOutput: STD_LOGIC;
begin wait until (CLK6_I'event and CLK6_I='1');
  if xcount1<x"01C8" then xcount1:=xcount1+08; else --D9+D9=1B2
    -- ganz neu 01B2 bei 50.000 MHz 115200, 1458H bei 9600, 14585H bei 600
    -- ganz neu 01CE/01B0-01D8/01C8 bei 53.200 MHz 115200,  .. bei 9600, .. bei 600
    xcount1:=x"0000";
    if xcount2<x"A" then 
      TxD<=OutBit(9);
      OutBit:='0'&OutBit(18 downto 10);
      xcount2:=xcount2+1;
      elsif xcount2=x"A" then
        TxD<='1'; --Stop-Bit
        if P19SCHREIBBIT1/=SCHREIBBIT2_X then
          OutBit:="1"&dbOutput&'0';
          SCHREIBBIT2_X<=P19SCHREIBBIT1;
          else OutBit:="1111111111"; 
            end if;
        xcount2:=xcount2+1;
        else xcount2:=x"0";
        end if;
    end if;
  end process;

process
begin wait until (CLK6_I'event and CLK6_I='0');
  dbOutput<=HIN_ZUR_AUSGABE;
  P19SCHREIBBIT1<=SCHREIBBIT1_ZUR_AUSGABE;
  end process;




XOFFBit<='0';

process 
variable scount: STD_LOGIC_VECTOR (31 downto 0):=x"00000000";
variable dbInput_L: STD_LOGIC_VECTOR (7 downto 0);
variable stoppbit: STD_LOGIC;
begin wait until (CLK6_I'event and CLK6_I='1');
  if (RxDI='0' and scount=x"00000000") then scount:=x"00000008"; else
    if scount=x"00001100" then scount:=x"00000000";
--                 D0000 bei 600
--                  1100 bei 115200 und 50 MHz
--                  120C bei 115200 und 53.2 MHz
--      if stoppbit='1' then
          dbInput<=dbInput_L;
--          STRG<=not STRG_MERK_RUHEND;
--        end if;		  
      else 
        if scount>0 then scount:=scount+08; -- D0000, D000 statt 1100
          end if; end if; end if;
-- 115200:
  --if scount(11 downto 4)=x"28" then dbInput_L(0):=RxDI;
  --elsif scount(11 downto 4)=x"43" then dbInput_L(1):=RxDI;
  --elsif scount(11 downto 4)=x"5E" then dbInput_L(2):=RxDI;
  --elsif scount(11 downto 4)=x"7A" then dbInput_L(3):=RxDI;
  --elsif scount(11 downto 4)=x"95" then dbInput_L(4):=RxDI;
  --elsif scount(11 downto 4)=x"B0" then dbInput_L(5):=RxDI;
  --elsif scount(11 downto 4)=x"CB" then dbInput_L(6):=RxDI;
  --elsif scount(11 downto 4)=x"E6" then dbInput_L(7):=RxDI;
-- 115200 und 53.200 MHz:
  if scount(11 downto 4)=x"2B" then dbInput_L(0):=RxDI;
  elsif scount(11 downto 4)=x"48" then dbInput_L(1):=RxDI;
  elsif scount(11 downto 4)=x"65" then dbInput_L(2):=RxDI;
  elsif scount(11 downto 4)=x"81" then dbInput_L(3):=RxDI;
  elsif scount(11 downto 4)=x"9E" then dbInput_L(4):=RxDI;
  elsif scount(11 downto 4)=x"BB" then dbInput_L(5):=RxDI;
  elsif scount(11 downto 4)=x"D8" then dbInput_L(6):=RxDI;
  elsif scount(11 downto 4)=x"F5" then dbInput_L(7):=RxDI;
-- 115200 und 53.200 MHz:
  --if scount(11 downto 8)=x"2" then dbInput_L(0):=RxDI;
  --elsif scount(11 downto 8)=x"4" then dbInput_L(1):=RxDI;
  --elsif scount(11 downto 8)=x"6" then dbInput_L(2):=RxDI;
  --elsif scount(11 downto 8)=x"7" then dbInput_L(3):=RxDI;
  --elsif scount(11 downto 8)=x"9" then dbInput_L(4):=RxDI;
  --elsif scount(11 downto 8)=x"B" then dbInput_L(5):=RxDI;
  --elsif scount(11 downto 8)=x"D" then dbInput_L(6):=RxDI;
  --elsif scount(11 downto 8)=x"E" then dbInput_L(7):=RxDI;
  --elsif scount(11 downto 8)=x"0" then stoppbit:=RxDI;
    end if; 
  end process;

process
begin wait until (CLK6_I'event and CLK6_I='0');
  STRG_MERK_RUHEND<=STRG_MERK;
  RXDI<=RXD;
  end process;


--with PC_ZUM_RAM select 
--  PDNT<=PD_VOM_RAM(2) when "000-------------",
--        PD_VOM_RAM(3) when "00100-----------",
--        DAT_I when others;
PDNT<=PD_VOM_RAM(2);

--with ADRESSE_ZUM_RAM select 
--  EXFET<=FETCH_VOM_RAM(2) when "000-------------",--0000-1FFF
--         FETCH_VOM_RAM(3) when "00100-----------",--2000-27FF
--         FETCH_VOM_RAM(7) when "001011----------",--2C00-2FFF
--         x"00"&FETCH_VOM_RAM(13)(7 downto 0) when "111-------------",--E000-FFFF
----         ZUM_FORTH when "1101000---------",--D000/D1FF
--         DAT_I when others;
EXFET<=FETCH_VOM_RAM(2) when ADRESSE_ZUM_RAM(15 downto 13)="000" else
--       FETCH_VOM_RAM(3) when ADRESSE_ZUM_RAM(15 downto 11)="00100" else
       FETCH_VOM_RAM(7) when ADRESSE_ZUM_RAM(15 downto 10)="001011" else
       x"00"&FETCH_VOM_RAM(13)(7 downto 0) when ADRESSE_ZUM_RAM(15 downto 13)="111" else
       DAT_I;

--WE_ZUM_RAM(02)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM="000-------------" else '0';
--WE_ZUM_RAM(03)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM="00100-----------" else '0';
--WE_ZUM_RAM(07)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM="001011----------" else '0';
--WE_ZUM_RAM(13)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM="111-------------" else '0';

WE_ZUM_RAM(02)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM(15 downto 13)="000" else '0';
WE_ZUM_RAM(03)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM(15 downto 11)="00100" else '0';
WE_ZUM_RAM(07)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM(15 downto 10)="001011" else '0';
WE_ZUM_RAM(13)<=WSTORE_ZUM_RAM when ADRESSE_ZUM_RAM(15 downto 13)="111" else '0';


--process 
--begin wait until (CLK_I'event and CLK_I='0');
--  if WE_ZUM_RAM(2)='1' then 
--    ram0000bis1FFF(CONV_INTEGER(ADRESSE_ZUM_RAM(12 downto 0)))<=STORE_ZUM_RAM; 
--    FETCH_VOM_RAM(2)<=STORE_ZUM_RAM; 
--	 else
--      FETCH_VOM_RAM(2)<=ram0000bis1FFF(CONV_INTEGER(ADRESSE_ZUM_RAM(12 downto 0)));
--      end if;
--  PD_VOM_RAM(2)<=ram0000bis1FFF(CONV_INTEGER(PC_ZUM_RAM(12 downto 0)));
--  end process;


-- parameterized module component instance
R0000B1FFF : ram0000bis1FFF
    port map (
	  DataInA(15 downto 0)=>STORE_ZUM_RAM, 
      AddressA(12 downto 0)=>ADRESSE_ZUM_RAM(12 downto 0), 
	  ClockA=>not CLK_I, 
	  ClockEnA=>'1', 
	  WrA=>WE_ZUM_RAM(2),
	  ResetA=>'0', 
	  QA(15 downto 0)=>FETCH_VOM_RAM(2), 

      DataInB(15 downto 0)=>x"0000", 
	  AddressB(12 downto 0)=>PC_ZUM_RAM(12 downto 0), 
      ClockB=>not CLK_I, 
	  ClockEnB=>'1', 
	  WrB=>'0', 
      ResetB=>'0', 
	  QB(15 downto 0)=>PD_VOM_RAM(2)
	  );


--process 
--begin wait until (CLK_I'event and CLK_I='0');
  --if WE_ZUM_RAM(3)='1' then 
    --ram2000bis27FF(CONV_INTEGER(ADRESSE_ZUM_RAM(10 downto 0)))<=STORE_ZUM_RAM; 
    --FETCH_VOM_RAM(3)<=STORE_ZUM_RAM; 
	 --else
      --FETCH_VOM_RAM(3)<=ram2000bis27FF(CONV_INTEGER(ADRESSE_ZUM_RAM(10 downto 0)));
      --end if;
  --PD_VOM_RAM(3)<=ram2000bis27FF(CONV_INTEGER(PC_ZUM_RAM(10 downto 0)));
  --end process;

--process 
--begin wait until (CLK_I'event and CLK_I='0');
--  if WE_ZUM_RAM(13)='1' then 
--    ramE000bisFFFF(CONV_INTEGER(ADRESSE_ZUM_RAM(12 downto 0)))<=STORE_ZUM_RAM(7 downto 0); 
--    FETCH_VOM_RAM(13)<=STORE_ZUM_RAM; 
--	 else
--      FETCH_VOM_RAM(13)<=x"00"&ramE000bisFFFF(CONV_INTEGER(ADRESSE_ZUM_RAM(12 downto 0)));
--      end if;
--  end process;

-- parameterized module component instance
RE000BFFFF : ramE000bisFFFF
    port map (
	  Clock=>not CLK_I, 
	  ClockEn=>'1', 
	  Reset=>'0', 
	  WE=>WE_ZUM_RAM(13), 
	  Address(12 downto 0)=>ADRESSE_ZUM_RAM(12 downto 0), 
      Data(7 downto 0)=>STORE_ZUM_RAM(7 downto 0),
	  Q(7 downto 0)=>FETCH_VOM_RAM(13)(7 downto 0));

--process 
--begin wait until (CLK_I'event and CLK_I='0');
--  if WE_ZUM_RAM(7)='1' then 
--    ram2C00bis2FFF(CONV_INTEGER(ADRESSE_ZUM_RAM(9 downto 0))):=STORE_ZUM_RAM; 
--    end if;
--  FETCH_VOM_RAM(7)<=ram2C00bis2FFF(CONV_INTEGER(ADRESSE_ZUM_RAM(9 downto 0)));
--  end process;
--process 
--begin wait until (CLK_I'event and CLK_I='0');
--  if RW_ZUM_RAM='1' then 
--    ram2C00bis2FFF(CONV_INTEGER(RP_ZUM_RAM(9 downto 0))):=RPC_ZUM_RAM; 
--    end if;
--  RPCC_VOM_RAM<=ram2C00bis2FFF(CONV_INTEGER(RP_ZUM_RAM(9 downto 0)));
--  end process;

-- parameterized module component instance
R2C00B2FFF : ram2C00bis2FFF
    port map (
	  DataInA(15 downto 0)=>STORE_ZUM_RAM, 
      AddressA(9 downto 0)=>ADRESSE_ZUM_RAM(9 downto 0), 
	  ClockA=>not CLK_I, 
	  ClockEnA=>'1', 
	  WrA=>WE_ZUM_RAM(7),
	  ResetA=>'0', 
	  QA(15 downto 0)=>FETCH_VOM_RAM(7), 

      DataInB(15 downto 0)=>RPC_ZUM_RAM, 
	  AddressB(9 downto 0)=>RP_ZUM_RAM(9 downto 0), 
      ClockB=>not CLK_I, 
	  ClockEnB=>'1', 
	  WrB=>RW_ZUM_RAM, 
      ResetB=>'0', 
	  QB(15 downto 0)=>RPCC_VOM_RAM
	  );



--Stapel: 
process 
begin wait until (CLK_I'event and CLK_I='0');
  if WE_ZUM_STAPEL(1)='1' then 
    stap1(CONV_INTEGER(ADRESSE_ZUM_STAPEL(1)(11 downto 2)))<=STORE_ZUM_STAPEL(1); 
    HOLE_VOM_STAPEL(1)<=STORE_ZUM_STAPEL(1); 
	 else
      HOLE_VOM_STAPEL(1)<=stap1(CONV_INTEGER(ADRESSE_ZUM_STAPEL(1)(11 downto 2)));
    end if;
  end process;
process 
begin wait until (CLK_I'event and CLK_I='0');
  if WE_ZUM_STAPEL(2)='1' then 
    stap2(CONV_INTEGER(ADRESSE_ZUM_STAPEL(2)(11 downto 2)))<=STORE_ZUM_STAPEL(2); 
    HOLE_VOM_STAPEL(2)<=STORE_ZUM_STAPEL(2); 
	 else
      HOLE_VOM_STAPEL(2)<=stap2(CONV_INTEGER(ADRESSE_ZUM_STAPEL(2)(11 downto 2)));
      end if;
  end process;
process 
begin wait until (CLK_I'event and CLK_I='0');
  if WE_ZUM_STAPEL(3)='1' then 
    stap3(CONV_INTEGER(ADRESSE_ZUM_STAPEL(3)(11 downto 2)))<=STORE_ZUM_STAPEL(3); 
    HOLE_VOM_STAPEL(3)<=STORE_ZUM_STAPEL(3); 
	 else
      HOLE_VOM_STAPEL(3)<=stap3(CONV_INTEGER(ADRESSE_ZUM_STAPEL(3)(11 downto 2)));
      end if;
  end process;
process 
begin wait until (CLK_I'event and CLK_I='0');
  if WE_ZUM_STAPEL(0)='1' then 
    stap0(CONV_INTEGER(ADRESSE_ZUM_STAPEL(0)(11 downto 2)))<=STORE_ZUM_STAPEL(0); 
    HOLE_VOM_STAPEL(0)<=STORE_ZUM_STAPEL(0); 
	 else
      HOLE_VOM_STAPEL(0)<=stap0(CONV_INTEGER(ADRESSE_ZUM_STAPEL(0)(11 downto 2)));
      end if;
  end process;


CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
end CR4000;
