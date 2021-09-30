## This file is the .xdc for EE 108 Lab 0 on the PYNQ-Z2 board 
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal 125 MHz

#set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { sysclk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
#create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { sysclk }];

##Switches

#set_property -dict { PACKAGE_PIN M20   IOSTANDARD LVCMOS33 } [get_ports { sw0 }]; #IO_L7N_T1_AD2N_35 Sch=sw[0]
#set_property -dict { PACKAGE_PIN M19   IOSTANDARD LVCMOS33 } [get_ports { sw1 }]; #IO_L7P_T1_AD2P_35 Sch=sw[1]

##LEDs

set_property -dict { PACKAGE_PIN R14   IOSTANDARD LVCMOS33 } [get_ports { out[0] }]; #IO_L6N_T0_VREF_34 Sch=led[0]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { out[1] }]; #IO_L6P_T0_34 Sch=led[1]
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { out[2] }]; #IO_L21N_T3_DQS_AD14N_35 Sch=led[2]
set_property -dict { PACKAGE_PIN M14   IOSTANDARD LVCMOS33 } [get_ports { out[3] }]; #IO_L23P_T3_35 Sch=led[3]

##Buttons

set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { right_pushbutton }]; #IO_L4P_T0_35 Sch=btn[0]
#set_property -dict { PACKAGE_PIN D20   IOSTANDARD LVCMOS33 } [get_ports { btn[1] }]; #IO_L4N_T0_35 Sch=btn[1]
#set_property -dict { PACKAGE_PIN L20   IOSTANDARD LVCMOS33 } [get_ports { btn[2] }]; #IO_L9N_T1_DQS_AD3N_35 Sch=btn[2]
set_property -dict { PACKAGE_PIN L19   IOSTANDARD LVCMOS33 } [get_ports { left_pushbutton }]; #IO_L9P_T1_DQS_AD3P_35 Sch=btn[3]


## Switches maps to SWA (sw[0]) to SWH (sw[7])
set_property PACKAGE_PIN V6 [get_ports {B[0]}];	#RPIO_14_R, connector Pin 8, FPGA Signal name RP_IO02				
	set_property IOSTANDARD LVCMOS33 [get_ports {B[0]}]
set_property PACKAGE_PIN Y6 [get_ports {B[1]}];	#RPIO_15_R, connector Pin 10, FPGA Signal name RP_IO10					
	set_property IOSTANDARD LVCMOS33 [get_ports {B[1]}]
set_property PACKAGE_PIN B19 [get_ports {B[2]}];	#RPIO_16_R, connector Pin 36, FPGA Signal name RP_IO20					
	set_property IOSTANDARD LVCMOS33 [get_ports {B[2]}]
set_property PACKAGE_PIN U7 [get_ports {B[3]}];	#RPIO_17_R, connector Pin 11, FPGA Signal name RP_IO03					
	set_property IOSTANDARD LVCMOS33 [get_ports {B[3]}]
set_property PACKAGE_PIN C20 [get_ports {A[0]}];	#RPIO_18_R, connector Pin 12, FPGA Signal name RP_IO18					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[0]}]
set_property PACKAGE_PIN Y8 [get_ports {A[1]}];	#RPIO_19_R, connector Pin 35, FPGA Signal name RP_IO13					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[1]}]
set_property PACKAGE_PIN A20 [get_ports {A[2]}];	#RPIO_20_R, connector Pin 38, FPGA Signal name RP_IO21					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[2]}]
set_property PACKAGE_PIN W9 [get_ports {A[3]}];	#RPIO_26_R, connector Pin 37, FPGA Signal name RP_IO14					
	set_property IOSTANDARD LVCMOS33 [get_ports {A[3]}]

#set_property PACKAGE_PIN M20 [get_ports {enable}];   #Board SW0					
#	set_property IOSTANDARD LVCMOS33 [get_ports {enable}]
 
