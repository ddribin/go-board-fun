`default_nettype none
`include "nes_controller.vh"

module nes_controller_top (
  input wire      i_Clk,

  output wire     io_PMOD_1,
  output wire     io_PMOD_2
);

  reg [18:0]  read_count_r;
  wire read_buttons = read_count_r[18];

  always @(posedge i_Clk) begin
    if (read_buttons == 1) begin
      read_count_r <= 0;
    end else begin
      read_count_r <= read_count_r + 1;
    end
  end

  nes_controller #(
    .CYCLES_PER_BIT(250)
  ) nes_controller (
    .clk(i_Clk),
    .i_rst(0),
    .i_read_buttons(read_buttons),

    .o_valid(),
    .o_buttons(),

    .i_controller_data(1),
    .o_controller_clock(io_PMOD_1),
    .o_controller_latch(io_PMOD_2)
  );
  
endmodule