module TC4_to_7SEG(N, tens, ones);
	input [3:0] N;
	output [6:0] tens, ones;
	
	reg[6:0] LUT[0:5]; //16 row table for all possible 4 bit numbers.
	
	initial begin
		LUT[4'b0000] = 7'b1000000; // 0
		LUT[4'b0001] = 7'b1111001; // 1
		LUT[4'b0010] = 7'b0100100; // 2
		LUT[4'b0011] = 7'b0110000; // 3
		LUT[4'b0100] = 7'b0011001; // 4
		LUT[4'b0101] = 7'b0010010; // 5
	end
	
	assign ones = LUT[N];
	assign tens = 7'b1000000; 
endmodule