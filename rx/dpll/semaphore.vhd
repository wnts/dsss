library ieee;
use ieee.std_logic_1164.all;

entity semaphore is
	port(clk		: in std_logic;
		 reset		: in std_logic;	     		 
	     arm		: in std_logic;
         fire		: in std_logic;
		 seg		: in std_logic_vector(4 downto 0);
		 sem		: out std_logic_vector(4 downto 0));		
end semaphore;

architecture behave of semaphore is	
	type fsm_states is (ws, as, fs); -- wait state, arm state, fire state
	signal present_state, next_state : fsm_states;
begin
	syn_semaphore : process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then	
				present_state <= ws;
			else
				present_state <= next_state;
			end if;
		end if;
	end process syn_semaphore;
	
	com_semaphore : process(present_state, arm, fire, seg)
	begin
		case present_state is 
			-- default segment C
			when ws => sem <= "00100";
				if arm = '1' then
					next_state <= as;
				else
					next_state <= present_state;					
				end if;
			when as => sem <= seg;
				if fire = '1' then
					next_state <= fs;					
				else
					next_state <= present_state;
				end if;
			when fs => sem <= seg;
				if arm = '1' then
					next_state <= as;
				else
					next_state <= ws;
				end if;
		end case;					
	end process com_semaphore;
end behave;