module tst
	(
		input wire[1:0] SW,
		output wire[1:0] LEDR
	);
	
	ha ha1 (.a(SW[0]), .b(SW[1]), .s(LEDR[0]), .c(LEDR[1]));
	
endmodule