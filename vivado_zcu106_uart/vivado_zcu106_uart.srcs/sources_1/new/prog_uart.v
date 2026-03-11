`timescale 1ns / 1ps

module prog_uart(
    input uart_rx_i,
    input uart_coming,
    output program_tx1_o,
    output program_tx2_o,
    output led_tx_o
    );

    assign program_tx1_o = uart_rx_i;
    assign program_tx2_o = uart_coming;
    assign led_tx_o = program_tx2_o;

endmodule
