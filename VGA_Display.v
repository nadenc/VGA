`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// VGA_Display
//
// Display Spec: 1680 x 1050 @ 60Hz
// 
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////START OF CODE/////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Define module I/O

module VGA_Display(
input CLK_100M				,
//input [29:0] img_data	, // [ 11bits hpix 11bits vpix 8 bits rgb] ????
output reg hsync_pin		,
output reg vsync_pin		,
output [2:0] red		,
output [2:0] green	,
output [2:1] blue			
);


	// Define registers/variables

	reg scroll_refresh;
	reg [31:0] div_scroll;
	reg clk_scroll_rst;
	
	reg hdisp_flag; // end of horizontal display flag
	reg vdisp_flag; // end of vertical display flag

	wire [7:0] rgb; // 8 colour combinations [R2 R1 R0 G2 G1 G0 B2 B1]
	
	assign red[2:0] = rgb[7:5];
	assign green[2:0] = rgb[4:2];
	assign blue[2:1] = rgb[1:0];
	
	reg [11:0] hpos; // total bit coordinates
	reg [10:0] vpos;
	
	reg [10:0] hpix; // display pixel coordinates
	reg [10:0] vpix;

	// frame timings
	localparam hpixel 	= 11'd1680;
	localparam hfporch 	= 7'd82;
	localparam hsync 		= 8'd184;
	localparam hbporch 	= 9'd288;
	
	localparam vpixel 	= 11'd1050;
	localparam vfporch 	= 4'd1;
	localparam vsync 		= 2'd3;
	localparam vbporch 	= 6'd30;


// Define model instanstantiations

// generate 146.66MHz pixel clock
VGA_Clocks m1(
	.CLK_IN1(CLK_100M),
	.CLK_OUT1(clk_pixel) 
);

// generate clock for test pattern
clk_div m2(
	.clk_in(clk_pixel),
	.rst(clk_scroll_rst),
	.div(div_scroll),
	.clk_out(clk_scroll)
);

// generate colour test pattern
scroll_colour m3( 
	.pixel_clk(clk_pixel),
	.refresh(scroll_refresh),
	.scroll_clk(clk_scroll),
	.tru_8_bit(rgb)
);


// Initial presets

initial begin
	hsync_pin <= 1'b1;
	vsync_pin <= 1'b0;
	hpos <= 12'b0;
	vpos <= 11'b0;
	
	scroll_refresh <= 1'b1;
	div_scroll <= 32'd0;
end


// Protocol padding, handles syncs, porches and sets display flags

always @ (posedge clk_pixel) begin // protocol here...
	hpos <= (hpos + 12'b1);
	if (hpos == 0) begin // hsync
		hsync_pin <= 1'b0;
	end else if (hpos == (hsync)) begin // hbporch
		hsync_pin <= 1'b1;
	end else if (hpos == (hbporch + hsync)) begin
		hdisp_flag <= 1'b1;
	end else if (hpos == (hpixel + hbporch + hsync)) begin
		hdisp_flag <= 1'b0;
	end else if (hpos == (hfporch + hpixel + hbporch + hsync)) begin // end of horizontal
		hpos <= 12'b0;
		if (vpos == (vfporch + vpixel + vbporch + vsync)) begin // reset at last pixel
			vpos <= 11'b0;
		end else begin
			vpos <= (vpos + 11'b1);
		end
	end
	
	if (vpos == 0) begin // vsync
		vsync_pin <= 1'b1;
	end else if (vpos == (vsync)) begin // vbporch
		vsync_pin <= 1'b0;
	end else if (vpos == (vbporch + vsync)) begin
		vdisp_flag <= 1'b1;
	end else if (vpos == (vpixel + vbporch + vsync)) begin
		vdisp_flag <= 1'b0;
	end
end


// Enables during display frame flags, in reset mode for to keep counter rest while not in frame

always @ (posedge clk_pixel) begin // Enable display graphics here..
	if ((hdisp_flag == 1) && (vdisp_flag == 1)) begin
		clk_scroll_rst <= 1'b0;
		scroll_refresh <= 1'b0;
	end else begin
		clk_scroll_rst <= 1'b1;
		scroll_refresh <= 1'b1; // keep scroller in refresh mode
	end
end 

endmodule


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////END OF CODE///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


/* Test Pattern
	if ((vpos >= (vbporch + vsync)) && (vpos <= (vpixel + vbporch + vsync - 525))) begin
		if (hpos == (hbporch + hsync)) begin
			rgb <= 8'b01001001;
		end else if (hpos == (hbporch + hsync + 240)) begin
			rgb <= 8'b01001000;
		end else if (hpos == (hbporch + hsync + 480)) begin
			rgb <= 8'b01000001;
		end else if (hpos == (hbporch + hsync + 720)) begin
			rgb <= 8'b01000000;
		end else if (hpos == (hbporch + hsync + 960)) begin
			rgb <= 8'b00001001;
		end else if (hpos == (hbporch + hsync + 1200)) begin
			rgb <= 8'b00001000;
		end else if (hpos == (hbporch + hsync + 1440)) begin
			rgb <= 8'b00000001;
		end else if (hpos == (hpixel + hbporch + hsync)) begin
			rgb <= 8'b00000000;
		end
	end

	if ((vpos >= (vbporch + vsync + 525)) && (vpos <= (vpixel + vbporch + vsync))) begin
		if (hpos == (hbporch + hsync)) begin
			rgb <= 8'b00000000;
		end else if (hpos == (hbporch + hsync + 240)) begin
			rgb <= 8'b00000010;
		end else if (hpos == (hbporch + hsync + 480)) begin
			rgb <= 8'b00010000;
		end else if (hpos == (hbporch + hsync + 720)) begin
			rgb <= 8'b00010010;
		end else if (hpos == (hbporch + hsync + 960)) begin
			rgb <= 8'b10000000;
		end else if (hpos == (hbporch + hsync + 1200)) begin
			rgb <= 8'b10000010;
		end else if (hpos == (hbporch + hsync + 1440)) begin
			rgb <= 8'b10010000;
		end else if (hpos == (hpixel + hbporch + hsync)) begin
			rgb <= 8'b00000000;
		end
	end
*/
