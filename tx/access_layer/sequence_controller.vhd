library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity sequence_controller is
	port(clk 		: in std_logic;
		 reset		: in std_logic;
		 pn_start 	: in std_logic;
		 ld			: out std_logic;
		 sh			: out std_logic);
end sequence_controller;

-- ************************************
-- *** Zie notas voor state diagram ***
-- ************************************
architecture behave of sequence_controller is
	type fsm_states is (ws, ss, ls);
	signal present_state, next_state : fsm_states;
	-- tellen tot decimaal 10 -> 4 bits
	signal present_count, next_count : unsigned(3 downto 0);
begin
	sym_sequence_controller : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				present_state <= ws;
				present_count <= to_unsigned(10, present_count'Length);
			else
				present_state <= next_state;			
				present_count <= next_count;
			end if;
		end if;
	end process sym_sequence_controller;
	
	com_sequence_controller : process(pn_start, present_state, present_count)
	begin
		case present_state is
			when ws => 
				ld <= '0';
				sh <= '0';				
				if pn_start = '1' and present_count /= to_unsigned(10, present_count'Length) then
					next_state <= ss;
				elsif pn_start = '1' and present_count = to_unsigned(10, present_count'Length) then
					next_state <= ls;
				else
					next_state <= present_state;
				end if;
				next_count <= present_count;
			when ss =>
				ld <= '0';
				sh <= '1';
				next_count <= present_count + 1;
				next_state <= ws;
			when ls =>
				ld <= '1';
				sh <= '0';
				next_count <= (others => '0');
				next_state <= ws;
		end case;
	end process com_sequence_controller;
end behave;