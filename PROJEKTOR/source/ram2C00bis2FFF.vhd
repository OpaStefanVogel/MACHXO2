-- VHDL netlist generated by SCUBA Diamond_2.2_Production (99)
-- Module  Version: 7.2
--/usr/local/diamond/2.2_x64/ispfpga/bin/lin64/scuba -w -n ram2C00bis2FFF -lang vhdl -synth synplify -bus_exp 7 -bb -arch xo2c00 -type bram -wp 11 -rp 1010 -data_width 16 -rdata_width 16 -num_rows 1024 -cascade -1 -memfile /home/stefan/MACHXO2/AB_86/source/RAM_2C00_2FFF.mem -memformat hex -writemodeA READBEFOREWRITE -writemodeB READBEFOREWRITE -e 

-- Fri Feb 28 14:25:06 2014

library IEEE;
use IEEE.std_logic_1164.all;
-- synopsys translate_off
library MACHXO2;
use MACHXO2.components.all;
-- synopsys translate_on

entity ram2C00bis2FFF is
    port (
        DataInA: in  std_logic_vector(15 downto 0); 
        DataInB: in  std_logic_vector(15 downto 0); 
        AddressA: in  std_logic_vector(9 downto 0); 
        AddressB: in  std_logic_vector(9 downto 0); 
        ClockA: in  std_logic; 
        ClockB: in  std_logic; 
        ClockEnA: in  std_logic; 
        ClockEnB: in  std_logic; 
        WrA: in  std_logic; 
        WrB: in  std_logic; 
        ResetA: in  std_logic; 
        ResetB: in  std_logic; 
        QA: out  std_logic_vector(15 downto 0); 
        QB: out  std_logic_vector(15 downto 0));
end ram2C00bis2FFF;

architecture Structure of ram2C00bis2FFF is

    -- internal signal declarations
    signal scuba_vhi: std_logic;
    signal scuba_vlo: std_logic;

    -- local component declarations
    component VHI
        port (Z: out  std_logic);
    end component;
    component VLO
        port (Z: out  std_logic);
    end component;
    component DP8KC
        generic (INIT_DATA : in String; INITVAL_1F : in String; 
                INITVAL_1E : in String; INITVAL_1D : in String; 
                INITVAL_1C : in String; INITVAL_1B : in String; 
                INITVAL_1A : in String; INITVAL_19 : in String; 
                INITVAL_18 : in String; INITVAL_17 : in String; 
                INITVAL_16 : in String; INITVAL_15 : in String; 
                INITVAL_14 : in String; INITVAL_13 : in String; 
                INITVAL_12 : in String; INITVAL_11 : in String; 
                INITVAL_10 : in String; INITVAL_0F : in String; 
                INITVAL_0E : in String; INITVAL_0D : in String; 
                INITVAL_0C : in String; INITVAL_0B : in String; 
                INITVAL_0A : in String; INITVAL_09 : in String; 
                INITVAL_08 : in String; INITVAL_07 : in String; 
                INITVAL_06 : in String; INITVAL_05 : in String; 
                INITVAL_04 : in String; INITVAL_03 : in String; 
                INITVAL_02 : in String; INITVAL_01 : in String; 
                INITVAL_00 : in String; ASYNC_RESET_RELEASE : in String; 
                RESETMODE : in String; GSR : in String; 
                WRITEMODE_B : in String; WRITEMODE_A : in String; 
                CSDECODE_B : in String; CSDECODE_A : in String; 
                REGMODE_B : in String; REGMODE_A : in String; 
                DATA_WIDTH_B : in Integer; DATA_WIDTH_A : in Integer);
        port (DIA8: in  std_logic; DIA7: in  std_logic; 
            DIA6: in  std_logic; DIA5: in  std_logic; 
            DIA4: in  std_logic; DIA3: in  std_logic; 
            DIA2: in  std_logic; DIA1: in  std_logic; 
            DIA0: in  std_logic; ADA12: in  std_logic; 
            ADA11: in  std_logic; ADA10: in  std_logic; 
            ADA9: in  std_logic; ADA8: in  std_logic; 
            ADA7: in  std_logic; ADA6: in  std_logic; 
            ADA5: in  std_logic; ADA4: in  std_logic; 
            ADA3: in  std_logic; ADA2: in  std_logic; 
            ADA1: in  std_logic; ADA0: in  std_logic; CEA: in  std_logic; 
            OCEA: in  std_logic; CLKA: in  std_logic; WEA: in  std_logic; 
            CSA2: in  std_logic; CSA1: in  std_logic; 
            CSA0: in  std_logic; RSTA: in  std_logic; 
            DIB8: in  std_logic; DIB7: in  std_logic; 
            DIB6: in  std_logic; DIB5: in  std_logic; 
            DIB4: in  std_logic; DIB3: in  std_logic; 
            DIB2: in  std_logic; DIB1: in  std_logic; 
            DIB0: in  std_logic; ADB12: in  std_logic; 
            ADB11: in  std_logic; ADB10: in  std_logic; 
            ADB9: in  std_logic; ADB8: in  std_logic; 
            ADB7: in  std_logic; ADB6: in  std_logic; 
            ADB5: in  std_logic; ADB4: in  std_logic; 
            ADB3: in  std_logic; ADB2: in  std_logic; 
            ADB1: in  std_logic; ADB0: in  std_logic; CEB: in  std_logic; 
            OCEB: in  std_logic; CLKB: in  std_logic; WEB: in  std_logic; 
            CSB2: in  std_logic; CSB1: in  std_logic; 
            CSB0: in  std_logic; RSTB: in  std_logic; 
            DOA8: out  std_logic; DOA7: out  std_logic; 
            DOA6: out  std_logic; DOA5: out  std_logic; 
            DOA4: out  std_logic; DOA3: out  std_logic; 
            DOA2: out  std_logic; DOA1: out  std_logic; 
            DOA0: out  std_logic; DOB8: out  std_logic; 
            DOB7: out  std_logic; DOB6: out  std_logic; 
            DOB5: out  std_logic; DOB4: out  std_logic; 
            DOB3: out  std_logic; DOB2: out  std_logic; 
            DOB1: out  std_logic; DOB0: out  std_logic);
    end component;
    attribute MEM_LPC_FILE : string; 
    attribute MEM_INIT_FILE : string; 
    attribute MEM_LPC_FILE of ram2C00bis2FFF_0_0_1 : label is "ram2C00bis2FFF.lpc";
    attribute MEM_INIT_FILE of ram2C00bis2FFF_0_0_1 : label is "RAM_2C00_2FFF.mem";
    attribute MEM_LPC_FILE of ram2C00bis2FFF_0_1_0 : label is "ram2C00bis2FFF.lpc";
    attribute MEM_INIT_FILE of ram2C00bis2FFF_0_1_0 : label is "RAM_2C00_2FFF.mem";
    attribute NGD_DRC_MASK : integer;
    attribute NGD_DRC_MASK of Structure : architecture is 1;

begin
    -- component instantiation statements
    ram2C00bis2FFF_0_0_1: DP8KC
        generic map (INIT_DATA=> "STATIC", ASYNC_RESET_RELEASE=> "SYNC", 
        INITVAL_1F=> "0x263002010620AFA3618B267782ECF11E20700EF11E2F11E2F1106F1106F11E2F116C831E2C316C83", 
        INITVAL_1E=> "0x1E2B6106F11E2831E2F102EA7186B6106F11E2F11E2F11E2F1000000000000000000000000000000", 
        INITVAL_1D=> "0x0000000000000000000000000000000000000000000000000000000000000000000000000000000A", 
        INITVAL_1C=> "0x0000000000010000000002908010CF00078000000000023E0000100029080100000E140280000008", 
        INITVAL_1B=> "0x0000020017210080000100000000000140000100029080100001A000000000054000000000021008", 
        INITVAL_1A=> "0x0000A00000000000AA000000000108010000140A014000011C00000200172100800000000000020B", 
        INITVAL_19=> "0x016000007602F080100001A1702E0000000000FE07C00001FF000000000000000000000000000000", 
        INITVAL_18=> "0x00004000040000000000000000000000000000003FE00000000000000000000003A800026E11511D", 
        INITVAL_17=> "0x00000000000000000000000000000000000000000000000000000000000000000000000019432813", 
        INITVAL_16=> "0x080550AA550AA550AA550AA550AA550AA550A8560AC560AC520B45A0B45A0B45A0B45A0B45A0B45A", 
        INITVAL_15=> "0x0B45A0B45A0B45A0B45A0B45A0946A0D46A0D46A0D46A080550AA550AA5500000000000000000000", 
        INITVAL_14=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_13=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_12=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_11=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_10=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0F=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0E=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0D=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0C=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000100", 
        INITVAL_0B=> "0x0000000000000000000000000000000000000000000000000000000000000000000000000730007F", 
        INITVAL_0A=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_09=> "0x000000000000000000000000000000000000E0000000000000000000000000000000000000000000", 
        INITVAL_08=> "0x000000000000019001FF000000000000003002000000000000000000000000000001000000000000", 
        INITVAL_07=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_06=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_05=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_04=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_03=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_02=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_01=> "0x00000000000000000000000000000000000000000000000001000000000000000000000000000000", 
        INITVAL_00=> "0x000003FE000000000000000000000000000000010000000000000000000100000000000000000000", 
        CSDECODE_B=> "0b000", CSDECODE_A=> "0b000", WRITEMODE_B=> "READBEFOREWRITE", 
        WRITEMODE_A=> "READBEFOREWRITE", GSR=> "ENABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        port map (DIA8=>DataInA(8), DIA7=>DataInA(7), DIA6=>DataInA(6), 
            DIA5=>DataInA(5), DIA4=>DataInA(4), DIA3=>DataInA(3), 
            DIA2=>DataInA(2), DIA1=>DataInA(1), DIA0=>DataInA(0), 
            ADA12=>AddressA(9), ADA11=>AddressA(8), ADA10=>AddressA(7), 
            ADA9=>AddressA(6), ADA8=>AddressA(5), ADA7=>AddressA(4), 
            ADA6=>AddressA(3), ADA5=>AddressA(2), ADA4=>AddressA(1), 
            ADA3=>AddressA(0), ADA2=>scuba_vlo, ADA1=>scuba_vlo, 
            ADA0=>scuba_vhi, CEA=>ClockEnA, OCEA=>ClockEnA, CLKA=>ClockA, 
            WEA=>WrA, CSA2=>scuba_vlo, CSA1=>scuba_vlo, CSA0=>scuba_vlo, 
            RSTA=>ResetA, DIB8=>DataInB(8), DIB7=>DataInB(7), 
            DIB6=>DataInB(6), DIB5=>DataInB(5), DIB4=>DataInB(4), 
            DIB3=>DataInB(3), DIB2=>DataInB(2), DIB1=>DataInB(1), 
            DIB0=>DataInB(0), ADB12=>AddressB(9), ADB11=>AddressB(8), 
            ADB10=>AddressB(7), ADB9=>AddressB(6), ADB8=>AddressB(5), 
            ADB7=>AddressB(4), ADB6=>AddressB(3), ADB5=>AddressB(2), 
            ADB4=>AddressB(1), ADB3=>AddressB(0), ADB2=>scuba_vlo, 
            ADB1=>scuba_vlo, ADB0=>scuba_vhi, CEB=>ClockEnB, 
            OCEB=>ClockEnB, CLKB=>ClockB, WEB=>WrB, CSB2=>scuba_vlo, 
            CSB1=>scuba_vlo, CSB0=>scuba_vlo, RSTB=>ResetB, DOA8=>QA(8), 
            DOA7=>QA(7), DOA6=>QA(6), DOA5=>QA(5), DOA4=>QA(4), 
            DOA3=>QA(3), DOA2=>QA(2), DOA1=>QA(1), DOA0=>QA(0), 
            DOB8=>QB(8), DOB7=>QB(7), DOB6=>QB(6), DOB5=>QB(5), 
            DOB4=>QB(4), DOB3=>QB(3), DOB2=>QB(2), DOB1=>QB(1), 
            DOB0=>QB(0));

    scuba_vhi_inst: VHI
        port map (Z=>scuba_vhi);

    scuba_vlo_inst: VLO
        port map (Z=>scuba_vlo);

    ram2C00bis2FFF_0_1_0: DP8KC
        generic map (INIT_DATA=> "STATIC", ASYNC_RESET_RELEASE=> "SYNC", 
        INITVAL_1F=> "0x0067D0FA7D0FA03006010020600C0100202004010020100201000010000100201002000020100200", 
        INITVAL_1E=> "0x00201000010020000201000020020100001002010020100201000000000000000000000000000000", 
        INITVAL_1D=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000078", 
        INITVAL_1C=> "0x000000000000008010010006802C400007900000000000820C018010006802C000F0000000000000", 
        INITVAL_1B=> "0x00804000000D01600078000000000003A14028020006802C000F000000000002303018006000D016", 
        INITVAL_1A=> "0x00078000000000004218030030006802C000F000000000005900804000000D01600000000000F000", 
        INITVAL_19=> "0x00000000730006802C000F0000000000000000040F4000007F0F2000000000008010010000000000", 
        INITVAL_18=> "0x00000000000000000000000000000000000000000FE790000000000000000000000C000101702E17", 
        INITVAL_17=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000901208", 
        INITVAL_16=> "0x04020040200402004020040200402004020040200402004020040200402004020040200402004020", 
        INITVAL_15=> "0x04020040200402004020040200402004020040200402004020040200402000000000000000000000", 
        INITVAL_14=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_13=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_12=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_11=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_10=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0F=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0E=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0D=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_0C=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000016", 
        INITVAL_0B=> "0x00000000000000000000000000000000000006030000000000000000000000000000000000000000", 
        INITVAL_0A=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_09=> "0x00000000000000000000000000000000000000000100000000000000000000000000000000000000", 
        INITVAL_08=> "0x0000000000000000007F000000000000020000000000000000000000000000000000000000000000", 
        INITVAL_07=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_06=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_05=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_04=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_03=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_02=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_01=> "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000", 
        INITVAL_00=> "0x000000FE000000000000000000000000000000000000000000000000000000000000000000000000", 
        CSDECODE_B=> "0b000", CSDECODE_A=> "0b000", WRITEMODE_B=> "READBEFOREWRITE", 
        WRITEMODE_A=> "READBEFOREWRITE", GSR=> "ENABLED", RESETMODE=> "ASYNC", 
        REGMODE_B=> "NOREG", REGMODE_A=> "NOREG", DATA_WIDTH_B=>  9, 
        DATA_WIDTH_A=>  9)
        port map (DIA8=>scuba_vlo, DIA7=>scuba_vlo, DIA6=>DataInA(15), 
            DIA5=>DataInA(14), DIA4=>DataInA(13), DIA3=>DataInA(12), 
            DIA2=>DataInA(11), DIA1=>DataInA(10), DIA0=>DataInA(9), 
            ADA12=>AddressA(9), ADA11=>AddressA(8), ADA10=>AddressA(7), 
            ADA9=>AddressA(6), ADA8=>AddressA(5), ADA7=>AddressA(4), 
            ADA6=>AddressA(3), ADA5=>AddressA(2), ADA4=>AddressA(1), 
            ADA3=>AddressA(0), ADA2=>scuba_vlo, ADA1=>scuba_vlo, 
            ADA0=>scuba_vhi, CEA=>ClockEnA, OCEA=>ClockEnA, CLKA=>ClockA, 
            WEA=>WrA, CSA2=>scuba_vlo, CSA1=>scuba_vlo, CSA0=>scuba_vlo, 
            RSTA=>ResetA, DIB8=>scuba_vlo, DIB7=>scuba_vlo, 
            DIB6=>DataInB(15), DIB5=>DataInB(14), DIB4=>DataInB(13), 
            DIB3=>DataInB(12), DIB2=>DataInB(11), DIB1=>DataInB(10), 
            DIB0=>DataInB(9), ADB12=>AddressB(9), ADB11=>AddressB(8), 
            ADB10=>AddressB(7), ADB9=>AddressB(6), ADB8=>AddressB(5), 
            ADB7=>AddressB(4), ADB6=>AddressB(3), ADB5=>AddressB(2), 
            ADB4=>AddressB(1), ADB3=>AddressB(0), ADB2=>scuba_vlo, 
            ADB1=>scuba_vlo, ADB0=>scuba_vhi, CEB=>ClockEnB, 
            OCEB=>ClockEnB, CLKB=>ClockB, WEB=>WrB, CSB2=>scuba_vlo, 
            CSB1=>scuba_vlo, CSB0=>scuba_vlo, RSTB=>ResetB, DOA8=>open, 
            DOA7=>open, DOA6=>QA(15), DOA5=>QA(14), DOA4=>QA(13), 
            DOA3=>QA(12), DOA2=>QA(11), DOA1=>QA(10), DOA0=>QA(9), 
            DOB8=>open, DOB7=>open, DOB6=>QB(15), DOB5=>QB(14), 
            DOB4=>QB(13), DOB3=>QB(12), DOB2=>QB(11), DOB1=>QB(10), 
            DOB0=>QB(9));

end Structure;

-- synopsys translate_off
library MACHXO2;
configuration Structure_CON of ram2C00bis2FFF is
    for Structure
        for all:VHI use entity MACHXO2.VHI(V); end for;
        for all:VLO use entity MACHXO2.VLO(V); end for;
        for all:DP8KC use entity MACHXO2.DP8KC(V); end for;
    end for;
end Structure_CON;

-- synopsys translate_on
