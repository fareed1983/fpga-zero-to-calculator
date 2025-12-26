module rig
	(
		input wire[1:0] SW,
		input wire[3:0] KEY,
		output wire[0:0] LEDR
	);
		
	wire [3:0] i = ~KEY;
	
	mux4x1 mux0 (.i(i), .s(SW), .y(LEDR[0]));
	
endmodule
