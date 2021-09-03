`default_nettype none
`include "note_table.vh"

module pwm_note_sequencer (
  input wire          i_clk,

  output wire [7:0]   o_top,
  output wire         o_top_valid,
  output wire [31:0]   o_phase_delta
);

  // localparam DURATION = 25_000_000/4;
  // localparam DURATION = 6_250_000;
  localparam DURATION = 4_166_667; // 180 BPM: DURATION = 25MHz * 30 / 180
  localparam DURATION_WIDTH = $clog2(DURATION);

  reg [DURATION_WIDTH-1:0] r_duration_count = 0;
  reg [3:0] r_note_index = 0;

  always @(posedge i_clk) begin
    if (r_duration_count == DURATION-1) begin
      r_duration_count <= 0;
      r_note_index <= r_note_index + 1;
    end else begin
      r_duration_count <= r_duration_count + 1;
    end
  end

  reg [5:0]  r_note;
  always @(*) begin
    case (r_note_index)
      4'd00: r_note = `NOTE_Fs4;
      4'd01: r_note = `NOTE_Cs5;
      4'd02: r_note = `NOTE_Fs5;
      4'd03: r_note = `NOTE_Gs5;
      4'd04: r_note = `NOTE_Cs5;
      4'd05: r_note = `NOTE_Fs5;
      4'd06: r_note = `NOTE_Gs5;
      4'd07: r_note = `NOTE_B5;
      4'd08: r_note = `NOTE_Cs5;
      4'd09: r_note = `NOTE_B5;
      4'd10: r_note = `NOTE_As5;
      4'd11: r_note = `NOTE_Cs5;
      4'd12: r_note = `NOTE_As5;
      4'd13: r_note = `NOTE_Gs5;
      4'd14: r_note = `NOTE_Fs5;
      4'd15: r_note = `NOTE_RST;
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  note_table note_table(.i_note(r_note), .o_compare(o_phase_delta));

endmodule