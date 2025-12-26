	module disp 
	(
		input wire[8:0] SW,
		input wire[2:0] KEY,
		output wire[6:0] HEX0, HEX1, HEX2, HEX3,
		output wire[9:0] LEDR,
		output wire[3:0] LEDG
	);

	wire[3:0] ao_a, ao_b, ao_c, ao_d, ao_e, ao_f, ao_g, ao_h, ao_i;
	
	cond_add ca_a (.i(SW[8:6]), .o(ao_a));
	cond_add ca_b (.i({ao_a[2:0], SW[5]}), .o(ao_b));
	cond_add ca_c (.i({ao_b[2:0], SW[4]}), .o(ao_c));
	cond_add ca_d (.i({ao_a[3], ao_b[3], ao_c[3]}), .o(ao_d));
	cond_add ca_e (.i({ao_c[2:0], SW[3]}), .o(ao_e));
	cond_add ca_f (.i({ao_d[2:0], ao_e[3]}), .o(ao_f));
	cond_add ca_g (.i({ao_e[2:0], SW[2]}), .o(ao_g));
	cond_add ca_h (.i({ao_f[2:0], ao_g[3]}), .o(ao_h));
	cond_add ca_i (.i({ao_g[2:0], SW[1]}), .o(ao_i));
	
	wire[3:0] bcd1s, bcd10s, bcd100s;
	
	assign bcd1s = {ao_i[2:0], SW[0]};
	assign bcd10s = {ao_h[2:0], ao_i[3]};
	assign bcd100s = {ao_d[3], ao_f[3], ao_h[3]};
	
	bin2ssd #(.INVERT(1)) bs0 (.b(bcd1s), .s(HEX0));
	bin2ssd #(.INVERT(1)) bs1 (.b(bcd10s), .s(HEX1));
	bin2ssd #(.INVERT(1)) bs2 (.b(bcd100s), .s(HEX2));
	
	assign HEX3 = 7'b1111111;
	
	wire[3:0] so_a, so_b, so_c, so_d, so_e, so_f, so_g, so_h, so_i;

	assign LEDR[0] = bcd1s[0];
	cond_sub cs_i (.i({bcd10s[0], bcd1s[3:1]}), .o(so_i));
	cond_sub cs_h (.i({bcd100s[0], bcd10s[3:1]}), .o(so_h));
	assign LEDR[1] = so_i[0];
	cond_sub cs_g (.i({so_h[0], so_i[3:1]}), .o(so_g));
	assign LEDR[2] = so_g[0];
	cond_sub cs_f (.i({bcd100s[1], so_h[3:1]}), .o(so_f));
	cond_sub cs_e (.i({so_f[0], so_g[3:1]}), .o(so_e));
	assign LEDR[3] = so_e[0];
	cond_sub cs_d (.i({bcd100s[2], so_f[3:1]}), .o(so_d));
	cond_sub cs_c (.i({so_d[0], so_e[3:1]}), .o(so_c));
	assign LEDR[4] = so_c[0];
	cond_sub cs_b (.i({so_d[1], so_c[3:1]}), .o(so_b));
	assign LEDR[5] = so_b[0];
	cond_sub cs_a (.i({so_d[2], so_b[3:1]}), .o(so_a));
	assign LEDR[8:6] = {so_a[2:0]};
	
endmodule
