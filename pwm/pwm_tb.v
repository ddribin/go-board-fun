`default_nettype none

module pwm_tb (
  input wire        i_clk,
  input wire [3:0]  i_config_compare,
  input wire        i_config_valid,
  output wire       o_pwm
);

  pwm #(
    .RESOLUTION(4)
  )
  pwm(.*);
  
endmodule