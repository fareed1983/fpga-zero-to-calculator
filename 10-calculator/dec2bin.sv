module dec2bin
	(
		input wire[3:0] bcds[2:0],
		input wire negative,
		output wire[9:0] bin2c
	);
	
	wire[9:0] bin;
	
	wire[3:0] so_a, so_b, so_c, so_d, so_e, so_f, so_g, so_h, so_i;

	assign bin[0] = bcds[0][0];
	cond_sub cs_i (.i({bcds[1], bcds[0][3:1]}), .o(so_i));
	cond_sub cs_h (.i({bcds[2][0], bcds[1][3:1]}), .o(so_h));
	assign bin[1] = so_i[0];
	cond_sub cs_g (.i({so_h[0], so_i[3:1]}), .o(so_g));
	assign bin[2] = so_g[0];
	cond_sub cs_f (.i({bcds[2][1], so_h[3:1]}), .o(so_f));
	cond_sub cs_e (.i({so_f[0], so_g[3:1]}), .o(so_e));
	assign bin[3] = so_e[0];
	cond_sub cs_d (.i({bcds[2][2], so_f[3:1]}), .o(so_d));
	cond_sub cs_c (.i({so_d[0], so_e[3:1]}), .o(so_c));
	assign bin[4] = so_c[0];
	cond_sub cs_b (.i({so_d[1], so_c[3:1]}), .o(so_b));
	assign bin[5] = so_b[0];
	cond_sub cs_a (.i({so_d[2], so_b[3:1]}), .o(so_a));
	assign bin[8:6] = {so_a[2:0]};
	
	// if negative, then invert the bin and add 1
	assign bin2c = ((({10{negative}} & ~bin) | ({10{!negative}} & bin)) + (1'b1 & negative));
	
endmodule
