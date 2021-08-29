`default_nettype none

module pwm #(
  parameter RESOLUTION      = 8
) (
  input wire      i_clk,
  input wire [RESOLUTION-1:0] i_config_compare,
  input wire      i_config_valid,
  output wire     o_pwm
);

  reg [RESOLUTION-1:0]  r_counter = 0;
  reg [RESOLUTION-1:0]  r_compare = 0;
  reg                   r_output = 0;

  always @(posedge i_clk) begin
    if (i_config_valid) begin
      r_counter <= 0;
      r_compare <= i_config_compare;
      r_output <= 0;
    end else begin
      r_counter <= r_counter + 1;
    end
  end

  assign o_pwm = r_counter < r_compare;
  
endmodule