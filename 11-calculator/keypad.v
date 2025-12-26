module keypad
	(
		input wire clk,
		output reg[3:0] rows, 
		input wire[3:0] cols,
		output reg pressed,
		output reg released,
		output reg[3:0] digits,
		output reg[3:0] opers
	);
	
	reg[1:0] state = 0;
	reg[31:0] count = 0;	
	reg[2:0] scan_row = 0;
	reg[0:0] detected = 0;
	
	initial begin	
		pressed <= 0;
		released <= 0;
		digits <= 0;
		opers <= 0;
		state <= 0;
		count <= 0;
		detected <= 0;
	end
	
	always @(posedge clk) begin
	
		if (count == 0) begin							
			count <= 32'd49_999;				// Sample at 1Khz
			case (state)

				
				0: begin
					if (scan_row == 4) begin
						state <= 2;
						scan_row <= 0;
					end else begin 
						state <= 1;
						released <= 0;
						case (scan_row)
							0: rows <= 4'b1110;
							1: rows <= 4'b1101;
							2: rows <= 4'b1011;
							3: rows <= 4'b0111;
							default: rows <= 4'b1111;
						endcase
					end
					
					count <= 0;
				end
				
				1: begin

					scan_row <= scan_row + 1;
					state <= 0;
					
					case (scan_row)
						0: begin
							if (~cols[0]) begin digits <= 4'd1; detected <= 1; end
							else if (~cols[1]) begin digits <= 4'd2; detected <= 1; end
							else if (~cols[2]) begin digits <= 4'd3; detected <= 1; end
							else if (~cols[3]) begin opers <= 3'd1; detected <= 1; end
						end
				
						1: begin
							if (~cols[0]) begin digits <= 4'd4; detected <= 1; end
							else if (~cols[1]) begin digits <= 4'd5; detected <= 1; end
							else if (~cols[2]) begin digits <= 4'd6; detected <= 1; end
							else if (~cols[3]) begin opers <= 3'd2; detected <= 1; end
						end
							
						2: begin
							if (~cols[0]) begin digits <= 4'd7; detected <= 1; end
							else if (~cols[1]) begin digits <= 4'd8; detected <= 1; end
							else if (~cols[2]) begin digits <= 4'd9; detected <= 1; end
							else if (~cols[3]) begin opers <= 3'd3; detected <= 1; end
						end
						
						3: begin
							if (~cols[1]) begin digits <= 4'd0; detected <= 1; end
							else if (~cols[3]) begin opers <= 3'd4; detected <= 1; end
							else if (~cols[0]) begin opers <= 3'd5; detected <= 1; end
							else if (~cols[2]) begin opers <= 3'd6; detected <= 1; end
						end
						
					endcase
					
				end
				
				2: begin
					
					if (detected) begin 
						pressed <= 1;
						detected <= 0;
						state <= 0;
					end else begin
						if (pressed) begin
							released <= 1;
							state <= 3;
							pressed <= 0;
						end else state <= 0;
					end
					
					count <= 0;
				end
				
				3: begin
					released <= 0;
					digits <= 0;
					opers <= 0;
					state <= 0;
					count <= 0;
				end
				
			endcase
			
		end else begin
			count <= count - 1;
		end

	end
	
		
endmodule
