`default_nettype none

module sin_generator (
  input wire [31:0]   i_phase,
  output wire [8:0]   o_compare
);
  
  reg [8:0] sin_table[255:0];
  initial begin
    $readmemh("sin_table.txt", sin_table);
  end

  wire [7:0]  w_sin_lookup = i_phase[31:24];
  assign o_compare = sin_table[w_sin_lookup] >> 2;
endmodule
