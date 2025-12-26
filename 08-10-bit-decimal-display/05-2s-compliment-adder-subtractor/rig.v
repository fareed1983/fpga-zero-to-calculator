module rig
	(
		input wire[8:0] SW,
		output wire[3:0] LEDG,
		output wire[0:0] LEDR
	);
	
	as2c as2c0 (.a(SW[3:0]), .b(SW[8:5]), .sub(SW[4]), .sum(LEDG[3:0]), .overflow(LEDR[0]));
	
endmodule
