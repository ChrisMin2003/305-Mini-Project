LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
	PORT
		( clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic;
		  left_button : IN std_logic);		
END bouncy_ball;

architecture behavior of bouncy_ball is

SIGNAL ball_on, ball_destroyed         : std_logic;
SIGNAL size 					            : std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos                      : std_logic_vector(9 DOWNTO 0);
SiGNAL ball_x_pos                      : std_logic_vector(10 DOWNTO 0);
SIGNAL ball_y_motion			            : std_logic_vector(9 DOWNTO 0);
SIGNAL green_pipe                      : std_logic;

-- Pipe generation
component pipe is 
	port(clk, vert_sync	: IN std_logic;
          pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  green			: OUT std_logic);
end component;

BEGIN 

--Pipe generation
pipe1: pipe port map(clk => clk, vert_sync => vert_sync, pixel_row => pixel_row, pixel_column => pixel_column, green => green_pipe);   

size <= CONV_STD_LOGIC_VECTOR(16,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(240,11);


ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) 	-- x_pos - size <= pixel_column <= x_pos + size
					and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) )  else	-- y_pos - size <= pixel_row <= y_pos + size
			'0';


-- Colours for pixel data on video signal
-- Changing the background and ball colour by pushbuttons
Red <=  ball_on;
Green <= ball_on or green_pipe;
Blue <=  not ball_on and not green_pipe;


Move_Ball: process (vert_sync)
		variable move_up_flag : std_logic;
		variable move_up_counter : unsigned(31 downto 0);
begin
			-- Move ball once every vertical sync
        if (rising_edge(vert_sync)) then
            -- Check if the left button is clicked
            if (left_button = '1') then
                move_up_flag := '1'; -- Set the flag to move the ball upwards
                move_up_counter := (OTHERS => '0'); -- Reset the counter
            end if;

            -- Move the ball upwards for 1 second if the flag is set and the bird is not destroyed
            if (move_up_flag = '1' and ball_destroyed = '0') then
                move_up_counter := move_up_counter + 1; -- Increment the counter
                ball_y_motion <= - CONV_STD_LOGIC_VECTOR(5, 10); -- Move upwards
                if (move_up_counter >= 15) then
                    move_up_flag := '0'; -- Reset the flag
                end if;
            else
                -- Reach bottom of screen and destroy or keep falling
                if (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479, 10) - size)) then
                    ball_y_motion <= "0000000000";
						  ball_destroyed <= '1';
					 else
                    ball_y_motion <= CONV_STD_LOGIC_VECTOR(2, 10);
                end if;
            end if;

            -- Compute next ball Y position
				if (ball_destroyed = '1') then
						ball_y_pos <= CONV_STD_LOGIC_VECTOR(240,10);
						ball_destroyed <= '0';
				else
						ball_y_pos <= ball_y_pos + ball_y_motion;
				end if;
        end if;
end process Move_Ball;

END behavior;

