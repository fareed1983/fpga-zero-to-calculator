module calculator
	(
		output wire[3:0] ROWS,
		input wire[3:0] COLS,
		output wire[9:0] LEDR,
		output wire[7:0] LEDG,
		output wire[6:0] HEX0, HEX1, HEX2, HEX3,
		input wire[3:0] KEY,
		input wire CLOCK_50
	);
	
	wire[3:0] dec_curr_digit, curr_oper;
	wire[3:0] result_dec[2:0];
	reg[3:0] dec_digits[2:0], dec_curr_digit_latched = 0, curr_oper_latched= 0;
	wire dec_digits_negative;
	reg[2:0] dec_idx = 0, shift_iter;
	reg[9:0] operand1, result;
	reg[0:0] disp_result;

	wire released;
	
	keypad kp (
		.digits(dec_curr_digit), 
		.opers(curr_oper),
		.pressed(LEDG[7]),
		.released(released),
		.rows(ROWS[3:0]),
		.cols(COLS[3:0]),
		.clk(CLOCK_50)
	);
	
	reg[3:0] key_rel;
	
	genvar i;
	generate
		for (i = 0; i < 4; i = i + 1) begin: btn_gen
			pushbtn #(.INVERT(1)) btn(.clk(CLOCK_50), .button(KEY[i]), .released(key_rel[i]));
		end
	endgenerate
	
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
		end else if (disp_result) begin
			dec_digits[0] <= result_dec[0];
			dec_digits[1] <= result_dec[1];
			dec_digits[2] <= result_dec[2];
			dec_digits_negative <= result[9];
			disp_result <= 0;
		end
		
		if (key_rel[0]) begin
			if (curr_oper_latched == 3'd1) begin
				result <= operand1 + LEDR;
				disp_result <= 1;
			end else if (curr_oper_latched == 3'd2) begin
				result <= operand1 - LEDR;
				disp_result <= 1;
			end if (curr_oper_latched == 3'd3) begin
				result <= operand1 * LEDR;
				disp_result <= 1;
			end else if (curr_oper_latched == 3'd4) begin
				result <= operand1 / LEDR;
				disp_result <= 1;
			end
		end else if (key_rel[1]) begin
			dec_digits[0] <= 0;
			dec_digits[1] <= 0;
			dec_digits[2] <= 0;
			
			dec_idx <= 0;
		end else if (released) begin
			if (!curr_oper && ((dec_idx == 0 && dec_curr_digit != 0) || dec_idx == 1 || dec_idx == 2)) begin
				
				if (dec_idx == 0 && curr_oper_latched) begin // first digit after oper button pressed
					dec_digits[0] <= 0;
					dec_digits[1] <= 0;
					dec_digits[2] <= 0;
					dec_digits_negative <= 0;
				end
			
				dec_curr_digit_latched <= dec_curr_digit;
				shift_iter <= dec_idx + 1;
			end else if (curr_oper) begin
				if (curr_oper == 3'd6) begin
					dec_digits_negative <= !dec_digits_negative;
				end else begin
					curr_oper_latched <= curr_oper;
					dec_idx <= 0;
					operand1 <= LEDR;
				end
			end // curr_oper
		end // released
		
	end
	
	wire rbo;
	wire[2:0] z;
	wire[1:0] m;
	
	bin2ssd #(.INVERT(1)) bs3 (.b(), .mi(dec_digits_negative), .s(HEX3), .bi(1), .rz(z[2]), .mo(m[1]));		// use this only for negative sign
	bin2ssd #(.INVERT(1)) bs2 (.b(dec_digits[2]), .mi(m[1]), .s(HEX2), .bi(1), .bo(rbo), .rz(z[1]), .zo(z[2]), .mo(m[0]));
	bin2ssd #(.INVERT(1)) bs1 (.b(dec_digits[1]), .mi(m[0]), .s(HEX1), .bi(rbo), .rz(z[0]), .zo(z[1]));
	bin2ssd #(.INVERT(1)) bs0 (.b(dec_digits[0]), .s(HEX0), .bi(0), .zo(z[0]));
	
	dec2bin db (.bcds(dec_digits), .negative(dec_digits_negative), .bin2c(LEDR));
	bin2dec bd (.bcds(result_dec), .bin2c(result));

endmodule
