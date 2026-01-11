module receiver(
    input clk,
    input rst,
    input rx,
    input rdy_clr,
    input clk_en,     
    output reg rdy,
    output reg [7:0] data_out
);

    parameter start_state = 2'b00;
    parameter data_out_state = 2'b01;
    parameter stop_state = 2'b10;

    reg [1:0] state; 
    reg [3:0] sample;
    reg [2:0] index;
    reg [7:0] temp_register;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            rdy <= 0;
            data_out <= 0;
            state <= start_state;
            sample <= 0;
            index <= 0;
            temp_register <= 0;
        end else begin
            if (rdy_clr)
                rdy <= 0;

            if (clk_en) begin
                case (state)
                    start_state: begin
                        if (!rx || sample != 0) begin 
                            if (sample == 7 && rx != 0) begin
                                sample <= 0; 
                            end else begin
                                sample <= sample + 1;
                            end
                            
                            if (sample == 15) begin
                                state <= data_out_state;
                                sample <= 0;
                                index <= 0;
                                temp_register <= 0;
                            end
                        end
                    end

                    data_out_state: begin
                        sample <= sample + 1;

                        if (sample == 4'h7) begin
                            temp_register[index] <= rx;
                        end
                        if (sample == 15) begin
                            sample <= 0; 
                            if (index == 7) begin
                                state <= stop_state;
                            end else begin
                                index <= index + 1;
                            end
                        end
                    end

                    stop_state: begin
                        if (sample == 15) begin
                            state <= start_state;
                            data_out <= temp_register;
                            rdy <= 1'b1;
                            sample <= 0;
                        end else begin
                            sample <= sample + 1;
                        end
                    end

                    default: state <= start_state;
                endcase
            end
        end
    end
endmodule







