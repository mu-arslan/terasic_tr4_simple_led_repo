----------------------------------------------------------------------------------
-- Company:  Apical Limited
-- Engineer: Murat Arslan
-- 
-- Create Date: 19.04.2016
-- Design Name: 
-- Module Name: terasic_tr4_simple_led_top - Behavioral
-- Project Name: 
-- Target Devices: Stratix IV GX
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity terasic_tr4_simple_led_top is
port(
  -- Clock interface
  ------------------------------------------
  OSC_50_BANK1    : in  std_logic;
  
  -- Switch Interface
  ------------------------------------------
  SW0             : in  std_logic;
  SW1             : in  std_logic;
  SW2             : in  std_logic;
  SW3             : in  std_logic;

  -- Led Interface
  ------------------------------------------
  LED0            : out std_logic;
  LED1            : out std_logic;
  LED2            : out std_logic;
  LED3            : out std_logic  
);
end terasic_tr4_simple_led_top;

architecture Behavioral of terasic_tr4_simple_led_top is

component terasic_tr4_simple_led_pll
port
(
  INCLK0		: in  std_logic  := '0';
  C0		    : out std_logic;
  LOCKED		: out std_logic 
);
end component;

signal clk_100mhz_from_pll  : std_logic := '0';
signal locked_from_pll      : std_logic := '0';

signal reset_from_pll       : std_logic := '0';

----------------------------------------
--
signal led_cntr : std_logic_vector(29 downto 0) := (others => '0');

begin 

----------------------------------------
--  generate 100MHz clock using the onboard 50MHz cyristal

pll_inst : terasic_tr4_simple_led_pll
port map
(
  INCLK0		=> OSC_50_BANK1,        --: in  std_logic  := '0';
  C0		    => clk_100mhz_from_pll, --: out std_logic;
  LOCKED		=> locked_from_pll      --: out std_logic 
);

reset_from_pll <= not locked_from_pll;


----------------------------------------
--  led_cntr

led_cntr_process: process(clk_100mhz_from_pll)
begin
if(clk_100mhz_from_pll'event and clk_100mhz_from_pll = '1') then
  led_cntr <= led_cntr + '1';
end if;
end process led_cntr_process;


----------------------------------------
--  physical LEDS

LED0 <= led_cntr(26) or reset_from_pll or SW0;
LED1 <= led_cntr(27) or reset_from_pll or SW1;
LED2 <= led_cntr(28) or reset_from_pll or SW2;
LED3 <= led_cntr(29) or reset_from_pll or SW3;



end Behavioral;
