module traffic_controller(reset,clk, E, NL, EL, W, ETL, NLTL, ELTL, WTL, timer);
	input reset,clk, E, NL, EL, W;
	reg [3:0]state, next_state, counter, timer;
	//need 7 registers to store each bit.
	reg [6:0] ETL, NLTL, ELTL, WTL;
	
	//hold transitions;
	reg [0:0] counter_reset;
	reg [0:0] timer_reset, timer_enable, timer_on;
	
	//outputs.
	output[6:0]ETL, NLTL, ELTL, WTL; //want this as output cause acutaully return this.
	output[3:0]timer;
	
	//three states, states are 2 bits like the register, so need 7 flip-flops.
	parameter S0 = 4'b0000, S1 = 4'b0001, S2 = 4'b0010, S3 = 4'b0011, y0 = 4'b0100, y1 = 4'b0101, y2 = 4'b0110, y3 = 4'b0111, y4 = 4'b1000, y5 = 4'b1001;
	//second set of parameters, Green, Red, Yellow;
	parameter Red = 7'b0101111, Green = 7'b0010000, Yellow = 7'b0010001;
	
	
		
	//setting the state register.
	always@(posedge clk) begin
		if(reset) begin
			state <= S0;
			counter <= 0;
			timer <= 5;
			timer_on <= 0;
		end
		else begin
			//so if current state is transitioning to what we want it to be.
			//if varying signal.
			state <= next_state;
			if(timer_reset) begin
				timer <= 5;
				timer_on <= 0;
			end
			
			if(timer_enable)
				timer_on <= 1;
			else
				timer_on <= 0;
				
			if(timer_on & timer > 0)	
				timer <= timer - 1;
			state <= next_state;
			if(counter_reset)
				counter <= 0;
			else
				counter <= counter + 1;
		end
	end
	
	//next state logic
	//next state is where we wanna add the logic.
	always@(*) begin
		next_state = state;
		case(state)
			S0: if((counter < 3) || (W & ~NL & ~EL)) begin
					next_state = S0;
					//wanna stop it as is.
					if(timer == 0)
						timer_enable = 0;
				 end
				 else begin
					timer_enable = 1;
					if((EL & ~NL) && timer == 0)
						next_state = y3;
					else if(timer == 0)
						next_state = y0;
				 end
			S1: if((counter < 3) || (NL & ~W & ~EL)) begin
					next_state = S1;
					if(timer == 0)
						timer_enable = 0;
				 end
				 else begin
					timer_enable = 1;	
					if(((W & ~EL) || (E & ~EL)) & timer == 0)
						next_state = y5;
					else if(timer == 0)
						next_state = y1;
				 end
			S2: if((counter < 3) || (EL & ~NL & ~W & ~E)) begin
					next_state = S2;
					if(timer == 0)
						timer_enable = 0;
				 end
				 else begin
					 timer_enable = 1;
					 if((NL & ~W & ~EL) & timer == 0)
						next_state = y4;
					 else if(timer == 0)
						next_state = y2;
				 end
			y0: next_state = S1;
			y1: next_state = S2;
			y2: next_state = S0;
			y3: next_state = S2;
			y4: next_state = S1;
			y5: next_state = S0;
			default: next_state = S0;
		endcase
	end
			
	//output logic
	always@(*) begin
		case(state)
			S0: begin
				ETL = Green;
				NLTL = Red;
				ELTL = Red;
				WTL = Green;
				//no reseting a counter at the states.s
				counter_reset = 0;
				timer_reset = 0;
			end
			S1: begin
				ETL = Green;
				NLTL = Green;
				ELTL = Red;
				WTL = Red;
				//no reseting a counter at the states.s
				//okay so at states don't reset.
				counter_reset = 0;
				timer_reset = 0;
			end
			S2: begin
				ETL = Red;
				NLTL = Red;
				ELTL = Green;
				WTL = Red;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 0;
				timer_reset = 0;
			end
			y0: begin
				ETL = Green;
				NLTL = Red;
				ELTL = Red;
				WTL = Yellow;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			y1: begin
				ETL = Yellow;
				NLTL = Yellow;
				ELTL = Red;
				WTL = Red;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			y2: begin
				ETL = Red;
				NLTL = Red;
				ELTL = Yellow;
				WTL = Red;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			y3: begin
				ETL = Yellow;
				NLTL = Red;
				ELTL = Red;
				WTL = Yellow;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			y4: begin
				ETL = Red;
				NLTL = Red;
				ELTL = Yellow;
				WTL = Red;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			y5: begin
				ETL = Green;
				NLTL = Yellow;
				ELTL = Red;
				WTL = Red;
				//no reseting a counter at the states.
				//then reset at yellow, because will be 1 second at yellow, by next clock.
				counter_reset = 1;
				timer_reset = 1;
			end
			default: begin
				ETL = Green;
				NLTL = Red;
				ELTL = Red;
				WTL = Green;
				//no reseting a counter at the states.s
				counter_reset = 0;
				timer_reset = 0;
			end
		endcase
	end	
	
endmodule