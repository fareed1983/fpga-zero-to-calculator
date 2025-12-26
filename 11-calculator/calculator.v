module calculator
	(
		output wire[3:0] ROWS,
		input wire[3:0] COLS,
		output wire[9:0] LEDR,
		output wire[7:0] LEDG,
		output wire[6:0] HEX0, HEX1, HEX2, HEX3,
		input wire CLOCK_50
	);
	
	wire[3:0] dec_curr_digit, curr_oper;
	reg[3:0] dec_digits[3:0], dec_curr_digit_latched = 0, curr_oper_latched= 0;
	reg[2:0] dec_idx = 0, shift_iter;

	wire released;
	wire dec_negative = 1'b0;
	
	keypad kp (
		.digits(dec_curr_digit), 
		.opers(curr_oper),
		.pressed(LEDG[7]),
		.released(released),
		.rows(ROWS[3:0]),
		.cols(COLS[3:0]),
		.clk(CLOCK_50)
	);
	
	assign LEDG[3:0] = curr_oper_latched;

	always @(posedge CLOCK_50) begin	
		if (shift_iter) begin
			if (shift_iter == 1) begin
				dec_digits[0] <= dec_curr_digit_latched;
				dec_idx <= dec_idx + 1;
				shift_iter <= 0;
			end else begin
				dec_digits[shift_iter - 1] <= dec_digits[shift_iter - 2];
				shift_iter <= shift_iter - 1;
			end
		end
		
		if (released == 1'b1) begin
			if (!curr_oper && ((dec_idx == 0 && dec_curr_digit != 0) || dec_idx == 1 || dec_idx == 2 || dec_idx == 3)) begin
				
				if (dec_idx == 0 && curr_oper_latched) begin // first digit after oper button pressed
					dec_digits[0] <= 0;
					dec_digits[1] <= 0;
					dec_digits[2] <= 0;
					dec_digits[3] <= 0;
				end
			
				dec_curr_digit_latched <= dec_curr_digit;
				shift_iter <= dec_idx + 1;
			end else if (curr_oper) begin

				
				if (curr_oper == 3'd5) begin
					dec_digits[0] <= 0;
					dec_digits[1] <= 0;
					dec_digits[2] <= 0;
					dec_digits[3] <= 0;
					
					dec_idx <= 0;
				end else begin
					curr_oper_latched <= curr_oper;
					dec_idx <= 0;
				end
			end // curr_oper
		end // released
		
	end
	/*
	assign LEDR[3:0] = dec_digits[0];
	assign LEDR[7:4] = dec_digits[1];
	assign LEDR[8] = released;*/
	
	bin2ssd #(.INVERT(1)) bs0 (.b(dec_digits[0]), .s(HEX0));
	bin2ssd #(.INVERT(1)) bs1 (.b(dec_digits[1]), .s(HEX1));
	bin2ssd #(.INVERT(1)) bs2 (.b(dec_digits[2]), .s(HEX2));
	bin2ssd #(.INVERT(1)) bs3 (.b(dec_digits[3]), .s(HEX3));
	
	dec2bin db (.bcds(dec_digits), .negative(), .bin(LEDR));

endmodule
