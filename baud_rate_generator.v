module BaudRateGenerator(
    input clk,
    input reset,
    output tx_enb,
    output rx_enb
);
    reg [12:0] tx_counter;
    reg [9:0] rx_counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            tx_counter <= 0;
            rx_counter <= 0;
        end else begin
            if (tx_counter == 5207) 
                tx_counter <= 0;
            else
                tx_counter <= tx_counter + 1;
            if (rx_counter == 324)  
                rx_counter <= 0;
            else
                rx_counter <= rx_counter + 1;
        end
    end

    
    assign tx_enb = (tx_counter == 5207) ? 1'b1 : 1'b0;
    assign rx_enb = (rx_counter == 324) ? 1'b1 : 1'b0;

endmodule


