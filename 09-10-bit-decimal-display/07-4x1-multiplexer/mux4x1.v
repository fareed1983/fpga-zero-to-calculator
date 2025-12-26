module mux4x1
	(
		input wire[3:0] i,
		input wire [1:0] s,
		output wire y
	);
	
	wire[3:0] a;
	wire [1:0] ns = ~s;
	
	assign a[0] = i[0] & ns[1] & ns[0];
	assign a[1] = i[1] & ns[1] &  s[0];
	assign a[2] = i[2] &  s[1] & ns[0];
	assign a[3] = i[3] &  s[1] &  s[0];
	
	assign y = a[0] | a[1] | a[2] | a[3];
	
endmodule
