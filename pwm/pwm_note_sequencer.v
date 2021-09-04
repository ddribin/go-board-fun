`default_nettype none
`include "note_table.vh"

module pwm_note_sequencer (
  input wire          i_clk,

  output wire [7:0]   o_top,
  output wire         o_top_valid,
  output wire [31:0]   o_phase_delta
);

  function [4:0] note_len;
    input [4:0] i_len;
    begin
      note_len = i_len - 1;
    end
  endfunction
  
  `define LEN_THIRTY_SECOND note_len(1)
  `define NOTE_LEN_SIXTEENTH note_len(2)
  `define NOTE_LEN_EIGHTH note_len(4)
  `define NOTE_LEN_QUARTER note_len(8)
  `define NOTE_LEN_HALF note_len(16)
  `define NOTE_LEN_WHOLE note_len(32)

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

  always @(posedge i_clk) begin
    if (r_note_done) begin
      r_duration_count <= 0;
      r_note_index <= r_note_index + 1;
      // if (r_note_index == 4'd14) begin
      //   r_note_index <= 0;
      // end
    end else begin
      r_duration_count <= r_duration_count + 1;
    end
  end

  // always @(*) begin
  //   case (r_note_index)
  //     4'd00: begin r_note = `NOTE_Fs4; r_note_duration = DURATION; end
  //     4'd01: begin r_note = `NOTE_Cs5; r_note_duration = DURATION; end
  //     4'd02: begin r_note = `NOTE_Fs5; r_note_duration = DURATION; end
  //     4'd03: begin r_note = `NOTE_Gs5; r_note_duration = DURATION; end
  //     4'd04: begin r_note = `NOTE_Cs5; r_note_duration = DURATION; end
  //     4'd05: begin r_note = `NOTE_Fs5; r_note_duration = DURATION; end
  //     4'd06: begin r_note = `NOTE_Gs5; r_note_duration = DURATION; end
  //     4'd07: begin r_note = `NOTE_B5;  r_note_duration = DURATION; end
  //     4'd08: begin r_note = `NOTE_Cs5; r_note_duration = DURATION; end
  //     4'd09: begin r_note = `NOTE_B5;  r_note_duration = DURATION; end
  //     4'd10: begin r_note = `NOTE_As5; r_note_duration = DURATION; end
  //     4'd11: begin r_note = `NOTE_Cs5; r_note_duration = DURATION; end
  //     4'd12: begin r_note = `NOTE_As5; r_note_duration = DURATION; end
  //     4'd13: begin r_note = `NOTE_Gs5; r_note_duration = DURATION; end
  //     4'd14: begin r_note = `NOTE_Fs5; r_note_duration = DURATION; end
  //     4'd15: begin r_note = `NOTE_RST; r_note_duration = DURATION; end
  //   endcase
  // end
  always @(*) begin
    case (r_note_index)
      4'd00: begin r_note = `NOTE_RST;  r_note_len = note_len(30); end

      4'd01: begin r_note = `NOTE_Cs4;  r_note_len = note_len(18); end
      4'd02: begin r_note = `NOTE_Fs4;  r_note_len = note_len(4); end
      4'd03: begin r_note = `NOTE_Gs4;  r_note_len = note_len(4); end
      4'd04: begin r_note = `NOTE_B4;   r_note_len = note_len(4); end

      4'd05: begin r_note = `NOTE_B4; r_note_len = note_len(6); end
      4'd06: begin r_note = `NOTE_As4; r_note_len = note_len(2); end
      4'd07: begin r_note = `NOTE_As4; r_note_len = note_len(14); end
      4'd08: begin r_note = `NOTE_Gs4; r_note_len = note_len(4); end
      4'd09: begin r_note = `NOTE_Fs4; r_note_len = note_len(4); end

      4'd10: begin r_note = `NOTE_Cs5; r_note_len = note_len(12); end
      4'd11: begin r_note = `NOTE_Fs4; r_note_len = note_len(12); end
      4'd12: begin r_note = `NOTE_Fs5; r_note_len = note_len(30); end
      4'd13: begin r_note = `NOTE_Gs5; r_note_len = note_len(4); end
      4'd14: begin r_note = `NOTE_Fs5; r_note_len = note_len(2); end
      4'd15: begin r_note = `NOTE_Cs6; r_note_len = note_len(30); end
      // 4'd15: begin r_note = `NOTE_RST; r_note_len = note_len(4); end
      default: begin r_note = `NOTE_RST;   r_note_len = note_len(4); end
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  note_table note_table(.i_note(r_note), .o_compare(o_phase_delta));

endmodule