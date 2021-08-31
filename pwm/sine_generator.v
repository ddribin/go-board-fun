`default_nettype none

module sine_generator (
  input wire [31:0]   i_phase,
  output wire [8:0]   o_compare
);
  
  reg [8:0] sine_table[255:0];
  initial begin
    $readmemh("sine_table.txt", sine_table);
  end

  wire [7:0]  w_sine_lookup = i_phase[31:24];
  assign o_compare = sine_table[w_sine_lookup] >> 2;
endmodule
