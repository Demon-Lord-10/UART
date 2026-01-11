module tb_uart_top;

    reg clk;
    reg reset;
    reg wr_enb;
    reg [7:0] data_in;
    wire tx_out;
    wire tx_busy;

    reg rdy_clr;
    wire [7:0] rx_data;
    wire rx_ready;
    uart_top uut (
        .clk(clk),
        .reset(reset),
        .wr_enb(wr_enb),
        .data_in(data_in),
        .tx_active(tx_busy),
        .tx_serial_out(tx_out),
        .rx_serial_in(tx_out), 
        .rdy_clr(rdy_clr),
        .rx_data_out(rx_data),
        .rx_ready(rx_ready)
    );


    always #10 clk = ~clk;

    initial begin
	$dumpfile("uart_waveform.vcd");
    	$dumpvars(0, tb_uart_top);
        clk = 0;
        reset = 1;
        wr_enb = 0;
        rdy_clr = 0;
        data_in = 8'hA5; 

        #100 reset = 0; 

        #100 wr_enb = 1; 
        #20  wr_enb = 0;

        wait(rx_ready == 1); 
        #100;
        if (rx_data == 8'hA5) 
            $display("SUCCESS: Received 0x%h", rx_data);
        else 
            $display("FAILURE: Received 0x%h", rx_data);

        $stop;
    end

endmodule

