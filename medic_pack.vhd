LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity medic_pack is
		PORT
        ( clk, vert_sync, start_flag	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
			 reset : IN std_logic;
			 difficulty: IN integer;
			 destroyed: IN std_logic;
			 ypos : IN std_logic_vector(9 downto 0);
		  medic_out 			: OUT std_logic;
		  y_pos  : OUT std_logic_vector(9 downto 0);
		  x_pos  : OUT std_logic_vector(10 DOWNTO 0));
end medic_pack;

architecture medic_gen of medic_pack is
SIGNAL randomized_y : std_logic_vector(7 downto 0);
SIGNAL pack_size : std_logic_vector(9 downto 0);
SIGNAL pack_x_motion : std_logic_vector(9 downto 0);
SIGNAL y_pos_signal: std_logic_vector(9 downto 0);
SIGNAL x_pos_signal : std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(900, 11);

component lfsr is 
	port (
		i_clk           : in  std_logic;
		i_en            : in  std_logic;
		i_sync_reset    : in  std_logic;
		i_seed          	: in std_logic_vector (7 downto 0);
		o_lsfr          : out std_logic_vector (7 downto 0));
end component;
begin

random_medic: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "10000000", o_lsfr => randomized_y);

pack_size <= CONV_STD_LOGIC_VECTOR(15,10);

medic_out <= '1' when ( ('0' & x_pos_signal <= '0' & pixel_column + pack_size) and ('0' & pixel_column <= '0' & x_pos_signal + pack_size)
                    and ('0' & y_pos_signal <= pixel_row + pack_size) and ('0' & pixel_row <= y_pos_signal + pack_size) and (destroyed = '0'))  else
			'0';
	
Move_pack : process(vert_sync)
begin
	if (rising_edge(vert_sync)) then
		if x_pos_signal > CONV_STD_LOGIC_VECTOR(800, 11) then
                y_pos_signal <= "00" & (randomized_y + 100);
            else
                y_pos_signal <= ypos;
            end if;
		if (start_flag = '1') then
			pack_x_motion <= - CONV_STD_LOGIC_VECTOR(3 + difficulty, 10);
			x_pos_signal <= x_pos_signal + pack_x_motion;
		elsif (reset = '0') then
			x_pos_signal <= CONV_STD_LOGIC_VECTOR(640, 11);
		end if;
    end if;
end process Move_pack;

y_pos <= y_pos_signal;
x_pos <= x_pos_signal;


end medic_gen;