module ba
	(
		input wire[8:0] SW,
		output wire[4:0] LEDG
	);
	
	wire [3:0] carry;
	
	ha ha0 (.a(SW[0]), .b(SW[5]), .sum(LEDG[0]), .carry(carry[0]));
	fa fa1 (.a(SW[1]), .b(SW[6]), .c(carry[0]), .sum(LEDG[1]), .carry(carry[1]));
	fa fa2 (.a(SW[2]), .b(SW[7]), .c(carry[1]), .sum(LEDG[2]), .carry(carry[2]));
	fa fa3 (.a(SW[3]), .b(SW[8]), .c(carry[2]), .sum(LEDG[3]), .carry(LEDG[4]));
	
endmodule