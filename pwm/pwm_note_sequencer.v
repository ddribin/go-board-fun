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

  localparam LEN_1 = 32'd2_083_333;
  localparam LEN_2 = 32'd4_166_667;
  localparam LEN_3 = 32'd6_250_000;
  localparam LEN_4 = 32'd8_333_333;
  localparam LEN_6 = 32'd12_500_000;
  localparam LEN_7 = 32'd14_583_333;
  localparam LEN_9 = 32'd18_750_000;
  localparam LEN_15 = 32'd31_250_000;

  localparam LEN_THIRTY_SECOND = LEN_1;
  localparam LEN_SIXTEENTH = LEN_2;
  localparam LEN_EIGHTH = LEN_4;
  localparam LEN_QUARTER = 32'd16_666_667;
  localparam LEN_HALF = 32'd33_333_333;
  localparam LEN_WHOLE = 32'd66_666_667;

  reg [31:0] r_duration_count = 0;
  reg [3:0] r_note_index = 0;

  reg [5:0]  r_note = 0;
  reg [31:0] r_note_duration = 0;
  wire r_note_done = r_duration_count == r_note_duration;

  always @(posedge i_clk) begin
    if (r_note_done) begin
      r_duration_count <= 0;
      r_note_index <= r_note_index + 1;
      // if (r_note_index == 4'd08) begin
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
      4'd00: begin r_note = `NOTE_Cs4; r_note_duration = LEN_9; end
      4'd01: begin r_note = `NOTE_Fs4; r_note_duration = LEN_SIXTEENTH; end
      4'd02: begin r_note = `NOTE_Gs4; r_note_duration = LEN_SIXTEENTH; end
      4'd03: begin r_note = `NOTE_B4;   r_note_duration = LEN_SIXTEENTH; end

      4'd04: begin r_note = `NOTE_B4; r_note_duration = LEN_3; end
      4'd05: begin r_note = `NOTE_As4; r_note_duration = LEN_THIRTY_SECOND; end
      4'd06: begin r_note = `NOTE_As4; r_note_duration = LEN_7; end
      4'd07: begin r_note = `NOTE_Gs4; r_note_duration = LEN_SIXTEENTH; end
      4'd08: begin r_note = `NOTE_Fs4; r_note_duration = LEN_SIXTEENTH; end

      4'd09: begin r_note = `NOTE_Cs5; r_note_duration = LEN_6; end
      4'd10: begin r_note = `NOTE_Fs4; r_note_duration = LEN_6; end
      4'd11: begin r_note = `NOTE_Fs5; r_note_duration = LEN_15; end
      4'd12: begin r_note = `NOTE_Gs5; r_note_duration = LEN_2; end
      4'd13: begin r_note = `NOTE_Fs5; r_note_duration = LEN_1; end
      4'd14: begin r_note = `NOTE_Cs6; r_note_duration = LEN_15; end
      4'd15: begin r_note = `NOTE_RST; r_note_duration = LEN_4; end
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
      
      default: begin r_note = `NOTE_RST;   r_note_duration = LEN_QUARTER; end
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  note_table note_table(.i_note(r_note), .o_compare(o_phase_delta));

endmodule