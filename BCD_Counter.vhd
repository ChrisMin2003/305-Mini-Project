library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BCD_counter is
    port (
        clk       : in  std_logic;
        enable    : in  std_logic;
        init      : in  std_logic;
        direction : in  std_logic;
        Q_out     : out std_logic_vector(3 downto 0)
    );
end entity BCD_counter;

architecture rtl of BCD_counter is
    signal count_reg : unsigned(3 downto 0) := "0000";
	 signal timer_delay : integer := 0;
begin
    count_process : process(clk)
    begin
		
        if rising_edge(clk) then
			if timer_delay = 5000000 then
				timer_delay <= 0;
            if enable = '1' then
                if init = '1' then
                    if direction = '0' then
                        count_reg <= "0000";
                    else
                        count_reg <= "1001";
                    end if;
                elsif direction = '0' then  -- Up counter
                    if count_reg = "1001" then
                        count_reg <= "0000";
                    else
                        count_reg <= count_reg + 1;
                    end if;
                else  -- Down counter
                    if count_reg = "0000" then
                        count_reg <= "1001";
                    else
                        count_reg <= count_reg - 1;
                    end if;
                end if;
            end if;

			else
				timer_delay <= timer_delay + 1;
			end if;
		  

		end if;
    end process count_process;

    Q_out <= std_logic_vector(count_reg);
end architecture rtl;