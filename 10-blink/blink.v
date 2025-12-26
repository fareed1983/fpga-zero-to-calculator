module rig (
		input  wire CLOCK_50,
		output wire [0:1] LEDR
	);

    blink b0 (
        .clk (CLOCK_50),
        .led (LEDR[0])
    );

	 assign LEDR[1] = CLOCK_50;

endmodule

module blink(
		input wire clk,
		output reg led
	);
	
	reg [31:0] count = 0;
	
	always @(posedge clk) begin
	
		if (count == 32'd49_999_999) begin
			count <= 0;
			led <= ~led;
		end else begin
			count <= count +1;
		end
		
	end
	
endmodule
