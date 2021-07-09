module nes_controller_tb (
  input wire          clk,
  input wire          i_rst,
  // Control
  input wire          i_read_buttons,
  output reg          o_valid,
  output reg  [7:0]   o_buttons,
  // Controller signals
  input wire          i_controller_data,
  output reg          o_controller_latch,
  output reg          o_controller_clock
);

  nes_controller #(
    .CYCLES_PER_BIT(10)
  ) controller (.*);
  
endmodule