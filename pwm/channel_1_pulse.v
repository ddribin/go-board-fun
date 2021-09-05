`default_nettype none

module channel_1_pulse (
  input wire          i_clk,
  output wire [8:0]   o_output,
  output wire         o_frame_pulse
);
  
  wire [7:0]    w_top;
  wire          w_top_valid;
  wire [31:0]   w_phase_delta;
  wire          w_compare_valid = 1;
  wire [8:0]    w_envelope;
  channel_1_note_sequencer sequencer(
    .i_clk(i_clk),
    .o_top(w_top),
    .o_top_valid(w_top_valid),
    .o_phase_delta(w_phase_delta),
    .o_envelope(w_envelope)
  );

  wire [31:0] w_phase;
  phase_generator phase_generator(
    .i_clk(i_clk),
    .i_phase_delta(w_phase_delta),
    .i_phase_delta_valid(1'b1),
    .o_phase(w_phase)
  );

  // Generate a pulse wave at 75% duty cycle
  wire [8:0]  w_compare = (w_phase[31:30] != 2'b11)? w_envelope : 9'd0;

  // Generate a sawtooth wave
  // wire [8:0]  w_compare = {1'b0, w_phase[31:24]} >> 2;

  // Generate a sine wave
  // wire [8:0]  w_compare;
  // sine_generator sine_generator(.i_phase(w_phase), .o_compare(w_compare));

  assign o_output = w_compare;
  assign o_frame_pulse = w_phase[31];

endmodule