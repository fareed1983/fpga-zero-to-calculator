module bin2ssd #(
		parameter INVERT = 1'b0
	)(
		input wire[3:0] b,
		output wire[6:0] s
	);
	
	wire[6:0] seg;
	assign seg =(b == 4'h0) ? 7'b0111111 :
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
									  7'b1110001 ;
	
	assign s = INVERT ? seg ^ 7'b1111111 : seg;
	
	
endmodule
