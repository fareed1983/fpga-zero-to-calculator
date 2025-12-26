module rig 
	(
		input wire[7:0] SW,
		input wire[2:0] KEY,
		output wire[6:0] HEX0, HEX1, HEX2, HEX3,
		output wire[9:0] LEDR,
		output wire[3:0] LEDG
	);
	
	wire[3:0] doT, doU, doV, doW, doX, doY, doZ;
	
	dabble dT (.i(SW[7:5]), .o(doT));
	dabble dU (.i({doT[2:0], SW[4]}), .o(doU));
	dabble dV (.i({doU[2:0], SW[3]}), .o(doV));
	
	dabble dW (.i({doT[3], doU[3], doV[3]}), .o(doW));
	dabble dX (.i({doV[2:0], SW[2]}), .o(doX));
	
	dabble dY (.i({doW[2:0], doX[3]}), .o(doY));
	dabble dZ (.i({doX[2:0], SW[1]}), .o(doZ));
	
	assign LEDR[0] = SW[0];
	assign LEDR[4:1] = doZ[3:0];
	assign LEDR[8:5] = doY[3:0];
	assign LEDR[9] = doW[3];
	
	wire[2:0] k = ~KEY;
	
	assign LEDG =	(k == 3'h1) ? doT :
						(k == 3'h2) ? doU :
						(k == 3'h3) ? doV :
						(k == 3'h4) ? doW :
						(k == 3'h5) ? doX :
						(k == 3'h6) ? doY :
						(k == 3'h7) ? doZ :
										  3'h0;
											 
	wire[0:3] bcd1s, bcd10s, bcd100s;
	
	assign bcd1s = {doZ[2:0], SW[0]};
	assign bcd10s = {doY[2:0], doZ[3]};
	assign bcd100s = {doW[3], doY[3]};
	
	bin2ssd #(.INVERT(1)) bs0 (.b(bcd1s), .s(HEX0));
	bin2ssd #(.INVERT(1)) bs1 (.b(bcd10s), .s(HEX1));
	bin2ssd #(.INVERT(1)) bs2 (.b(bcd100s), .s(HEX2));
	
	assign HEX3 = 7'b1111111;
	
endmodule
