module pushbtn #(
		parameter INVERT = 1'b0
	)(
		input wire clk,
		input wire button,
		output reg released,
		output reg pressed
	);
	
	reg[31:0] count = 0;	
	reg[1:0] state = 0;
	reg[2:0] press_iter = 0;
	reg[2:0] rel_iter = 0;

	initial begin
		pressed <= 0;
		released <= 0;
		count <= 0;
		press_iter <= 0;
		rel_iter <= 0;
	end
	
	always @(posedge clk) begin
		if (count == 0) begin
			count <= 32'd49_999;
			if (pressed) begin
				pressed <= 0;
			end else if (released) begin
				released <= 0;
				rel_iter <= 0;
				press_iter <= 0;
			end else if ((button & !INVERT) || (!button & INVERT)) begin
				rel_iter <= 0;
				
				if (press_iter == 4'd6) begin
					pressed <= 1;
					count <= 0;
					press_iter <= 4'd7;
				end else if (!(press_iter == 4'd7)) press_iter <= press_iter + 1;
			end else begin // button not down
				
				if (press_iter == 4'd7 && rel_iter == 4'd6) begin
					rel_iter <= 4'd7;
					count <= 0;
					released <= 1;
				end else if (!(rel_iter == 4'd7) && press_iter == 4'd7) rel_iter <= rel_iter + 1;
			end
		end else begin
			count <= count - 1;
		end
	end
	
endmodule
