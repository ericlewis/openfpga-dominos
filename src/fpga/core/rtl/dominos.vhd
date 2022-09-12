-- Top level file for Atari Dominos
-- (c) 2018 James Sweet
--
-- This is free software: you can redistribute
-- it and/or modify it under the terms of the GNU General
-- Public License as published by the Free Software
-- Foundation, either version 3 of the License, or (at your
-- option) any later version.
--
-- This is distributed in the hope that it will
-- be useful, but WITHOUT ANY WARRANTY; without even the
-- implied warranty of MERCHANTABILITY or FITNESS FOR A
-- PARTICULAR PURPOSE. See the GNU General Public License
-- for more details.

-- Targeted to EP2C5T144C8 mini board but porting to nearly any FPGA should be fairly simple
-- See Dominos manual pg. 40 for video output details. Resistor values listed here have been scaled 
-- for 3.3V logic. 
-- R48 1k Ohm
-- R49 1k Ohm
-- R50 680R
-- R51 330R

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity dominos is 
port(		
			Clk_50_I		: in  std_logic;	-- 50MHz input clock
			Reset_I		        : in  std_logic;	-- Reset button (Active low)
			VideoW_O		: out std_logic;  -- White video output (680 Ohm)
			VideoB_O		: out std_logic;	-- Black video output (1.2k)
			Sync_O		        : out std_logic;  -- Composite sync output (1.2k)
			Audio_O		        : out std_logic_vector(7 downto 0);  -- Ideally this should have a simple low pass filter
			Coin1_I		        : in  std_logic;  -- Coin switches (Active low)
			Coin2_I		        : in  std_logic;
			Start1_I		: in  std_logic;  -- Start buttons
			Start2_I		: in  std_logic;
			Up1			: in  std_logic;  -- Player controls
			Down1			: in  std_logic;
			Left1			: in  std_logic;
			Right1    	        : in  std_logic;
			Up2			: in  std_logic;
			Down2			: in  std_logic;
			Left2			: in  std_logic;
			Right2		        : in  std_logic;
			Test_I		        : in  std_logic;
			Lamp1_O		        : out std_logic;	-- Player 1 and 2 start button LEDs
			Lamp2_O		        : out std_logic;
			
			SW1_I			: in std_logic_vector(3 downto 0);
			
			
			hs_O			: out std_logic;
			vs_O			: out std_logic;
			hblank_O		: out std_logic;
			vblank_O		: out std_logic;

			clk_12		: in std_logic;
			clk_6_O		: out std_logic;

			-- signals that carry the ROM data from the MiSTer disk
			dn_addr        : in  std_logic_vector(15 downto 0);
			dn_data        : in  std_logic_vector(7 downto 0);
			dn_wr          : in  std_logic

			
			);
end dominos;

architecture rtl of dominos is

--signal clk_12			: std_logic;
signal clk_6			: std_logic;
signal phi1 			: std_logic;
signal phi2			: std_logic;
signal reset_n			: std_logic;

signal Hcount		        : std_logic_vector(8 downto 0) := (others => '0');
signal H256			: std_logic;
signal H256_s			: std_logic;
signal H256_n			: std_logic;
signal H128			: std_logic;
signal H64			: std_logic;
signal H32			: std_logic;
signal H16			: std_logic;
signal H8			: std_logic;
signal H8_n			: std_logic;
signal H4			: std_logic;
signal H4_n			: std_logic;
signal H2			: std_logic;
signal H1			: std_logic;

signal Hsync			: std_logic;
signal Vsync			: std_logic;

signal Vcount  		        : std_logic_vector(7 downto 0) := (others => '0');
signal V128			: std_logic;
signal V64			: std_logic;
signal V32			: std_logic;
signal V16			: std_logic;
signal V8			: std_logic;
signal V4			: std_logic;
signal V2			: std_logic;
signal V1			: std_logic;

signal Vblank			: std_logic;
signal Vreset			: std_logic;
signal Vblank_s		        : std_logic;
signal Vblank_n_s		: std_logic;
signal HBlank			: std_logic;

signal CompBlank_s	        : std_logic;
signal CompSync_n_s	        : std_logic;

signal WhitePF_n		: std_logic;
signal BlackPF_n		: std_logic;

signal Display			: std_logic_vector(7 downto 0);


-- Address decoder
signal addec_bus		: std_logic_vector(7 downto 0);
signal RnW			: std_logic;
signal Write_n			: std_logic;
signal ROM1			: std_logic;
signal ROM2			: std_logic;
signal ROM3			: std_logic;
signal WRAM			: std_logic;
signal RAM_n			: std_logic;
signal Sync_n			: std_logic;
signal Switch_n		        : std_logic;

signal Display_n		: std_logic;
signal TimerReset_n	        : std_logic;

signal Attract			: std_logic := '0';	
signal Tumble 			: std_logic := '0';

signal Lamp1			: std_logic;
signal Lamp2			: std_logic;

signal NMI_n			: std_logic;
signal Adr			: std_logic_vector(9 downto 0);
signal SW1			: std_logic_vector(3 downto 0);
signal Inputs			: std_logic_vector(1 downto 0);

-- logic to load roms from disk
signal rom3_cs   			: std_logic;
signal rom4_cs   			: std_logic;
signal rom_32_cs   		: std_logic;
signal rom_LSB_cs			: std_logic;
signal rom_MSB_cs			: std_logic;

begin
-- Configuration DIP switches, these can be brought out to external switches if desired
-- See dominos 2 manual page 11 for complete information. Active low (0 = On, 1 = Off)
--    1 	2							Points to win		(00 - 3, 01 - 4, 10 - 5, 11 - 6)
--   			3	4					Game Cost		(10 - 1 Coin per player) 
--					5	6	7	8	Unused				

SW1 <= SW1_I; -- "1010"; -- Config dip switches 1-4


--7352-02.d1	2048	0		 00 0000 0000 0000
--7438-02.e1	2048	2048	 00 1000 0000 0000
--7439-01.p4	512	4096	 01 0000 0000 0000  -- lsb
--7440-01.r4	512	4608	 01 0010 0000 0000  -- msb
--6400-01.m2	256	5120	 01 0100 0000 0000
--6401-01.e2	32	5376		 01 0101 0000 0000

rom3_cs <= '1' when dn_addr(12 downto 11) = "00"     else '0';
rom4_cs <= '1' when dn_addr(12 downto 11) = "01"     else '0';
rom_32_cs <= '1' when dn_addr(12 downto 11) = "10"     else '0';
rom_LSB_cs <= '1' when dn_addr(12 downto 9) =  "1000"   else '0';
rom_MSB_cs <= '1' when dn_addr(12 downto 9) =  "1001"   else '0';

		
Vid_sync: entity work.synchronizer
port map(
		clk_12 => clk_12,
		clk_6 => clk_6,
		hcount => hcount,
		vcount => vcount,
		hsync => hsync,
		hblank => hblank,
		vblank_s => vblank_s,
		vblank_n_s => vblank_n_s,
		vblank => vblank,
		vsync => vsync,
		vreset => vreset
		);


Background: entity work.playfield
port map( 
		clk6 => clk_6,
		clk12 => clk_12,
		display => display,
		HCount => HCount,
		VCount => VCount,
		HBlank => HBlank,		
		H256_s => H256_s,
		VBlank => VBlank,
		VBlank_n_s => Vblank_n_s,
		HSync => Hsync,
		VSync => VSync,
		CompSync_n_s => CompSync_n_s,
		CompBlank_s => CompBlank_s,
		WhitePF_n => WhitePF_n,
		BlackPF_n => BlackPF_n,

		dn_wr => dn_wr,
		dn_addr=>dn_addr,
		dn_data=>dn_data,
		
		rom_LSB_cs=>rom_LSB_cs,
		rom_MSB_cs=>rom_MSB_cs
		);

		
CPU: entity work.cpu_mem
port map(
		Clk12 => clk_12,
		Clk6 => clk_6,
		Reset_I => Reset_I,
		Reset_n => reset_n,
		VCount => VCount,
		HCount => HCount,
		Hsync_n => not Hsync,
		Vblank_s => Vblank_s,
		Vreset => Vreset,
		Test_n => not Test_I,
		Attract => Attract,
		Tumble => Tumble,
		Lamp1 => Lamp1_O,
		Lamp2 => Lamp2_O,
		Phi1_o => Phi1,
		Phi2_o => Phi2,
		Display => Display,
		IO_Adr => Adr,
		Inputs => Inputs,
		
		dn_wr => dn_wr,
		dn_addr=>dn_addr,
		dn_data=>dn_data,
		
		rom3_cs=>rom3_cs,
		rom4_cs=>rom4_cs,
		rom_32_cs=>rom_32_cs

		);


Input: entity work.Control_Inputs
port map(
		SW1 => SW1 & "0000", -- DIP switches
		Coin1_n => Coin1_I,
		Coin2_n => Coin2_I,
		Start1 => not Start1_I, -- Inputs are active-high in real hardware, inverting these makes more sense with the FPGA
		Start2 => not Start2_I,
		Left1 => not Left1,
		Up1 => not Up1,
		Right1 => not Right1,
		Down1 => not Down1,
		Left2	=> not Left2,
		Right2 => not Right2,
		Up2 => not Up2,
		Down2 => not Down2,
		Self_test => not Test_I,
		Adr => Adr,
		Inputs => Inputs
	);	

	
Sound: entity work.audio
port map( 
		Clk_50 => Clk_50_I,
		Clk_6 => Clk_6,
		Reset_n => Reset_n,
		Attract => Attract,
		Tumble => Tumble,
		Display => Display,
		HCount => HCount,
		VCount => VCount,
		Audio_pwm => Audio_O
		);

-- Video mixing	
VideoB_O <= (not BlackPF_n) nor CompBlank_s;	
VideoW_O <= (not WhitePF_n);  
Sync_O <= CompSync_n_s;
hs_O<= hsync;
hblank_O <= HBlank;
vblank_O <= VBlank;
vs_O <=vsync;
clk_6_O<=clk_6;	
end rtl;
