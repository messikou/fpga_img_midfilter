----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:33:25 03/02/2017 
-- Design Name: 
-- Module Name:    avg_filter - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mid_filter is
    generic(
        Pixel_Size                      : integer := 14;
        Img_Width                       : integer := 640;
        Img_Height                      : integer := 512;
        Line_interval                   : integer := 10
        );
    port(
        clk                             : in std_logic;
        fval_in                         : in std_logic;
        hval_in                         : in std_logic;
        pixel_in                        : in std_logic_vector(Pixel_Size - 1 downto 0);
        
        fval_mid_fil                    : out std_logic;
        hval_mid_fil                    : out std_logic;
        pixel_mid_fil                   : out std_logic_vector(Pixel_Size - 1 downto 0)
        );
end mid_filter;

architecture Behavioral of mid_filter is

    function clog2(size : integer) return integer is 
        variable b    : integer := 1;
        variable inp  : integer := 0;
    begin
        inp := size - 1;
        while(inp > 1) loop
            inp := inp / 2;
            b   := b + 1;
        end loop;
        return b;
    end function;
    
    constant Img_Width_Size             : integer := clog2(Img_Width);
    -- constant Img_Width_Size             : integer := clog2(640);
    constant Delay_Num_Line             : integer := Img_Width + Line_interval;
   
   
   
   component sort3 is
        Port ( clk : in STD_LOGIC;
               din1 : in STD_LOGIC_VECTOR (13 downto 0);
               din2 : in STD_LOGIC_VECTOR (13 downto 0);
               din3 : in STD_LOGIC_VECTOR (13 downto 0);
               min : out STD_LOGIC_VECTOR (13 downto 0);
               mid : out STD_LOGIC_VECTOR (13 downto 0);
               max : out STD_LOGIC_VECTOR (13 downto 0));
    end component;
    
    component delay 
    generic(
        Delay_Num                       : integer := 100
        );
    port(
        clk                             : in std_logic;
        sig_in                          : in std_logic;
        sig_out                         : out std_logic
        );
    end component;

    component delay_bus
    generic(
        Delay_Num                       : integer := 100;
        Date_Size                       : integer := 14
        );
    port(
        clk                             : in std_logic;
        sig_in                          : in std_logic_vector(Date_Size - 1 downto 0);
        sig_out                         : out std_logic_vector(Date_Size - 1 downto 0)
        );
    end component;
    


    signal data_s0                      : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s0_reg1                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s0_reg2                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s1                      : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s1_reg1                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s1_reg2                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s2                      : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s2_reg1                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal data_s2_reg2                 : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    
    signal max_min                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal mid_mid                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal min_max                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');


    signal max_1                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal mid_1                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal min_1                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal max_2                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal mid_2                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal min_2                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal max_3                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal mid_3                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    signal min_3                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    
    signal mid_data                    : std_logic_vector(Pixel_Size - 1 downto 0) := (others => '0');
    
begin


  
    u0 : delay_bus
    generic map(
        Delay_Num                       => Delay_Num_Line,
        Date_Size                       => Pixel_Size
        )
    port map(
        clk                             => clk,
        sig_in                          => data_s0,
        sig_out                         => data_s1
        );
        
    u1 : delay_bus
    generic map(
        Delay_Num                       => Delay_Num_Line,
        Date_Size                       => Pixel_Size
        )
    port map(
        clk                             => clk,
        sig_in                          => data_s1,
        sig_out                         => data_s2
        );
   
    u21: sort3 
         Port map( 
            clk  =>clk
            din1 =>data_s0,
            din2 =>data_s0_reg1,
            din3 =>data_s0_reg2,
            min  => min_1,
            mid  => mid_1,
            max  => max_1 
                );
    u22: sort3 
         Port map( 
            clk  =>clk
            din1 =>data_s1,
            din2 =>data_s1_reg1,
            din3 =>data_s1_reg2,
            min  => min_2,
            mid  => mid_2,
            max  => max_2
                );                
    u23: sort3 
         Port map( 
            clk  =>clk
            din1 =>data_s2,
            din2 =>data_s2_reg1,
            din3 =>data_s2_reg2,
            min  => min_3,
            mid  => mid_3,
            max  => max_3 
                );   
                
                );                
    u31: sort3 
         Port map( 
            clk  =>clk
            din1 =>min_1,
            din2 =>min_2,
            din3 =>min_3,
            min  => open,
            mid  => open,
            max  => max_min 
                );                
    u32: sort3 
         Port map( 
            clk  =>clk
            din1 =>mid_1,
            din2 =>mid_2,
            din3 =>mid_3,
            min  => open,
            mid  => mid_mid,
            max  => open 
                );  
     u33: sort3 
         Port map( 
            clk  =>clk
            din1 =>max_1,
            din2 =>max_2,
            din3 =>max_3,
            min  => min_max,
            mid  => open,
            max  => open 
                );                 
     u4: sort3 
        Port map( 
           clk  =>clk
           din1 =>max_min,
           din2 =>mid_mid,
           din3 =>min_max,
           min  => open,
           mid  => mid_data,
           max  => open 
               );   
                 
    process(clk)
    begin
        if rising_edge(clk) then
            data_s0      <= pixel_in;
            data_s0_reg1 <= data_s0;
            data_s0_reg2 <= data_s0_reg1;
            data_s1_reg1 <= data_s1;
            data_s1_reg2 <= data_s1_reg1;
            data_s2_reg1 <= data_s2;
            data_s2_reg2 <= data_s2_reg1;
        end if;
    end process;
    




    
    u4 : delay 
    generic map(
        Delay_Num                       => Delay_Num_Line + 5
        )
    port map(
        clk                             => clk,
        sig_in                          => hval_in,
        sig_out                         => hval_mid_fil
        );
        
    u5 : delay 
    generic map(
        Delay_Num                       => Delay_Num_Line + 5
        )
    port map(
        clk                             => clk,
        sig_in                          => fval_in,
        sig_out                         => fval_mid_fil
        );
    
    
    pixel_mid_fil <= mid_data;        
    
    
end Behavioral;
