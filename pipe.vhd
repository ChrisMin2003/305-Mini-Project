LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.MATH_REAL.all;

ENTITY pipe IS
	PORT
		( clk, vert_sync, start_flag	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
			 pipe_num : IN integer;
			 reset : IN std_logic;
			 difficulty: IN integer;
			 ypos : IN std_logic_vector(9 downto 0);
		  green 			: OUT std_logic;
		  top_y_pos, bottom_y_pos  : OUT std_logic_vector(9 downto 0);
		  left_x_pos  : OUT std_logic_vector(10 DOWNTO 0));		
END pipe;

architecture pipe_gen of pipe is
type random_y_array is array (0 to 5) of std_logic_vector(7 DOWNTO 0);
type en_array is array (0 to 5) of std_logic;

SIGNAL randoms                         : random_y_array;
SIGNAL pipe_up_on, pipe_down_on        : std_logic;
SIGNAL pipe_y_interval                 : std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_x_size                     : std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_up_y_edge                  : std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(100, 10);
SIGNAL pipe_down_y_edge                : std_logic_vector(9 DOWNTO 0);
SiGNAL pipe_le_x_edge                  : std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(640, 11);
SIGNAL pipe_x_motion                   : std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_x_interval                 : integer := 340;
SIGNAL en : en_array;

component lfsr is 
port (
  i_clk           : in  std_logic;
    i_en            : in  std_logic;
	 i_sync_reset    : in  std_logic;
	 i_seed          	: in std_logic_vector (7 downto 0);
    o_lsfr          : out std_logic_vector (7 downto 0));
end component;

BEGIN


random_pipe1: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000001", o_lsfr => randoms(0));
random_pipe2: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000010", o_lsfr => randoms(1));
random_pipe3: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000011", o_lsfr => randoms(2));
random_pipe4: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000100", o_lsfr => randoms(3));
random_pipe5: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000101", o_lsfr => randoms(4));
random_pipe6: lfsr port map(i_clk => vert_sync, i_en => '1', i_sync_reset => '1', i_seed => "00000110", o_lsfr => randoms(5));


pipe_x_size <= CONV_STD_LOGIC_VECTOR(15,10);


pipe_y_interval <= CONV_STD_LOGIC_VECTOR(200,10);

pipe_down_y_edge <= pipe_up_y_edge + pipe_y_interval;


pipe_up_on <= '1' when ( ('0' & (pipe_le_x_edge + pipe_x_interval * pipe_num) <= '0' & pixel_column + pipe_x_size) and ('0' & pixel_column <= '0' & (pipe_le_x_edge + pipe_x_interval * pipe_num) + pipe_x_size)
					and ('0' & pixel_row <= '0' & pipe_up_y_edge))  else
			'0';
			
pipe_down_on <= '1' when ( ('0' & (pipe_le_x_edge + pipe_x_interval * pipe_num) <= '0' & pixel_column + pipe_x_size) and ('0' & pixel_column <= '0' & (pipe_le_x_edge + pipe_x_interval * pipe_num) + pipe_x_size)
					and ('0' & pipe_down_y_edge <= '0' & pixel_row))  else
			'0';

Green <= pipe_up_on or pipe_down_on;

Move_pipe : process(vert_sync)
begin

	if (rising_edge(vert_sync)) then
		if pipe_le_x_edge + pipe_x_interval * pipe_num  > CONV_STD_LOGIC_VECTOR(800, 11) then
                pipe_up_y_edge <= "00" & randoms(pipe_num);
            else
                pipe_up_y_edge <= ypos;
            end if;
		
		if (start_flag = '1') then
			pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(2 + difficulty, 10);
			pipe_le_x_edge <= pipe_le_x_edge + pipe_x_motion;
		elsif (reset = '0') then
			pipe_le_x_edge <= CONV_STD_LOGIC_VECTOR(640, 11);
		end if;
    end if;
end process Move_pipe;

top_y_pos <= pipe_up_y_edge;
bottom_y_pos <= pipe_down_y_edge;
left_x_pos <= pipe_le_x_edge + pipe_x_interval * pipe_num;

END pipe_gen;