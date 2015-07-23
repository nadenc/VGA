//////////////////////////////////////////////////////////////////////////////////
// scroll colour
// 
//////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////START OF CODE/////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


// Define module I/O

module scroll_colour(
	input pixel_clk,
	input refresh,
	input scroll_clk,
	output [7:0] tru_8_bit
);


// Define registers/variables
	
	reg [2:0] scroll_pos;
	
	reg [8:0] buffer;
	reg [8:0] disp_out;
	
	reg scroll_rst_flag;
	
	assign tru_8_bit = disp_out[8:1];


// Initial presets

initial begin
	scroll_pos <= 3'b001;
	buffer <= 9'b0;
end
	

// Scroll through outputs at posedge of scroll clock

always @ (posedge scroll_clk) begin
	if (scroll_rst_flag == 1'b1) begin
		buffer <= 9'b1;
	end else begin
		/*if (buffer == 9'b100000000) begin
			buffer <= 9'b1;
		end else begin
			buffer <= buffer << 1;
		end*/
		buffer <= (buffer + 9'b1);
	end
end


// Refresh mode keeps the output low when refresh is activated

always @ (posedge pixel_clk) begin	
	if (refresh == 1'b1) begin
		disp_out <= 9'b0;
		scroll_rst_flag <= 1'b1;
	end else begin
		disp_out <= buffer;
		if (buffer == 9'b1) begin
			scroll_rst_flag <= 1'b0;
		end
	end
end

endmodule


////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////END OF CODE///////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////


/*

// Instantiation

scroll_colour(
	.refresh(),
	.scroll_clk(),
	.tru_8_bit()
);


// Type of scroll

always @ (posedge scroll_clk) begin

	if (scroll_pos == 3'b001) begin
		scroll_pos <= 3'b010;
	end else if (scroll_pos == 3'b010) begin
		scroll_pos <= 3'b100;
	end else if (scroll_pos == 3'b100) begin
		scroll_pos <= 3'b001;
	end
	
	case (scroll_pos)
		3'b001: begin
			if (buffer[8:6] == 3'b111) begin
				buffer[8:6] <= 3'b000;
			end else begin
				buffer[8:6] <= buffer[8:6] + 3'b1;
				//buffer[8:6] <= 3'b100;
			end
		end
		3'b010: begin
			if (buffer[5:3] == 3'b111) begin
				buffer[5:3] <= 3'b000;
			end else begin
				buffer[5:3] <= buffer[5:3] + 3'b1;
				//buffer[5:3] <= 3'b100;
			end
		end
		3'b100: begin
			if (buffer[2:0] == 3'b111) begin
				buffer[2:0] <= 3'b000;
			end else begin
				buffer[2:0] <= buffer[2:0] + 3'b1;
				//buffer[2:0] <= 3'b100;
			end
		end
	endcase
end
*/
