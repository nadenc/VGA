`timescale 1ns / 1ps

module VGA_TESTBENCH;

	// Inputs
	reg CLK_100M;

	// Outputs
	wire hsync_pin;
	wire vsync_pin;
	wire [2:0] red;
	wire [2:0] green;
	wire [2:1] blue;

	// Instantiate the Unit Under Test (UUT)
	VGA_Display uut (
		.CLK_100M(CLK_100M), 
		.hsync_pin(hsync_pin), 
		.vsync_pin(vsync_pin), 
		.red(red), 
		.green(green), 
		.blue(blue)
	);

	initial begin
		// Initialize Inputs
		//CLK_100M = 0;

		// Wait 100 ns for global reset to finish
		//#100;
        
		// Add stimulus here
		
	end
      
	always begin
		#1 CLK_100M = ~CLK_100M;
	end
	
endmodule

