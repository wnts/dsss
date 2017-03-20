library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;


entity debouncer is
   port (
	clk: in std_logic;
	cha: in std_logic;
	reset: in std_logic;
	syncha: out std_logic
	);
end debouncer;

architecture behav of debouncer is

signal reg_cur, reg_next: std_logic_vector(4 downto 0);
begin
  
syn_debounce: process(clk)
begin    
  
if rising_edge(clk) then
  if reset = '1' then
    reg_cur <= (others => '0');
  else
    reg_cur <= reg_next;
  end if;
end if;

end process syn_debounce;

syn_comb: process(cha, reg_cur)
begin
  syncha <= reg_cur(0);  
  if (cha xor reg_cur(0)) = '1' then
    reg_next <= cha & reg_cur(4 downto 1);
  else
    reg_next <= (0 => reg_cur(0),
                 others => reg_cur(1));
  end if;
end process syn_comb;

end behav;