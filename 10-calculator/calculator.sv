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
	
	wire[3:0] dec_curr_digit, curr_oper; 	// Outputs of keypad module
	wire[3:0] result_dec[2:0]; 				// Result of computation
	reg[3:0] dec_digits[2:0], 					// Current displayed value in BCD
				dec_curr_digit_latched = 0, 	// New digit latched while shifting left
				curr_oper_latched= 0;			// Operator latched when second operand entered
	wire dec_digits_negative;					//	Is the dec_digits negative
	reg[2:0] dec_idx = 0, 						// Index of input cursor
				shift_iter;							// Used for shifting left
	reg[9:0] operand1, result;					// The 1st operand and result of calculation in binary
	reg[0:0] disp_result;						// Next cycle will display 'result' on dec_digits
	wire released;									// Released trigger from keypad module
	reg[3:0] key_rel;								// Push button's (KEYs) debounced released trigger

	// Wire-up the keypad
	keypad kp (
		.digits(dec_curr_digit), 
		.opers(curr_oper),
		.pressed(LEDG[7]),
		.released(released),
		.rows(ROWS[3:0]),
		.cols(COLS[3:0]),
		.clk(CLOCK_50)
	);
	
	// Iterate generation of four debounced pushbtns
	genvar i;
	generate
		for (i = 0; i < 4; i = i + 1) begin: btn_gen
			pushbtn #(.INVERT(1)) btn(.clk(CLOCK_50), .button(KEY[i]), .released(key_rel[i]));
		end
	endgenerate
	
	// LEDG displays the current_oper latched
	assign LEDG[3:0] = curr_oper_latched;
	
	always @(posedge CLOCK_50) begin
		// If shifting in progress
		if (shift_iter) begin
			if (shift_iter == 1) begin // On the last shift iter
				// Set the last digit to the latched
				dec_digits[0] <= dec_curr_digit_latched; 
				dec_idx <= dec_idx + 1;
				shift_iter <= 0;
			end else begin // Shift a digit left
				dec_digits[shift_iter - 1] <= dec_digits[shift_iter - 2];
				shift_iter <= shift_iter - 1;
			end
		end else if (disp_result) begin
			// If computation was done and result has to be displayed
			dec_digits[0] <= result_dec[0];
			dec_digits[1] <= result_dec[1];
			dec_digits[2] <= result_dec[2];
			dec_digits_negative <= result[9];
			disp_result <= 0;
		end
		
		if (key_rel[0]) begin	// = key pressed
			if (curr_oper_latched == 3'd1) begin
				result <= operand1 + LEDR;
				disp_result <= 1; // result will be displayed on the next clock
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
		end else if (key_rel[1]) begin // AC - reset
			dec_digits[0] <= 0;
			dec_digits[1] <= 0;
			dec_digits[2] <= 0;
			
			dec_idx <= 0;
		end else if (released) begin // If keypad key was released
			// Below checks if applicable digit was pressed (as no curr_oper was pressed)
			if (!curr_oper && ((dec_idx == 0 && dec_curr_digit != 0) || dec_idx == 1 || dec_idx == 2)) begin
				if (dec_idx == 0 && curr_oper_latched) begin // first digit after oper button pressed
					dec_digits[0] <= 0;
					dec_digits[1] <= 0;
					dec_digits[2] <= 0;
					dec_digits_negative <= 0;
				end
			
				dec_curr_digit_latched <= dec_curr_digit;
				shift_iter <= dec_idx + 1;
			end else if (curr_oper) begin // An oper key was pressed
				if (curr_oper == 3'd6) begin	// Negate number
					dec_digits_negative <= !dec_digits_negative;
				end else begin // All other operations
					curr_oper_latched <= curr_oper;
					dec_idx <= 0;
					operand1 <= LEDR; // Store the current binary value as operand1
				end
			end // curr_oper
		end // released
		
	end
	
	wire rbo;
	wire[2:0] z;	// If left digit is 0
	wire[1:0] m;	// Ripple display negative sign
	
	bin2ssd #(.INVERT(1)) bs3 (.b(), .mi(dec_digits_negative), .s(HEX3), .bi(1), .rz(z[2]), .mo(m[1]));		// use this only for negative sign
	bin2ssd #(.INVERT(1)) bs2 (.b(dec_digits[2]), .mi(m[1]), .s(HEX2), .bi(1), .bo(rbo), .rz(z[1]), .zo(z[2]), .mo(m[0]));
	bin2ssd #(.INVERT(1)) bs1 (.b(dec_digits[1]), .mi(m[0]), .s(HEX1), .bi(rbo), .rz(z[0]), .zo(z[1]));
	bin2ssd #(.INVERT(1)) bs0 (.b(dec_digits[0]), .s(HEX0), .bi(0), .zo(z[0]));
	
	// The dec_digits are converted to binary and stored in LEDR ready for operations
	dec2bin db (.bcds(dec_digits), .negative(dec_digits_negative), .bin2c(LEDR));
	
	// result is kept ready in bcd form to set into the dec_digits when disp_result is high on a clock positive-edge
	bin2dec bd (.bcds(result_dec), .bin2c(result));

endmodule
