module as2c
	(
		input wire[3:0] a, b,
		input wire sub,
		output wire [3:0] sum,
		output wire overflow
	);
	
	wire [3:0] c;
	wire[3:0] bn;
	assign bn = b ^ {4{sub}};
	
	fa fa0 (.a(a[0]), .b(bn[0]), .c(sub), 	.sum(sum[0]), .carry(c[0]));
	fa fa1 (.a(a[1]), .b(bn[1]), .c(c[0]),	.sum(sum[1]), .carry(c[1]));
	fa fa2 (.a(a[2]), .b(bn[2]), .c(c[1]),	.sum(sum[2]), .carry(c[2]));
	fa fa3 (.a(a[3]), .b(bn[3]), .c(c[2]),	.sum(sum[3]), .carry(c[3]));
	
	assign overflow = c[2] ^ c[3];
	
endmodule
