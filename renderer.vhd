library IEEE;
use  IEEE.STD_LOGIC_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity renderer is
	port(
		clk : in std_logic;
		red, green, blue : in std_logic_vector(3 downto 0);
		text_in : in std_logic;
		red_out, green_out, blue_out : out std_logic_vector(3 downto 0)
	);

end renderer;

architecture render of renderer is
begin
		process (clk)
		begin
			if (rising_edge(clk)) then
					if (text_in = '1') then
						red_out <= "1111";
						green_out <= "1111";
						blue_out <= "1111";
					else
						red_out <= red;
						green_out <= green;
						blue_out <= blue;
					end if;
			end if;
		end process;
end render;