module uart_top(
    input clk,
    input reset,
    input wr_enb,
    input [7:0] data_in,
    output tx_active,
    output tx_serial_out,
    input rx_serial_in,
    input rdy_clr,
    output [7:0] rx_data_out,
    output rx_ready
);

    wire tx_tick;
    wire rx_tick;

    BaudRateGenerator baud_gen_inst (
        .clk(clk),
        .reset(reset),
        .tx_enb(tx_tick),
        .rx_enb(rx_tick)
    );

    transmitter tx_inst (
        .clk(clk),
        .wr_enb(wr_enb),
        .reset(reset),
        .data_in(data_in),
        .enb(tx_tick),
        .tx(tx_serial_out),
        .busy(tx_active)
    );

    receiver rx_inst (
        .clk(clk),
        .rst(reset),
        .rx(rx_serial_in),
        .rdy_clr(rdy_clr),
        .clk_en(rx_tick),
        .rdy(rx_ready),
        .data_out(rx_data_out)
    );

endmodule
