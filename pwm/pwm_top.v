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

  wire [31:0] w_phase;
  wire w_cycle_end;
  phase_generator phase_generator(
    .i_clk(i_Clk),
    .i_cycle(w_cycle_end),
    .o_phase(w_phase)
  );

  // Generate a pulse wave at 50% duty cycle
  // wire [8:0]  w_compare = (w_phase[31] == 1'b0)? 9'd0 : 9'd64;

  // Generate a sawtooth wave
  // wire [8:0]  w_compare = {1'b0, w_phase[31:24]};

  // Generate a sine wave
  reg [8:0] sin_table[255:0];
  initial begin
    $readmemh("sin_table.txt", sin_table);
  end
  wire [7:0]  w_sin_lookup = w_phase[31:24];
  wire [8:0]  w_compare = sin_table[w_sin_lookup] >> 2;

  wire w_pwm;
  pwm pwm(
    .i_clk(i_Clk),
    .i_top(8'hFF),
    .i_top_valid(1),
    .i_compare(w_compare),
    .i_compare_valid(1),
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
