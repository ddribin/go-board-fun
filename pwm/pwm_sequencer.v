`default_nettype none

module pwm_sequencer (
  input wire        i_clk,

  output wire [7:0] o_top,
  output wire       o_top_valid,
  output wire [8:0] o_compare,
  output wire       o_compare_valid
);
  
  reg [3:0]   r_count = 0;
  wire w_valid = r_count == 4;
  assign o_top_valid = w_valid;
  assign o_top = 8'hFF;
  assign o_compare_valid = w_valid;
  assign o_compare = 9'h80;

  always @(posedge i_clk) begin
    if (r_count[3] == 0) begin
      r_count <= r_count + 1;
    end
  end

endmodule