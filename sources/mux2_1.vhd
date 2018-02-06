-- prima cosa da specificare in un file vhd è la libreria da usare
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2_1 is
    Port ( SEL: in STD_LOGIC;
            A:  in STD_LOGIC;
            B:  in STD_LOGIC;
            X_OUT: out STD_LOGIC );

end mux2_1;

-- scritto behavioural di propositoe perchè sto solo scrivendo il comportamento del componente, non è definitivo. IN realtà non sarebbe corretto usare il behavioural perchè non vi è alcun process

architecture Behavioral of mux2_1 is
begin

--     X <= A when (SEL = '1') else B;   -- questo codice è il peggiore che si possa scrivere, perchè non si tiene conto di tutti i possibili valori che SEL può assumere OLTRE a 0.
--     X <= A when (SEL = '1'),
--         B when (SEL = '0'), else 'X'; -- questo codice è leggermente meglio ma
                                      -- non mi fa capire SEL che valore ha

  -- BUON CODICE: Scritto in dataflow, SEL ha un rapporto diretto con X
  -- potremmo chiamare l'architettura dataflow perchè il mux scritto in questo modo può essere
  -- sintetizzato.
    X_OUT <= (A and SEL) or (B and (not SEL));


end Behavioral;
