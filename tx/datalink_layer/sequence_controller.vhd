library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

-- Doet telkens 11 shifts van het dataregister gevolgd door 1 load
-- Shifts/loads gebeuren telkens nadat de pn_generator een 31 chip sequentie heeft gegenereert
-- Dit wordt aangegeven met pn_start

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
	-- register voor de state
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
	
	-- next state logica
	com_sequence_controller : process(pn_start, present_state, present_count)
	begin
		case present_state is
			when ws => 
				if pn_start = '1' and present_count /= to_unsigned(10, present_count'Length) then
					next_state <= ss;
				elsif pn_start = '1' and present_count = to_unsigned(10, present_count'Length) then
					next_state <= ls;
				else
					next_state <= present_state;
				end if;
				next_count <= present_count;
			when ss =>
				next_count <= present_count + 1;
				next_state <= ws;
			when ls =>
				next_count <= (others => '0');
				next_state <= ws;
		end case;
	end process com_sequence_controller;

	-- Output decoder : Mealy type (slechts 1 clock vertraging tss pn_start en sh/ld: tgv sh/ld operatie)
	-- Moore type introduceert 2 clocks vertraging: 1 voor de toestandsverandering, nog 1 tgv de sh/ld operatie)
	com_sequence_controller_out : process(present_state, present_count, pn_start)
	begin
		case present_state is
			when ws => 
				if pn_start = '1' then
					if present_count = to_unsigned(10, present_count'Length) then
						ld <= '1';
						sh <= '0';
					else
						ld <= '0';
						sh <= '1';
					end if;
				else
					ld <= '0';
					sh <= '0';
				end if;
			when others =>
				ld <= '0';
				sh <= '0';
		end case;

			
	end process com_sequence_controller_out;
end behave;