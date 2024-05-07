LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;
USE IEEE.MATH_REAL.all;

ENTITY pipe IS
	PORT
		( clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  green 			: OUT std_logic);		
END pipe;

architecture pipe_gen of pipe is

SIGNAL pipe_up_on, pipe_down_on        : std_logic;
SIGNAL pipe_y_interval                 : std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_x_size                     : std_logic_vector(9 DOWNTO 0);
SIGNAL pipe_up_y_edge, pipe_down_y_edge: std_logic_vector(9 DOWNTO 0);
SiGNAL pipe_le_x_edge                  : std_logic_vector(10 DOWNTO 0);
SIGNAL pipe_x_motion                   : std_logic_vector(9 DOWNTO 0);

BEGIN

pipe_x_size <= CONV_STD_LOGIC_VECTOR(30,10);


pipe_y_interval <= CONV_STD_LOGIC_VECTOR(200,10);


pipe_up_y_edge <= CONV_STD_LOGIC_VECTOR(100, 10);
pipe_down_y_edge <= pipe_up_y_edge + pipe_y_interval;

pipe_up_on <= '1' when ( ('0' & pipe_le_x_edge <= '0' & pixel_column + pipe_x_size) and ('0' & pixel_column <= '0' & pipe_le_x_edge + pipe_x_size)
					and ('0' & pixel_row <= '0' & pipe_up_y_edge))  else
			'0';
			
pipe_down_on <= '1' when ( ('0' & pipe_le_x_edge <= '0' & pixel_column + pipe_x_size) and ('0' & pixel_column <= '0' & pipe_le_x_edge + pipe_x_size)
					and ('0' & pipe_down_y_edge <= '0' & pixel_row))  else
			'0';

Green <= pipe_up_on or pipe_down_on;

Move_pipe : process(vert_sync)
begin
	if (rising_edge(vert_sync)) then
		pipe_x_motion <= - CONV_STD_LOGIC_VECTOR(2, 10);
		pipe_le_x_edge <= pipe_le_x_edge + pipe_x_motion;
	end if;
end process Move_pipe;
END pipe_gen;