LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY panel_rom IS
    PORT
    (
        panel_address    : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        font_row, font_col : IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        clock               : IN STD_LOGIC ;
        red, green, blue    : OUT STD_LOGIC_vector (3 DOWNTO 0)
    );
END panel_rom;

ARCHITECTURE SYN OF panel_rom IS

    SIGNAL rom_data        : STD_LOGIC_VECTOR (11 DOWNTO 0);
    SIGNAL rom_address     : STD_LOGIC_VECTOR (15 DOWNTO 0);

    COMPONENT altsyncram
    GENERIC (
        address_aclr_a           : STRING;
        clock_enable_input_a     : STRING;
        clock_enable_output_a    : STRING;
        init_file                : STRING;
        intended_device_family   : STRING;
        lpm_hint                 : STRING;
        lpm_type                 : STRING;
        numwords_a               : NATURAL;
        operation_mode           : STRING;
        outdata_aclr_a           : STRING;
        outdata_reg_a            : STRING;
        widthad_a                : NATURAL;
        width_a                  : NATURAL;
        width_byteena_a          : NATURAL
    );
    PORT (
        clock0       : IN STD_LOGIC ;
        address_a    : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        q_a          : OUT STD_LOGIC_VECTOR (11 DOWNTO 0)
    );
    END COMPONENT;

BEGIN

    altsyncram_component : altsyncram
    GENERIC MAP (
        address_aclr_a => "NONE",
        clock_enable_input_a => "BYPASS",
        clock_enable_output_a => "BYPASS",
        init_file => "training.mif",
        intended_device_family => "Cyclone III",
        lpm_hint => "ENABLE_RUNTIME_MOD=NO",
        lpm_type => "altsyncram",
        numwords_a => 4096,
        operation_mode => "ROM",
        outdata_aclr_a => "NONE",
        outdata_reg_a => "UNREGISTERED",
        widthad_a => 16,
        width_a => 12,
        width_byteena_a => 1
    )
    PORT MAP (
        clock0 => clock,
        address_a => rom_address,
        q_a => rom_data
    );

    -- Assuming bird_address is the high 6 bits and font_row is the low 3 bits to form a 9-bit address
    rom_address <= panel_address & font_row & font_col;

    red <= rom_data(11 DOWNTO 8);
    green <= rom_data(7 DOWNTO 4);
    blue <= rom_data(3 DOWNTO 0);

END SYN;
