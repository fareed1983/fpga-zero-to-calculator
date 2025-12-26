module ha
	(
		input wire a, b,
		output wire carry, sum
	);
	
	assign carry = a & b;
	assign sum = a ^ b;
	
endmodule