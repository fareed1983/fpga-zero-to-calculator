module bin2dec
	(
		input wire[9:0] bin2c,
		output wire[4:0] bcds[2:0]
	);
	
	// if negative then bcds should hold the positive of the twos-compliment binary
	wire[9:0] bin;

	assign bin = ((({10{bin2c[9]}} & ~bin2c) | ({10{!bin2c[9]}} & bin2c)) + (1'b1 & bin2c[9]));
	
	wire[3:0] ao_a, ao_b, ao_c, ao_d, ao_e, ao_f, ao_g, ao_h, ao_i;
	
	cond_add ca_a (.i(bin[8:6]), .o(ao_a));
	cond_add ca_b (.i({ao_a[2:0], bin[5]}), .o(ao_b));
	cond_add ca_c (.i({ao_b[2:0], bin[4]}), .o(ao_c));
	cond_add ca_d (.i({ao_a[3], ao_b[3], ao_c[3]}), .o(ao_d));
	cond_add ca_e (.i({ao_c[2:0], bin[3]}), .o(ao_e));
	cond_add ca_f (.i({ao_d[2:0], ao_e[3]}), .o(ao_f));
	cond_add ca_g (.i({ao_e[2:0], bin[2]}), .o(ao_g));
	cond_add ca_h (.i({ao_f[2:0], ao_g[3]}), .o(ao_h));
	cond_add ca_i (.i({ao_g[2:0], bin[1]}), .o(ao_i));
	
	assign bcds[0] = {ao_i[2:0], bin[0]};
	assign bcds[1] = {ao_h[2:0], ao_i[3]};
	assign bcds[2] = {ao_d[3], ao_f[3], ao_h[3]};
				
endmodule
