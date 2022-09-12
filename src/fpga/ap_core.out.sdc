## Generated SDC file "ap_core.out.sdc"

## Copyright (C) 2022  Intel Corporation. All rights reserved.
## Your use of Intel Corporation's design tools, logic functions 
## and other software and tools, and any partner logic 
## functions, and any output files from any of the foregoing 
## (including device programming or simulation files), and any 
## associated documentation or information are expressly subject 
## to the terms and conditions of the Intel Program License 
## Subscription Agreement, the Intel Quartus Prime License Agreement,
## the Intel FPGA IP License Agreement, or other applicable license
## agreement, including, without limitation, that your use is for
## the sole purpose of programming logic devices manufactured by
## Intel and sold by Intel or its authorized distributors.  Please
## refer to the applicable agreement for further details, at
## https://fpgasoftware.intel.com/eula.


## VENDOR  "Altera"
## PROGRAM "Quartus Prime"
## VERSION "Version 21.1.1 Build 850 06/23/2022 SJ Lite Edition"

## DATE    "Tue Sep 13 13:20:17 2022"

##
## DEVICE  "5CEBA4F23C8"
##


#**************************************************************
# Time Information
#**************************************************************

set_time_format -unit ns -decimal_places 3



#**************************************************************
# Create Clock
#**************************************************************

create_clock -name {clk_74a} -period 13.468 -waveform { 0.000 6.734 } [get_ports {clk_74a}]
create_clock -name {clk_74b} -period 13.468 -waveform { 0.000 6.734 } [get_ports {clk_74b}]
create_clock -name {bridge_spiclk} -period 13.468 -waveform { 0.000 6.734 } [get_ports {bridge_spiclk}]


#**************************************************************
# Create Generated Clock
#**************************************************************

create_generated_clock -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} -source [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|refclkin}] -duty_cycle 50/1 -multiply_by 48 -divide_by 11 -master_clock {clk_74a} [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]}] 
create_generated_clock -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 27 -master_clock {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] 
create_generated_clock -name {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk} -source [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|vco0ph[0]}] -duty_cycle 50/1 -multiply_by 1 -divide_by 27 -phase 7499880/83333 -master_clock {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~FRACTIONAL_PLL|vcoph[0]} [get_pins {ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk}] 


#**************************************************************
# Set Clock Latency
#**************************************************************



#**************************************************************
# Set Clock Uncertainty
#**************************************************************

set_clock_uncertainty -rise_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.160  
set_clock_uncertainty -rise_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -rise_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -setup 0.160  
set_clock_uncertainty -fall_from [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -fall_to [get_clocks {ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -rise_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -rise_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -setup 0.280  
set_clock_uncertainty -fall_from [get_clocks {clk_74a}] -fall_to [get_clocks {clk_74a}] -hold 0.270  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -rise_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -rise_to [get_clocks {bridge_spiclk}] -hold 0.060  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -setup 0.100  
set_clock_uncertainty -fall_from [get_clocks {bridge_spiclk}] -fall_to [get_clocks {bridge_spiclk}] -hold 0.060  


#**************************************************************
# Set Input Delay
#**************************************************************



#**************************************************************
# Set Output Delay
#**************************************************************



#**************************************************************
# Set Clock Groups
#**************************************************************

set_clock_groups -asynchronous -group [get_clocks { bridge_spiclk }] -group [get_clocks { clk_74a }] -group [get_clocks { clk_74b }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk }] 
set_clock_groups -asynchronous -group [get_clocks { bridge_spiclk }] -group [get_clocks { clk_74a }] -group [get_clocks { clk_74b }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[0].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[1].gpll~PLL_OUTPUT_COUNTER|divclk }] -group [get_clocks { ic|mp1|mf_pllbase_inst|altera_pll_i|general[2].gpll~PLL_OUTPUT_COUNTER|divclk }] 


#**************************************************************
# Set False Path
#**************************************************************



#**************************************************************
# Set Multicycle Path
#**************************************************************



#**************************************************************
# Set Maximum Delay
#**************************************************************



#**************************************************************
# Set Minimum Delay
#**************************************************************



#**************************************************************
# Set Input Transition
#**************************************************************

