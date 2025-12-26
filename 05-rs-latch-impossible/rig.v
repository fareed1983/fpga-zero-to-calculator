module rig
	(
		input wire[0:1] KEY,
		output wire[0:1] LEDG
	);
	
	rs rs0 (.r(KEY[0]), .s(KEY[1]), .q(LEDG[0]), .qbar(LEDG[1]));
	
endmodule
	