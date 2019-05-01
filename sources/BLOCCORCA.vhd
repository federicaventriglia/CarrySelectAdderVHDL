library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Blocco del Carry Select
entity BLOCCORCA is
	generic(WIDTH : integer :=4);
	Port(
			X: in std_logic_vector(WIDTH-1 downto 0);    -- Input a della cella RCA
			Y: in std_logic_vector(WIDTH-1 downto 0);    -- input b della cella RCA
			carry_in: in std_logic;                      -- riporto di ingresso al blocco
			carry_out: out std_logic;                    -- carry in uscita
			S: out std_logic_vector(WIDTH-1 downto 0)  -- risultato della somma
	);
end BLOCCORCA;

architecture Structural of BLOCCORCA is

signal out_a : std_logic_vector(WIDTH-1 downto 0);  -- Uscita del primo RCA
signal out_b : std_logic_vector(WIDTH-1 downto 0);  -- Uscita del secondo RCA
signal carry_a , carry_b : std_logic;               -- Riporti dei due RCA


Component  RCADDER is
	generic ( WIDTH : integer := 8);
	Port(
      X  : in std_logic_vector(WIDTH-1 downto 0);
      Y  : in std_logic_vector(WIDTH-1 downto 0);
      C_in : in std_logic;
      --
      RESULT   : out std_logic_vector(WIDTH-1 downto 0);
      OVERFLOW  : out std_logic
	);
end Component;

begin

-- primo rca
rc1: RCADDER
	Generic map(WIDTH => WIDTH)
		Port map(
			X => X,
			Y => Y,
			C_in => '1', -- riporto '1'
      --
      OVERFLOW => carry_a,
			RESULT => out_a
		);
-- secondo rca
rc2: RCADDER
	Generic map(WIDTH => WIDTH)
		Port map(
			X => X,
			Y => Y,
			C_in => '0', -- riporto '0'
      --
			OVERFLOW => carry_b,
			RESULT => out_b
		);

-- mux finali, per restituire il risultato della somma
-- il carry in ingresso funge da selettore

-- viene scelta l'out_a quando il carry_in è posto ad 1
	S <=  out_a when carry_in ='1'
    else out_b ;

--il carry in uscita viene nuovamente selezionato in base a carry_in
	carry_out <=  carry_a when carry_in ='1'
    else carry_b;

end Structural;
