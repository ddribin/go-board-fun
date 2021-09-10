`default_nettype none
`include "note_table.vh"

module channel_1_note_sequencer (
  input wire          i_clk,
  input wire          i_tick_stb,
  input wire          i_note_stb,

  output wire [7:0]   o_top,
  output wire         o_top_valid,
  output wire [31:0]  o_phase_delta,
  output wire [8:0]   o_envelope
);

  `include "note_length_table.vh"

  reg [4:0] r_duration_count = 0;
  reg [3:0] r_note_index = 0;

  reg [5:0]  r_note = 0;
  reg [4:0]  r_note_len = 0;
  // reg      r_new_note = 0;

  always @(posedge i_clk) begin
    if (i_note_stb) begin
      if (r_duration_count == r_note_len) begin
        r_duration_count <= 0;
        r_note_index <= r_note_index + 1;
        if (r_note_index == 4'd15) begin
          r_note_index <= 0;
        end
        // r_new_note <= 1;
      end else begin
        r_duration_count <= r_duration_count + 1;
        // r_new_note <= 0;
      end
    end
  end
  wire r_new_note = i_note_stb & (r_duration_count == r_note_len);

  always @(*) begin
    case (r_note_index)
      4'd00: begin r_note = `NOTE_RST;  r_note_len = note_len(30); end

      4'd01: begin r_note = `NOTE_Cs5;  r_note_len = note_len(18); end
      4'd02: begin r_note = `NOTE_Fs5;  r_note_len = note_len(4); end
      4'd03: begin r_note = `NOTE_Gs5;  r_note_len = note_len(4); end
      4'd04: begin r_note = `NOTE_B5;   r_note_len = note_len(4); end

      4'd05: begin r_note = `NOTE_B5; r_note_len = note_len(6); end
      4'd06: begin r_note = `NOTE_As5; r_note_len = note_len(2); end
      4'd07: begin r_note = `NOTE_As5; r_note_len = note_len(14); end
      4'd08: begin r_note = `NOTE_Gs5; r_note_len = note_len(4); end
      4'd09: begin r_note = `NOTE_Fs5; r_note_len = note_len(4); end

      4'd10: begin r_note = `NOTE_Cs6; r_note_len = note_len(12); end
      4'd11: begin r_note = `NOTE_Fs5; r_note_len = note_len(12); end
      4'd12: begin r_note = `NOTE_Fs6; r_note_len = note_len(30); end

      4'd13: begin r_note = `NOTE_Gs6; r_note_len = note_len(4); end
      4'd14: begin r_note = `NOTE_Fs6; r_note_len = note_len(2); end

      4'd15: begin r_note = `NOTE_Cs7; r_note_len = note_len(30); end

      default: begin r_note = `NOTE_RST;   r_note_len = note_len(4); end
    endcase
  end

  reg [18:0] r_envelope_counter = 0;
  reg [3:0] r_envelope_index = 0;
  always @(posedge i_clk) begin
    if (r_new_note) begin
      r_envelope_index <= 0;
    end else if (i_tick_stb) begin
      if (r_envelope_index == 4'd15) begin
        r_envelope_index <= 4'd15;
      end else begin
        r_envelope_index <= r_envelope_index + 1;
      end
    end
  end

  reg [8:0] r_envelope = 0;
  always @(*) begin
    case (r_envelope_index)
      4'd00: r_envelope = 3*2;
      4'd01: r_envelope = 4*2;
      4'd02: r_envelope = 6*2;
      4'd03: r_envelope = 7*2;
      4'd04: r_envelope = 8*2;
      4'd05: r_envelope = 9*2;
      4'd06: r_envelope = 10*2;
      4'd07: r_envelope = 10*2;
      4'd08: r_envelope = 10*2;
      4'd09: r_envelope = 11*2;
      4'd10: r_envelope = 12*2;
      4'd11: r_envelope = 12*2;
      4'd12: r_envelope = 13*2;
      4'd13: r_envelope = 15*2;
      4'd14: r_envelope = 15*2;
      4'd15: r_envelope = 15*2;

      default: r_envelope = 0;
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  wire [31:0] w_phase_delta;
  note_table note_table(.i_note(r_note), .o_compare(w_phase_delta));
  assign o_envelope = r_envelope;

  reg [2:0] r_vibrato_index = 0;
  always @(posedge i_clk) begin
    if (r_new_note) begin
      r_vibrato_index <= 0;
    end else if (i_tick_stb) begin
      if (r_vibrato_index == 3'd07) begin
        r_vibrato_index <= 0;
      end else begin
        r_vibrato_index <= r_vibrato_index + 1;
      end
    end
  end

  reg [31:0] r_vibrato_adjust = 0;
  localparam VIBRATO_DEPTH = 32'h200;
  always @(*) begin
    case (r_vibrato_index)
      3'd00: r_vibrato_adjust = 0;
      3'd01: r_vibrato_adjust = -32'h71B;
      3'd02: r_vibrato_adjust = -32'hAFA;
      3'd03: r_vibrato_adjust = -32'h71B;
      3'd04: r_vibrato_adjust = 0;
      3'd05: r_vibrato_adjust = 32'h79E;
      3'd06: r_vibrato_adjust = 32'hB1F;
      3'd07: r_vibrato_adjust = 32'h79E;

      default: r_vibrato_adjust = 0;
    endcase
  end
  
  assign o_phase_delta = w_phase_delta /*+ r_vibrato_adjust*/;

endmodule
