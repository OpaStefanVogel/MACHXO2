library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
library machxo2;
use machxo2.all;

entity Platine17 is
  Port (
    SPI_CLK: in STD_LOGIC;
    SPI_MOSI: in STD_LOGIC;
    SPI_MISO: inout STD_LOGIC;--inout
    SPI_SCSN: in STD_LOGIC;
    INT_XY: inout STD_LOGIC;

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

end Platine17;

architecture Hufel of Platine17 is

component UFM
    port (wb_clk_i: in  std_logic; wb_rst_i: in  std_logic; 
        wb_cyc_i: in  std_logic; wb_stb_i: in  std_logic; 
        wb_we_i: in  std_logic; 
        wb_adr_i: in  std_logic_vector(7 downto 0); 
        wb_dat_i: in  std_logic_vector(7 downto 0); 
        wb_dat_o: out  std_logic_vector(7 downto 0); 
        wb_ack_o: out  std_logic; wbc_ufm_irq: out  std_logic);
end component;

signal wb_adr_i,wb_dat_i,wb_dat_o,WB_I: STD_LOGIC_VECTOR (7 downto 0);
signal wb_clk_i,wb_rst_i,wb_cyc_i,wb_stb_i,wb_we_i,wb_ack_o: STD_LOGIC;
signal SPI_COUNTER,EMITBYTE: STD_LOGIC_VECTOR (15 downto 0);
signal SPI_BYTE_KOMPLETT,SPI_MISO_SENDEBYTE: STD_LOGIC_VECTOR (7 downto 0);
signal SPI_MISO_SENDEBIT: STD_LOGIC;
begin

--process begin wait until (CLK_I'event and CLK_I='0');
  --if WE_I='1' and ADR_I=x"2C30" then wb_clk_i<=DAT_I(0); end if;
  --if WE_I='1' and ADR_I=x"2D30" then WB_I(3 downto 0)<=DAT_I(3 downto 0); end if;
  --if WE_I='1' and ADR_I=x"2D31" then wb_adr_i<=DAT_I(7 downto 0); end if;
  --if WE_I='1' and ADR_I=x"2D32" then wb_dat_i<=DAT_I(7 downto 0); end if;
  --end process;
--process begin wait until (CLK_I'event and CLK_I='0');
  --if WE_I='1' and ADR_I=x"2D30" then WB_I(3 downto 0)<=DAT_I(3 downto 0); end if;
  --if WE_I='1' and ADR_I=x"2D31" then wb_adr_i<=DAT_I(7 downto 0); end if;
  --if WE_I='1' and ADR_I=x"2D32" then wb_dat_i<=DAT_I(7 downto 0); end if;
  
  --if WE_I='1' and ADR_I(15 downto 2)=x"2D7"&"00" then
    --wb_clk_i<='1';
    --WB_I(3 downto 0)<=DAT_I(11 downto 8);
    --wb_rst_i<=DAT_I(11);
    --wb_cyc_i<=DAT_I(10);
    --wb_stb_i<=DAT_I(9);
    --wb_we_i<=DAT_I(8);
    --wb_adr_i<=ADR_I(7 downto 0);
    --wb_dat_i<=DAT_I(7 downto 0);
    --else wb_clk_i<='0';
      --end if;
  
  --if WE_I='1' and ADR_I(15 downto 2)=x"2D6"&"00" then
    --wb_clk_i<='1';
    --wb_rst_i<='0';
    --wb_cyc_i<=ADR_I(1);
    --wb_stb_i<=ADR_I(1);
    --wb_we_i<=ADR_I(0);
    --wb_adr_i<=DAT_I(15 downto 8);
    --wb_dat_i<=DAT_I(7 downto 0);
    --else wb_clk_i<='0';
      --end if;
--  end process;

process begin wait until (CLK_I'event and CLK_I='0');  
--if WE_I='1' and ADR_I(15 downto 2)=x"2D7"&"00" then
  if WE_I='1' and ADR_I=x"2D60" then
    wb_clk_i<='1';
    else wb_clk_i<='0';
      end if;
  end process;

process begin wait until (CLK_I'event and CLK_I='1');
  if wb_clk_i='1' then
    --wb_rst_i<=DAT_I(11);
    --wb_cyc_i<=DAT_I(10);
    --wb_stb_i<=DAT_I(9);
    --wb_we_i<=DAT_I(8);
    --wb_adr_i<=ADR_I(7 downto 0);
    --wb_dat_i<=DAT_I(7 downto 0);
    wb_rst_i<='0';
    if DAT_I(7 downto 0)=x"7F" then
      wb_cyc_i<='0';
      wb_stb_i<='0';
      else
        wb_cyc_i<='1';
        wb_stb_i<='1';
        end if;
    wb_we_i<=DAT_I(7);
    wb_adr_i<='0'&DAT_I(6 downto 0);
    wb_dat_i<=DAT_I(15 downto 8);
    end if;
  end process;

--wb_rst_i<=WB_I(3);
--wb_cyc_i<=WB_I(2);
--wb_stb_i<=WB_I(1);
--wb_we_i<=WB_I(0);

-- parameterized module component instance
Platine_UFM : UFM
  port map (
    wb_clk_i=>wb_clk_i, 
    wb_rst_i=>wb_rst_i, 
    wb_cyc_i=>wb_cyc_i, 
    wb_stb_i=>wb_stb_i, 
    wb_we_i=>wb_we_i, 
    wb_adr_i(7 downto 0)=>wb_adr_i, 
    wb_dat_i(7 downto 0)=>wb_dat_i, 
    wb_dat_o(7 downto 0)=>wb_dat_o, 
    wb_ack_o=>wb_ack_o, 
    wbc_ufm_irq=>open);



process begin wait until (CLK_I'event and CLK_I='0');
  if WE_I='1' and ADR_I=x"2D05" then EMITBYTE<=DAT_I; end if;
  end process;

process 
variable SPI_COUNT: STD_LOGIC_VECTOR (15 downto 0):=x"0000"; 
variable SPI_BYTE: STD_LOGIC_VECTOR (7 downto 0):=x"00";
begin wait until (SPI_CLK'event and SPI_CLK='1');  
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
  DAT_O<=(not wb_ack_o)&"0000000"&wb_dat_o         when x"D030",
         SPI_MISO&SPI_CLK&SPI_MOSI&SPI_SCSN&"000"&SPI_MISO_SENDEBIT&SPI_BYTE_KOMPLETT when x"D031",
         SPI_COUNTER                               when x"D032",
         DAT_I when others;

CLK50_O<=CLK50_I;
CLK6_O<=CLK6_I;
CLK_O<=CLK_I;
ADR_O<=ADR_I;
WE_O<=WE_I;
end Hufel;
