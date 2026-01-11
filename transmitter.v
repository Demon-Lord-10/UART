module transmitter(
    input clk,
    input wr_enb,
    input reset,
    input [7:0] data_in, 
    input enb,           
    output reg tx, 
    output reg busy
);

    parameter idle_state = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state = 2'b10;
    parameter stop_state = 2'b11;

    reg [7:0] data; 
    reg [2:0] index;
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= idle_state;
            tx <= 1'b1;
            busy <= 1'b0;
            index <= 3'b0;
            data <= 8'b0;
        end else begin
            case (state)
                idle_state: begin
                    tx <= 1'b1;
                    busy <= 1'b0;
                    if (wr_enb) begin
                        data <= data_in; 
                        state <= start_state;
                        busy <= 1'b1;
                    end
                end

                start_state: begin
                    busy <= 1'b1;
                    tx <= 1'b0; 
                    if (enb) state <= data_state; 
                end

                data_state: begin
                    busy <= 1'b1;
                    tx <= data[index];
                    if (enb) begin
                        if (index == 3'd7) begin
                            index <= 0;
                            state <= stop_state;
                        end else begin
                            index <= index + 1;
                        end
                    end
                end

                stop_state: begin
                    busy <= 1'b1;
                    tx <= 1'b1;
                    if (enb) state <= idle_state;
                end
                
                default: state <= idle_state;
            endcase
        end
    end
endmodule

