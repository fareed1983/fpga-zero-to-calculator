module tst
	(
		input wire[0:2] SW,
		output wire[0:1] LEDR
	);
	
	fa fa1 (.a(SW[0]), .b(SW[1]), .c(SW[2]), .sum(LEDR[0]), .carry(LEDR[1]));
	
endmodule