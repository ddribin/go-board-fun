`default_nettype none

module pwm_top (
  input wire  i_Clk,

  output wire io_PMOD_1,
  output wire io_PMOD_2,
  output wire io_PMOD_3,
  output wire o_LED_1
);
  
  // wire [7:0]  w_top;
  // wire        w_top_valid;
  // wire [8:0]  w_compare;
  // wire        w_compare_valid;
  // pwm_sequencer pwm_sequencer(
  //   .i_clk(i_Clk),
  //   .o_top(w_top),
  //   .o_top_valid(w_top_valid),
  //   .o_compare(w_compare),
  //   .o_compare_valid(w_compare_valid)
  // );

  wire [8:0] w_compare_pulse_1;
  wire w_frame_pulse;
  channel_1_pulse pulse_1(
    .i_clk(i_Clk),
    .o_output(w_compare_pulse_1),
    .o_frame_pulse(w_frame_pulse)
  );

  // Mixer
  wire [8:0] w_compare = w_compare_pulse_1;
  wire w_pwm;
  wire w_cycle_end;
  pwm pwm(
    .i_clk(i_Clk),
    .i_top(8'hff),
    .i_top_valid(1'b1),
    .i_compare(w_compare),
    .i_compare_valid(1'b1),
    .o_pwm(w_pwm),
    .o_cycle_end(w_cycle_end)
  );

  assign io_PMOD_1 = w_pwm;
  assign io_PMOD_2 = w_frame_pulse;
  assign io_PMOD_3 = ~w_pwm;
  // assign o_LED_1 = w_pwm;

endmodule
