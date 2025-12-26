module ha
	(
		input wire a, b,
		output wire c, s
	);
	
	assign c = a & b;
	assign s = a ^ b;
	
endmodule