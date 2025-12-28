module rs
	(
		input wire s, r,
		output wire qbar,
		output reg q
	);
	
	assign qbar = ~q;
	
	 // when any input (s or r) changes evaluate this block
	always @(*) begin
		if (s & ~r)
			q = 1'b1;
		else if (!s & r)
			q = 1'b0;
		// else hold latch state
	end
	
endmodule
