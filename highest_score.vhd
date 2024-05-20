LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_SIGNED.all;

entity highest_score is
     port (	clk              : in std_logic;
				score            : in integer;
				high_score_tens, high_score_ones : out std_logic_vector(3 downto 0));
end entity;

architecture beh of highest_score is
signal cur_high_score : integer;
begin
	process(clk)
	begin
			if rising_edge(clk) then
			if (score > cur_high_score) then
				cur_high_score <= score;
				high_score_tens <= CONV_STD_LOGIC_VECTOR(INTEGER(score / 10), 4);
				high_score_ones <= CONV_STD_LOGIC_VECTOR(INTEGER(score MOD 10), 4);
			end if;
			end if;
	end process;

		
end architecture beh;