----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/01/03 20:24:05
-- Design Name: 
-- Module Name: sort3 - Behavioral
-- Project Name: 
-- Target Devices: 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sort3 is
    Port ( clk : in STD_LOGIC;
           din1 : in STD_LOGIC_VECTOR (13 downto 0);
           din2 : in STD_LOGIC_VECTOR (13 downto 0);
           din3 : in STD_LOGIC_VECTOR (13 downto 0);
           min : out STD_LOGIC_VECTOR (13 downto 0);
           mid : out STD_LOGIC_VECTOR (13 downto 0);
           max : out STD_LOGIC_VECTOR (13 downto 0));
end sort3;

architecture Behavioral of sort3 is

begin

process(clk)
begin
    if rising_edge(clk) then
        if din1 >= din2 and din1 >= din3 then
            max <= din1;
        elsif din2 >= din1 and din2 >= din1 then
            max <= din2;
        elsif din3 >= din1 and din3 >= din2 then
            max <= din3;
        end if;
    end if;
end process;
process(clk)
begin
    if rising_edge(clk) then
        if din1 >= din2 and din1 <= din3 then
            mid <= din1;
        elsif din2 >= din1 and din2 <= din1 then
            mid <= din2;
        elsif din3 >= din1 and din3 <= din2 then
            mid <= din3;
        end if;
    end if;
end process;

process(clk)
begin
    if rising_edge(clk) then
        if din1 <= din2 and din1 <= din3 then
            min <= din1;
        elsif din2 <= din1 and din2 <= din1 then
            min <= din2;
        elsif din3 <= din1 and din3 <= din2 then
            min <= din3;
        end if;
    end if;
end process;

end Behavioral;
