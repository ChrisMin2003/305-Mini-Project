LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE IEEE.STD_LOGIC_ARITH.all;
USE IEEE.STD_LOGIC_UNSIGNED.all;

ENTITY display_start IS
	PORT
	(
		start, destroyed     : IN std_logic;
		pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock,vert_sync      : IN STD_LOGIC;
		output_char       	: OUT STD_LOGIC
	);
END display_start;



ARCHITECTURE display of display_start is

type score_word_array is array (0 to 12) of STD_LOGIC_VECTOR (5 DOWNTO 0);
type x_position is array (0 to 12) of std_logic_vector(10 DOWNTO 0);

component char_rom is
	PORT
	(
		character_address	:	IN STD_LOGIC_VECTOR (5 DOWNTO 0);
		font_row, font_col	:	IN STD_LOGIC_VECTOR (2 DOWNTO 0);
		clock				: 	IN STD_LOGIC ;
		rom_mux_output		:	OUT STD_LOGIC
	);
end component;

SIGNAL char_on1,char_on2,char_on3,char_on4,char_on5,char_on6,char_on7,char_on8,char_on9,char_on10,char_on11,char_on12,char_on13 : STD_LOGIC;
SIGNAL character_address : score_word_array;
SIGNAL temp1 ,temp2, temp3,temp4,temp5,temp6,temp7,temp8,temp9,temp10,temp11,temp12,temp13 : std_logic;
SIGNAL char_size : std_logic_vector(9 DOWNTO 0);
SIGNAL start_x_pos : x_position;
SIGNAL start_y_pos : std_logic_vector(9 DOWNTO 0);

begin
char_size <= CONV_STD_LOGIC_VECTOR(15, 10);

character_address(0) <= CONV_STD_LOGIC_VECTOR(16, 6); -- P
character_address(1) <= CONV_STD_LOGIC_VECTOR(21, 6); -- U
character_address(2) <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
character_address(3) <= CONV_STD_LOGIC_VECTOR(8, 6); -- H
character_address(4) <= CONV_STD_LOGIC_VECTOR(32, 6); -- SPACE
character_address(5) <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
character_address(6) <= CONV_STD_LOGIC_VECTOR(15, 6); -- O
character_address(7) <= CONV_STD_LOGIC_VECTOR(32, 6); -- SPACE
character_address(8) <= CONV_STD_LOGIC_VECTOR(19, 6); -- S
character_address(9) <= CONV_STD_LOGIC_VECTOR(20, 6); -- T
character_address(10) <= CONV_STD_LOGIC_VECTOR(1, 6); -- A
character_address(11) <= CONV_STD_LOGIC_VECTOR(18, 6); -- R
character_address(12) <= CONV_STD_LOGIC_VECTOR(20, 6); -- T

start_x_pos(0) <= CONV_STD_LOGIC_VECTOR(224, 11);
start_x_pos(1) <= CONV_STD_LOGIC_VECTOR(240, 11);
start_x_pos(2) <= CONV_STD_LOGIC_VECTOR(256, 11);
start_x_pos(3) <= CONV_STD_LOGIC_VECTOR(272, 11);
start_x_pos(4) <= CONV_STD_LOGIC_VECTOR(288, 11);
start_x_pos(5) <= CONV_STD_LOGIC_VECTOR(304, 11);
start_x_pos(6) <= CONV_STD_LOGIC_VECTOR(320, 11);
start_x_pos(7) <= CONV_STD_LOGIC_VECTOR(336, 11);
start_x_pos(8) <= CONV_STD_LOGIC_VECTOR(352, 11);
start_x_pos(9) <= CONV_STD_LOGIC_VECTOR(368, 11);
start_x_pos(10) <= CONV_STD_LOGIC_VECTOR(384, 11);
start_x_pos(11) <= CONV_STD_LOGIC_VECTOR(400, 11);
start_x_pos(12) <= CONV_STD_LOGIC_VECTOR(416, 11);



start_y_pos <= CONV_STD_LOGIC_VECTOR(16, 10);




char1 : char_rom port map (character_address => character_address(0), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp1);
char2 : char_rom port map (character_address => character_address(1), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp2);
char3 : char_rom port map (character_address => character_address(2), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp3);
char4 : char_rom port map (character_address => character_address(3), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp4);
char5 : char_rom port map (character_address => character_address(4), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp5);
char6 : char_rom port map (character_address => character_address(5), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp6);
char7 : char_rom port map (character_address => character_address(6), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp7);
char8 : char_rom port map (character_address => character_address(7), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp8);
char9 : char_rom port map (character_address => character_address(8), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp9);
char10 : char_rom port map (character_address => character_address(9), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp10);
char11 : char_rom port map (character_address => character_address(10), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp11);
char12 : char_rom port map (character_address => character_address(11), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp12);
char13 : char_rom port map (character_address => character_address(12), font_row => font_row, font_col => font_col, clock => clock, rom_mux_output => temp13);

					
					
char_on1 <= '1' when (('0' & start_x_pos(0) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(0) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';
char_on2 <= '1' when (('0' & start_x_pos(1) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(1) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
char_on3 <= '1' when (('0' & start_x_pos(2) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(2) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
			  
char_on4 <= '1' when (('0' & start_x_pos(3) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(3) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
			  
char_on5 <= '1' when (('0' & start_x_pos(4) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(4) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
char_on6 <= '1' when (('0' & start_x_pos(5) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(5) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';
char_on7 <= '1' when (('0' & start_x_pos(6) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(6) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
char_on8 <= '1' when (('0' & start_x_pos(7) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(7) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
			  
char_on9 <= '1' when (('0' & start_x_pos(8) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(8) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
			  
char_on10 <= '1' when (('0' & start_x_pos(9) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(9) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	
char_on11 <= '1' when (('0' & start_x_pos(10) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(10) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';
char_on12 <= '1' when (('0' & start_x_pos(11) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(11) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
char_on13 <= '1' when (('0' & start_x_pos(12) <= pixel_column) and ('0' & pixel_column <= '0' & start_x_pos(12) + char_size)
					and ('0' & start_y_pos <= pixel_row) and ('0' & pixel_row <= start_y_pos + char_size))  else	-- y_pos - size <= pixel_row <= y_pos + size
			  '0';	  
			  
			 		  
			  
output_char <= ((char_on1 and temp1) or (char_on2 and temp2) or (char_on3 and temp3) or (char_on4 and temp4) or (char_on5 and temp5) 
or (char_on6 and temp6) or (char_on7 and temp7) or (char_on8 and temp8) or (char_on9 and temp9) or (char_on10 and temp10) or (char_on11 and temp11) or (char_on12 and temp12) or (char_on13 and temp13))
and not (start) and not (destroyed);

end display;


