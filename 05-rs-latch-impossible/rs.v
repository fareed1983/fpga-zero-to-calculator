module rs
	(
		input wire s, r,
		output wire q, qbar
	);
	
	assign q = ~(r | qbar);
	assign qbar = ~(s | q);
	
endmodule
