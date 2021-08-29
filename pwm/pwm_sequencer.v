`default_nettype none

module pwm_sequencer (
  input wire        i_clk,

  output wire [7:0] o_top,
  output wire       o_top_valid,
  output wire [8:0] o_compare,
  output wire       o_compare_valid
);
  
  localparam CLOCK_FREQ_HZ = 25_000_000;
  localparam STEP_FREQ_HZ = CLOCK_FREQ_HZ / 256;
  localparam STEP = 97_656;
  localparam W = $clog2(STEP) - 1;

  reg [W:0]   r_count = 0;
  reg [8:0]   r_compare = 0;

  wire w_valid = r_count == 0;
  assign o_top_valid = w_valid;
  assign o_top = 8'hFF;
  assign o_compare_valid = w_valid;
  assign o_compare = r_compare;
  wire [W:0] w_top = STEP - 1;

  always @(posedge i_clk) begin
    r_count <= r_count + 1;
    if (r_count == STEP - 1) begin
      r_count <= 0;
      r_compare <= r_compare + 1;
    end
  end

endmodule