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

  wire [7:0]    w_top;
  wire          w_top_valid;
  wire [31:0]   w_phase_delta;
  wire          w_compare_valid = 1;
  pwm_note_sequencer sequencer(
    .i_clk(i_Clk),
    .o_top(w_top),
    .o_top_valid(w_top_valid),
    .o_phase_delta(w_phase_delta)
  );

  // localparam DELTA_PHASE = (FREQ_HZ / SAMPLE_HZ) * 2^32;
  // localparam DELTA_PHASE = 32'd18_898; // 1100Hz
  // localparam DELTA_PHASE = 32'd37_795; // 220Hz
  localparam DELTA_PHASE = 32'd75_591; // 440Hz
  // localparam DELTA_PHASE = 32'd151_183; // 880Hz
  // localparam DELTA_PHASE = 32'd22_473; // C3
  wire [31:0] w_phase;
  phase_generator phase_generator(
    .i_clk(i_Clk),
    .i_phase_delta(w_phase_delta),
    .i_phase_delta_valid(1'b1),
    .o_phase(w_phase)
  );

  // Generate a pulse wave at 50% duty cycle
  // wire [8:0]  w_compare = (w_phase[31] == 1'b0)? 9'd0 : 9'd32;

  // Generate a sawtooth wave
  // wire [8:0]  w_compare = {1'b0, w_phase[31:24]} >> 2;

  // Generate a sine wave
  wire [8:0]  w_compare;
  sine_generator sine_generator(.i_phase(w_phase), .o_compare(w_compare));

  wire w_pwm;
  wire w_cycle_end;
  pwm pwm(
    .i_clk(i_Clk),
    .i_top(w_top),
    .i_top_valid(w_top_valid),
    .i_compare(w_compare),
    .i_compare_valid(w_compare_valid),
    .o_pwm(w_pwm),
    .o_cycle_end(w_cycle_end)
  );

  reg r_last_phase_31 = 0;
  always @(posedge i_Clk) begin
    r_last_phase_31 <= w_phase[31];
  end

  assign io_PMOD_1 = w_pwm;
  assign io_PMOD_2 = w_phase[31];
  assign io_PMOD_3 = ~w_pwm;
  // assign o_LED_1 = w_pwm;

endmodule
