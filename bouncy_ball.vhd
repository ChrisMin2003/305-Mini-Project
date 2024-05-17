LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;


ENTITY bouncy_ball IS
    PORT
        ( clk, vert_sync, pb1, pb2, sw1 : IN std_logic;
          pixel_row, pixel_column   : IN std_logic_vector(9 DOWNTO 0);
            font_row, font_col        : IN STD_LOGIC_VECTOR(2 downto 0);
          red, green, blue          : OUT std_logic;
			 cur_point      : OUT integer;
			 cur_lives      : OUT integer;
          left_button : IN std_logic;
			 start, destroyed       : OUT std_logic;
			 reset                  : IN std_logic);      
END bouncy_ball;

architecture behavior of bouncy_ball is
type y_pos_array is array (0 to 5) of std_logic_vector(9 DOWNTO 0);
type x_pos_array is array (0 to 5) of std_logic_vector(10 DOWNTO 0);

-- Signal for detecting collisions
SIGNAL y_pos_up, y_pos_down            : y_pos_array;
SIGNAL x_pos                           : x_pos_array;

--Signals for the bird
SIGNAL ball_on, ball_on1 : std_logic;
SIGNAL ball_destroyed : std_logic := '0';
SIGNAL start_flag : std_logic := '0';
SIGNAL size                                 : std_logic_vector(9 DOWNTO 0);  
SIGNAL ball_y_pos                      : std_logic_vector(9 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(240, 10);
SiGNAL ball_x_pos                      : std_logic_vector(10 DOWNTO 0) := CONV_STD_LOGIC_VECTOR(220, 11);
SIGNAL ball_y_motion                        : std_logic_vector(9 DOWNTO 0);
SIGNAL point : integer := 0;
SIGNAL lives : integer := 3;

-- Flags for tracking score increment
TYPE pipe_score_flag_array IS ARRAY (0 TO 5) OF BOOLEAN;
SIGNAL pipe_score_flag       : pipe_score_flag_array := (others => FALSE);

-- Portmap output instances
SIGNAL green_pipe1,green_pipe2,green_pipe3,green_pipe4,green_pipe5,green_pipe6   : std_logic;

-- Invincibility tracker
SIGNAL invin_flag : std_logic;
SIGNAL invin_counter : integer;

-- Pipe generation
component pipe is 
    port(clk, vert_sync : IN std_logic;
            start_flag : IN std_logic;
          pixel_row, pixel_column   : IN std_logic_vector(9 DOWNTO 0);
             pipe_num  : IN integer;

          green             : OUT std_logic;
          top_y_pos, bottom_y_pos  : OUT std_logic_vector(9 downto 0);
          left_x_pos  : OUT std_logic_vector(10 DOWNTO 0));
end component;

component bird_rom is
    PORT
    (
        bird_address    :   IN STD_LOGIC_VECTOR (5 DOWNTO 0);
        font_row, font_col  :   IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        clock               :   IN STD_LOGIC ;
        rom_mux_output      :   OUT STD_LOGIC
    );
end component;


BEGIN 

    -- Set start_flag to 1 when pb1 is 0, and keep it at 1 forever after that
    process(clk)
    begin
			if rising_edge(clk) then
            if pb1 = '0' then
                start_flag <= '1';
            end if;
				if ball_destroyed = '1' then
					start_flag <= '0';
				end if;
				if (pb2 = '0') then
                start_flag <= '0';
            end if;
        end if;
    end process;
	 

	 
     
bird1 : bird_rom port map (bird_address => "000000", font_row => font_row, font_col => font_col, clock => clk, rom_mux_output => ball_on1);


--Pipe generation
pipe1: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 0, 
                            green => green_pipe1, top_y_pos => y_pos_up(0), bottom_y_pos => y_pos_down(0), left_x_pos => x_pos(0));
                            
pipe2: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 1, 
                            green => green_pipe2, top_y_pos => y_pos_up(1), bottom_y_pos => y_pos_down(1), left_x_pos => x_pos(1));
                            
pipe3: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 2, 
                            green => green_pipe3, top_y_pos => y_pos_up(2), bottom_y_pos => y_pos_down(2), left_x_pos => x_pos(2));
                            
pipe4: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 3, 
                            green => green_pipe4, top_y_pos => y_pos_up(3), bottom_y_pos => y_pos_down(3), left_x_pos => x_pos(3));
                            
pipe5: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 4, 
                            green => green_pipe5, top_y_pos => y_pos_up(4), bottom_y_pos => y_pos_down(4), left_x_pos => x_pos(4));
                            
pipe6: pipe port map(clk => clk, vert_sync => vert_sync, start_flag => start_flag, pixel_row => pixel_row, pixel_column => pixel_column, pipe_num => 5, 
                            green => green_pipe6, top_y_pos => y_pos_up(5), bottom_y_pos => y_pos_down(5), left_x_pos => x_pos(5));

size <= CONV_STD_LOGIC_VECTOR(8,10);
-- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
ball_x_pos <= CONV_STD_LOGIC_VECTOR(240,11);


ball_on <= '1' when ( ('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size)   -- x_pos - size <= pixel_column <= x_pos + size
                    and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size) and (ball_destroyed = '0'))  else -- y_pos - size <= pixel_row <= y_pos + size
            '0';
            
            
Red <= ball_on and (not invin_flag or CONV_STD_LOGIC_VECTOR(INTEGER(invin_counter MOD 20), 1)(0));
Green <= ((ball_on or not ball_on) and not sw1) or (green_pipe1 or green_pipe2 or green_pipe3 or green_pipe4 or green_pipe5 or green_pipe6);
Blue <= (not ball_on and not (green_pipe1 or green_pipe2 or green_pipe3 or green_pipe4 or green_pipe5 or green_pipe6)) and not sw1;


Move_Ball: process (vert_sync)
        variable move_up_flag : std_logic;
        variable move_up_counter : unsigned(31 downto 0);
begin

            -- Move ball once every vertical sync
        if (rising_edge(vert_sync)) then
			if (start_flag = '1') then
			if (invin_counter > 200) then
				invin_counter <= 0;
				invin_flag <= '0';
			elsif (invin_flag  = '1') then 
				invin_counter <= invin_counter + 1;
			end if;
		  
		  -- The for loop for detecting collision

            for i in 0 to 5 loop
					if (ball_y_pos + size >= y_pos_down(i) or ball_y_pos - size <= y_pos_up(i)) 
					and (ball_x_pos + size >= x_pos(i) and ball_x_pos - size <= x_pos(i) + 15)
					and (invin_flag = '0') then
							if (lives > 1) then 
								lives <= lives - 1; 
								invin_flag <= '1';
								invin_counter <= 1;
								
							else 
								lives <= lives - 1; 
								ball_destroyed <= '1';
							end if;

               end if;
					
                -- Check if the left side of the ball has passed through the right edge of the pipe
                if ball_x_pos - size <= x_pos(i) + 15 and ball_x_pos + ball_y_motion > x_pos(i) + 15 then
                   if not pipe_score_flag(i) then
                        point <= point + 1; -- Increment point
                        pipe_score_flag(i) <= true; -- Set flag to true
								if (i = 0) then
									pipe_score_flag(5) <= false;
								else 
									pipe_score_flag(i-1) <= false;
								end if;
                    end if;
                end if;
					 
            end loop;
				
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
                     else
                    -- If the bird is not destroyed, keep falling
                    ball_y_motion <= CONV_STD_LOGIC_VECTOR(4, 10);
                end if;
            end if;

            -- Compute next ball Y position
                if (ball_destroyed = '1') then
                        ball_y_pos <= CONV_STD_LOGIC_VECTOR(240,10);
                else
                        ball_y_pos <= ball_y_pos + ball_y_motion;
                end if;
					 
					 
				elsif (ball_destroyed = '1' and reset = '0') then
					ball_destroyed <= '0';  -- Reset ball_destroyed
					ball_y_pos <= CONV_STD_LOGIC_VECTOR(240, 10);  -- Reset ball_y_pos
					point <= 0;  -- Reset point
					lives <= 3;  -- Reset lives
					invin_flag <= '0';  -- Reset invincibility flag
					invin_counter <= 0;  -- Reset invincibility counter
					pipe_score_flag <= (others => FALSE);  -- Reset pipe score flags
				end if;
        end if;
		  
		  cur_point <= point;
		  cur_lives <= lives;
		  start <= start_flag;
		  destroyed <= ball_destroyed;
    
end process Move_Ball;


END behavior;