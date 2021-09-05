`default_nettype none
`include "note_table.vh"

module channel_3_note_sequencer (
  input wire          i_clk,

  output wire [7:0]   o_top,
  output wire         o_top_valid,
  output wire [31:0]  o_phase_delta
);
  `include "note_length_table.vh"

  reg   [4:0]   r_note_len = 0;
  wire  [31:0]  r_note_duration;
  note_length_table length_table(
    .i_note_len(r_note_len),
    .o_duration(r_note_duration)
  );

  reg [31:0] r_duration_count = 0;
  reg [3:0] r_note_index = 0;

  reg [5:0]  r_note = 0;
  wire r_note_done = r_duration_count == r_note_duration;
  reg r_new_note = 0;

  always @(posedge i_clk) begin
    if (r_note_done) begin
      r_duration_count <= 0;
      r_note_index <= r_note_index + 1;
      if (r_note_index == 4'd13) begin
        r_note_index <= 0;
      end
      r_new_note <= 1;
    end else begin
      r_duration_count <= r_duration_count + 1;
      r_new_note <= 0;
    end
  end

  always @(*) begin
    case (r_note_index)
      4'd00: begin r_note = `NOTE_RST;  r_note_len = note_len(30); end

      4'd01: begin r_note = `NOTE_Fs3;  r_note_len = note_len(6); end
      4'd02: begin r_note = `NOTE_Cs4;  r_note_len = note_len(6); end
      4'd03: begin r_note = `NOTE_Fs4;  r_note_len = note_len(18); end

      4'd04: begin r_note = `NOTE_E3;  r_note_len = note_len(6); end
      4'd05: begin r_note = `NOTE_B3;  r_note_len = note_len(6); end
      4'd06: begin r_note = `NOTE_E4;  r_note_len = note_len(18); end

      4'd07: begin r_note = `NOTE_Ds3;  r_note_len = note_len(6); end
      4'd08: begin r_note = `NOTE_As3;  r_note_len = note_len(6); end
      4'd09: begin r_note = `NOTE_Ds4;  r_note_len = note_len(18); end

      4'd10: begin r_note = `NOTE_D3;  r_note_len = note_len(6); end
      4'd11: begin r_note = `NOTE_A3;  r_note_len = note_len(6); end
      4'd12: begin r_note = `NOTE_D4;  r_note_len = note_len(18); end

      4'd13: begin r_note = `NOTE_Fs4;  r_note_len = note_len(30); end

      default: begin r_note = `NOTE_RST;   r_note_len = note_len(4); end
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  note_table note_table(.i_note(r_note), .o_compare(o_phase_delta));

endmodule