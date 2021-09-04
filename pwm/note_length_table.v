`default_nettype none

module note_length_table (
  input wire  [4:0]   i_note_len,
  output wire [31:0]  o_duration
);

  reg [31:0]  r_duration = 0;
  assign      o_duration = r_duration;
  always @(*) begin
    case (i_note_len)
      5'd00: r_duration = 32'd2083333;
      5'd01: r_duration = 32'd4166667;
      5'd02: r_duration = 32'd6250000;
      5'd03: r_duration = 32'd8333333;
      5'd04: r_duration = 32'd10416667;
      5'd05: r_duration = 32'd12500000;
      5'd06: r_duration = 32'd14583333;
      5'd07: r_duration = 32'd16666667;
      5'd08: r_duration = 32'd18750000;
      5'd09: r_duration = 32'd20833333;
      5'd10: r_duration = 32'd22916667;
      5'd11: r_duration = 32'd25000000;
      5'd12: r_duration = 32'd27083333;
      5'd13: r_duration = 32'd29166667;
      5'd14: r_duration = 32'd31250000;
      5'd15: r_duration = 32'd33333333;
      5'd16: r_duration = 32'd35416667;
      5'd17: r_duration = 32'd37500000;
      5'd18: r_duration = 32'd39583333;
      5'd19: r_duration = 32'd41666667;
      5'd20: r_duration = 32'd43750000;
      5'd21: r_duration = 32'd45833333;
      5'd22: r_duration = 32'd47916667;
      5'd23: r_duration = 32'd50000000;
      5'd24: r_duration = 32'd52083333;
      5'd25: r_duration = 32'd54166667;
      5'd26: r_duration = 32'd56250000;
      5'd27: r_duration = 32'd58333333;
      5'd28: r_duration = 32'd60416667;
      5'd29: r_duration = 32'd62500000;
      5'd30: r_duration = 32'd64583333;
      5'd31: r_duration = 32'd66666667;
    endcase
  end
  
endmodule