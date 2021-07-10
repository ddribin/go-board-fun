`default_nettype none
`include "nes_controller.vh"

module nes_controller_top (
  input wire  i_Clk,

  output wire io_PMOD_1,
  output wire io_PMOD_2,
  input wire  io_PMOD_3,

  output wire o_Segment1_A,
  output wire o_Segment1_B,
  output wire o_Segment1_C,
  output wire o_Segment1_D,
  output wire o_Segment1_E,
  output wire o_Segment1_F,
  output wire o_Segment1_G,

  output wire o_LED_1,
  output wire o_LED_2,
  output wire o_LED_3,
  output wire o_LED_4
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

  wire w_PMOD_3;
  synchronizer pmod_3_sync (
    .i_clk(i_Clk),
    .i_input(io_PMOD_3),
    .o_input_sync(w_PMOD_3)
  );

  wire        w_valid;
  wire [7:0]  w_buttons;
  nes_controller #(
    .CYCLES_PER_PULSE(125)
  ) nes_controller (
    .clk(i_Clk),
    .i_rst(0),
    .i_read_buttons(read_buttons),

    .o_valid(w_valid),
    .o_buttons(w_buttons),

    .o_controller_clock(io_PMOD_1),
    .o_controller_latch(io_PMOD_2),
    .i_controller_data(w_PMOD_3)
  );

  reg [7:0] r_buttons;
  always @(posedge i_Clk) begin
    if (w_valid) begin
      r_buttons <= w_buttons;
    end
  end

  assign o_Segment1_A = ~r_buttons[`NES_BUTTON_UP];
  assign o_Segment1_B = ~r_buttons[`NES_BUTTON_RIGHT];
  assign o_Segment1_C = ~r_buttons[`NES_BUTTON_RIGHT];
  assign o_Segment1_D = ~r_buttons[`NES_BUTTON_DOWN];
  assign o_Segment1_E = ~r_buttons[`NES_BUTTON_LEFT];
  assign o_Segment1_F = ~r_buttons[`NES_BUTTON_LEFT];
  assign o_Segment1_G = 1;

  assign o_LED_1 = r_buttons[`NES_BUTTON_SELECT];
  assign o_LED_2 = r_buttons[`NES_BUTTON_START];
  assign o_LED_3 = r_buttons[`NES_BUTTON_B];
  assign o_LED_4 = r_buttons[`NES_BUTTON_A];
  
endmodule