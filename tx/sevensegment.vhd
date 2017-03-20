library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sevensegment is
	port(num_in : in std_logic_vector(3 downto 0);
		 dot : in std_logic;
		 seg_out: out std_logic_vector(7 downto 0));
end sevensegment;

architecture behave of sevensegment is
begin
	comb_sevensegment : process(num_in, dot)
	begin
		case num_in is
			when "0001" =>
				seg_out(6 downto 0) <= "0000001";
			when "0010" =>
				seg_out(6 downto 0) <= "1001111";
			when "0011" =>
				seg_out(6 downto 0) <= "0010010";
			when "0100" =>
				seg_out(6 downto 0) <= "1001100";
			when "0101" =>
				seg_out(6 downto 0) <= "0100100";
			when "0110" =>
				seg_out(6 downto 0) <= "0100000";
			when "0111" =>
				seg_out(6 downto 0) <= "0000111";
			when "1000" =>
				seg_out(6 downto 0) <= "0000000";
			when "1001" =>
				seg_out(6 downto 0) <= "0000100";
			when "1010" =>
				seg_out(6 downto 0) <= "0001000";
			when "1011" =>
				seg_out(6 downto 0) <= "1100000";
			when "1100" =>
				seg_out(6 downto 0) <= "0110001";
			when "1101" =>
				seg_out(6 downto 0) <= "1000010";
			when "1110" =>
				seg_out(6 downto 0) <= "0110000";
			when "1111" =>
				seg_out(6 downto 0) <= "0111000";
			-- 'X' weergeven 
			when others =>
				seg_out(6 downto 0) <= "0010111";
			seg_out(7) <= dot;
		end case;
	end process comb_sevensegment;
end behave;

				



		


