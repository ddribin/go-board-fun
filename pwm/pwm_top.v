`default_nettype none

module pwm_top (
  input wire  i_Clk,

  output wire io_PMOD_1,
  output wire io_PMOD_2,
  output wire o_LED_1
);
  
  wire [7:0]  w_top;
  wire        w_top_valid;
  wire [8:0]  w_compare;
  wire        w_compare_valid;
  pwm_sequencer pwm_sequencer(
    .i_clk(i_Clk),
    .o_top(w_top),
    .o_top_valid(w_top_valid),
    .o_compare(w_compare),
    .o_compare_valid(w_compare_valid)
  );

  wire w_pwm;
  pwm pwm(
    .i_clk(i_Clk),
    .i_top(w_top),
    .i_top_valid(w_top_valid),
    .i_compare(w_compare),
    .i_compare_valid(w_compare_valid),
    .o_pwm(w_pwm)
  );

  assign io_PMOD_1 = w_pwm;
  assign io_PMOD_2 = ~w_pwm;
  assign o_LED_1 = w_pwm;

endmodule
