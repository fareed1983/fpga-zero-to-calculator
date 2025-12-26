module bin2ssd #(
		parameter INVERT = 1'b0
	)(
		input wire[3:0] b, // bcd in
		input wire bi, // ripple blanking
		output wire[6:0] s, // ssd
		output wire bo, // ripple blanking output
		input wire mi, // display minus
		input wire rz, // if right digit is zero, don't display minus here
		output wire zo, // is this digit zero? (used by left digit)
		output wire mo // ripple minus if not consumed to avoid negative sign instead of 0 in middle of number
	);
	
	wire[6:0] seg;
	assign zo = (b == 4'h0);
	assign bo = (zo & bi);
	assign consume_minus = (mi & !rz & zo);
	assign mo = (mi & !consume_minus);
	
	assign seg =  (consume_minus ? 7'b1000000:
					 (((b == 4'h0) ? 7'b0111111 :
						(b == 4'h1) ? 7'b0000110 :
						(b == 4'h2) ? 7'b1011011 :
						(b == 4'h3) ? 7'b1001111 :
						(b == 4'h4) ? 7'b1100110 :
						(b == 4'h5) ? 7'b1101101 :
						(b == 4'h6) ? 7'b1111101 :
						(b == 4'h7) ? 7'b0000111 :
						(b == 4'h8) ? 7'b1111111 :
						(b == 4'h9) ? 7'b1101111 :
						(b == 4'hA) ? 7'b1110111 :
						(b == 4'hB) ? 7'b1111100 :
						(b == 4'hC) ? 7'b0111001 :
						(b == 4'hD) ? 7'b1011110 :
						(b == 4'hE) ? 7'b1111001 :
										  7'b1110001) 
						& {7{!bo}})) ;
										  
	assign s = INVERT ? seg ^ 7'b1111111 : seg;
	
endmodule
