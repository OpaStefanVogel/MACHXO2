library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine01 is
  Port ( --hierzu Platine40.ucf--
-- ==== RS-232 Serial Ports  (RS232) ====
    RS232_RXD: in  STD_LOGIC;
    RS232_TXD: out STD_LOGIC;
--===LED'S
    LED: inout STD_LOGIC_VECTOR (7 downto 0);
--====WIZ
    WIZ_nSS: out STD_LOGIC;
    WIZ_nINT: in STD_LOGIC;

    WIZ_PWDN: out STD_LOGIC;
    WIZ_nRESET: out STD_LOGIC;
    WIZ_MISO: in STD_LOGIC;
    WIZ_MOSI: out STD_LOGIC;
    WIZ_SCLK: out STD_LOGIC; -- Clock
--===SPI
    SPI_CLK: in STD_LOGIC;
    SPI_MOSI: in STD_LOGIC;
    SPI_MISO: inout STD_LOGIC;--inout
    SPI_SCSN: in STD_LOGIC;
--===USER IO
    OUTPUT: inout STD_LOGIC_VECTOR (23 downto 0);
    INPUT: in STD_LOGIC_VECTOR (31 downto 0);
--===PID-Regler
    POS_A: in STD_LOGIC;
    POS_B: in STD_LOGIC;
    INDEX: in STD_LOGIC;
    PWM1L: inout STD_LOGIC;
    PWM1H: inout STD_LOGIC;
    PWM2L: inout STD_LOGIC;
    PWM2H: inout STD_LOGIC;
    PWM3L: inout STD_LOGIC;
    PWM3H: inout STD_LOGIC
);
end Platine01;

architecture Striezel of Platine01 is
--signal WIZ_nSS, WIZ_nINT, WIZ_PWDN, WIZ_nRESET, WIZ_MISO, WIZ_MOSI, WIZ_SCLK: STD_LOGIC; -- Clock

component FortyForthProzessor is
  Port (
    RxD: in  STD_LOGIC:='1';  -- serieller Eingang: 115200/odd/8/1/Xon/Xoff
    TxD: out STD_LOGIC:='1';  -- serieller Ausgang: ebenso
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
    WE_O: out STD_LOGIC
    );
end component;
for all : FortyForthProzessor use entity work.Platine20(CR4000);

component CLK_Prozessor is
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
end component;
for all : CLK_Prozessor use entity work.Platine10(Brezel);

component LED_Prozessor is
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
end component;
for all : LED_Prozessor use entity work.Platine11(Lichtel);

component WIZ_Prozessor is
  Port (
    WIZ_nSS: out STD_LOGIC:='1';
    WIZ_nINT: in STD_LOGIC:='1';
    WIZ_PWDN: out STD_LOGIC;
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
end component;
for all : WIZ_Prozessor use entity work.Platine13(Witzel);

component SPI_Prozessor is
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
end component;
--for all : SPI_Prozessor use entity work.Platine14(Schnurzel);
for all : SPI_Prozessor use entity work.Platine15(Schturzel);

component HIN_HER_Prozessor is
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
end component;
for all : HIN_HER_Prozessor use entity work.Platine16(Wurzel);

component UFM_Prozessor is
  Port (
    SPI_CLK: in STD_LOGIC;
    SPI_MOSI: in STD_LOGIC;
    SPI_MISO: inout STD_LOGIC; --inout
    SPI_SCSN: in STD_LOGIC;
    INT_XY: out STD_LOGIC;
    
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
end component;
for all : UFM_Prozessor use entity work.Platine17(Hufel);

component SPIS_Prozessor is
  Port (
    SPI_CLK: in STD_LOGIC;
    SPI_MOSI: in STD_LOGIC;
    SPI_MISO: inout STD_LOGIC; --inout
    SPI_SCSN: in STD_LOGIC;
    INT_XY: out STD_LOGIC;
    
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
end component;
for all : SPIS_Prozessor use entity work.Platine18(Kufel);

component PID_Prozessor is
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
  end component;
for all : PID_Prozessor use entity work.Platine31(Purzel);

signal NLED: STD_LOGIC_VECTOR (7 downto 0);
signal ADR_I,DAT_O,DAT_I: STD_LOGIC_VECTOR (15 downto 0);
signal CLK6_I,CLK_II,CLK_I,WE_I,CLK_50: STD_LOGIC;
signal DAT_ZU_FF,DAT_ZU_CLK,DAT_ZU_LED: STD_LOGIC_VECTOR (15 downto 0);
signal DAT_ZU_WIZ,DAT_ZU_SPI,DAT_ZU_UFM,DAT_ZU_SPIS,DAT_ZU_PID: STD_LOGIC_VECTOR (15 downto 0);
signal DAT_ZU_FEHLERSUCH,DAT_ZU_HIN_HER,VOM_FORTH_HERI: STD_LOGIC_VECTOR (15 downto 0);

signal TAKTZAEHLER: STD_LOGIC_VECTOR (47 downto 0);

--PID_Prozessor
signal IO,IO_N: STD_LOGIC_VECTOR (34 downto 1);
signal IO_EXTRA: STD_LOGIC_VECTOR (40 downto 35);
signal INTXY,UFM_INT_XY,NULLI: STD_LOGIC;

begin
--RS232_TXD<=RS232_RXD;
Fassung_P: FortyForthProzessor
  port map (
    RxD=>RS232_RXD,
    TxD=>RS232_TXD,
    INTXY=>UFM_INT_XY,--RS232_RXD,--INTXY,

    CLK50_I=>CLK_50,
    CLK50_O=>open,
    CLK6_I=>CLK6_I,
    CLK6_O=>open,
    
    CLK_I=>CLK_I,
    ADR_I=>x"0000",
    DAT_I=>DAT_ZU_FF,
    WE_I=>'0',

    CLK_O=>open,
    ADR_O=>ADR_I,
    DAT_O=>DAT_ZU_CLK,
    WE_O=>WE_I
    );

Fassung_CLK: CLK_Prozessor
  port map (
    TAKTZAEHLER=>TAKTZAEHLER,
    CLK50_O=>CLK_50,
    CLK6_O=>CLK6_I,

    CLK_I=>CLK_I,
    ADR_I=>ADR_I,
    DAT_I=>DAT_ZU_CLK,
    WE_I=>WE_I,

    CLK_O=>CLK_I,
    ADR_O=>open,
    DAT_O=>DAT_ZU_LED,
    WE_O=>open
    );

Fassung_LED: LED_Prozessor
  port map (
    LED=>NLED,
    TAKTZAEHLER=>TAKTZAEHLER,

    CLK50_I=>CLK_50,--'0',--
    CLK50_O=>open,
    CLK6_I=>CLK6_I,
    CLK6_O=>open,
    
    CLK_I=>CLK_I,
    ADR_I=>ADR_I,
    DAT_I=>DAT_ZU_LED,
    WE_I=>WE_I,

    CLK_O=>open,
    ADR_O=>open,
    DAT_O=>DAT_ZU_FF,--DAT_ZU_WIZ,
    WE_O=>open
    );

--Fassung_WIZ: WIZ_Prozessor
  --port map (
    --WIZ_nSS=>WIZ_nSS,
    --WIZ_nINT=>WIZ_nINT,
    --WIZ_PWDN=>WIZ_PWDN,
    --WIZ_nRESET=>WIZ_nRESET,

    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_WIZ,
    --WE_I=>WE_I,

    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_SPI,
    --WE_O=>open
    --);

--Fassung_SPI: SPI_Prozessor
  --port map (
    --SPI_MISO=>WIZ_MISO,
    --SPI_MOSI=>WIZ_MOSI,
    --SPI_SCK=>WIZ_SCLK,

    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_SPI,
    --WE_I=>WE_I,

    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_FF,--DAT_ZU_HIN_HER,
    --WE_O=>open
    --);

--Fassung_HIN_HER: HIN_HER_Prozessor
  --port map (
    --OUTPUT=>OUTPUT,
    --INPUT=>INPUT,

    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_HIN_HER,
    --WE_I=>WE_I,

    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_UFM,
    --WE_O=>open
    --);

--Fassung_UFM: UFM_Prozessor
  --port map (
    --SPI_CLK=>SPI_CLK,
    --SPI_MOSI=>'0',--SPI_MOSI,
    --SPI_MISO=>NULLI,--SPI_MISO,
    --SPI_SCSN=>'1',--SPI_SCSN,
    --INT_XY=>open,--UFM_INT_XY,
    
    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_UFM,
    --WE_I=>WE_I,
    
    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_SPIS,
    --WE_O=>open
    --);

--Fassung_SPIS: SPIS_Prozessor
  --port map (
    --SPI_CLK=>SPI_CLK,
    --SPI_MOSI=>SPI_MOSI,
    --SPI_MISO=>SPI_MISO,
    --SPI_SCSN=>SPI_SCSN,
    --INT_XY=>UFM_INT_XY,
    
    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_SPIS,
    --WE_I=>WE_I,
    
    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_PID,
    --WE_O=>open
    --);

--Fassung_PID: PID_Prozessor
  --port map (
    --IO=>IO_N,
    --IO_EXTRA=>IO_EXTRA,
    --INTXY=>INTXY,
    
    --CLK50_I=>CLK_50,
    --CLK50_O=>open,
    --CLK6_I=>CLK6_I,
    --CLK6_O=>open,
    
    --CLK_I=>CLK_I,
    --ADR_I=>ADR_I,
    --DAT_I=>DAT_ZU_PID,
    --WE_I=>WE_I,
    
    --CLK_O=>open,
    --ADR_O=>open,
    --DAT_O=>DAT_ZU_FF,--open,--
    --WE_O=>open
    --);

PWM1H<=IO_N(21);
PWM1L<=IO_N(22);
PWM2H<=IO_N(23);
PWM2L<=IO_N(24);
PWM3H<=IO_N(25);
PWM3L<=IO_N(26);
 IO<=IO_N;
--IO<=IO_N WHEN NOTAUS='0' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

--IO(34)<=INDEX;
IO_EXTRA(36)<=POS_A;
IO_EXTRA(38)<=POS_B;

--IO_N(13); --LED0
--IO_N(14);
--IO_N(15);
--IO_N(16);--E_RX_DV;
--IO_N(17);
--IO_N(18);
--IO_N(19);
--IO_N(20); --POS_A und B auf LED7

--LED<=not(IO(20 downto 13));
LED(6 downto 0)<=not NLED(6 downto 0);
LED(7)<=SPI_SCSN;
--SPI_MISO<=NLED(7);
end Striezel;