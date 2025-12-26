module fa
	(
		input wire a, b, c,
		output wire sum, carry
	);
	
	assign carry = (a & b) | (a & c) | (b & c);
	assign sum = a ^ b ^c;

endmodule
