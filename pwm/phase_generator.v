`default_nettype none

module phase_generator #(
  parameter FREQ_HZ = 440,
  parameter SAMPLE_HZ = 25_000_000
) (
  input wire          i_clk,
  input wire          i_cycle,
  output wire [31:0]  o_phase
);
  
  // localparam DELTA_PHASE = FREQ_HZ * 2^32 / SAMPLE_HZ;
  localparam DELTA_PHASE = 31'd75_591;
  reg [31:0]    r_phase = 0;
  always @(posedge i_clk) begin
    // if (i_cycle) begin
      r_phase <= r_phase + DELTA_PHASE;
    // end
  end
  assign o_phase = r_phase;
endmodule
