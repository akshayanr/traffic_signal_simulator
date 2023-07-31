module Lab6(SW, LEDR, KEY, HEX0, HEX1, HEX2, HEX3, HEX6, HEX7);
	input [17:0]SW;
	input [0:0]KEY;
	output [6:0]HEX0, HEX1, HEX2, HEX3, HEX6, HEX7;
	output [17:0]LEDR;
	wire [3:0] get_time;
	//module traffic_controller(reset,clk, E, NL, EL, W, ETL, NLTL, ELTL, WTL, timer);
	assign LEDR[17] = SW[17];
	assign LEDR[0] = SW[0];
	assign LEDR[1] = SW[1];
	assign LEDR[2] = SW[2];
	assign LEDR[3] = SW[3];
	traffic_controller controller(.reset(SW[17]), .clk(KEY[0]), .E(SW[3]), .NL(SW[2]), .EL(SW[1]), .W(SW[0]), .ETL(HEX3), .NLTL(HEX2), .ELTL(HEX1), .WTL(HEX0), .timer(get_time));
	//module TC4_to_7SEG(N, tens, ones);
	TC4_to_7SEG display(.N(get_time), .tens(HEX7), .ones(HEX6));
endmodule