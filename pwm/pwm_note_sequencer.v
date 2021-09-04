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


  function [4:0] note_len;
    input [4:0] i_len;
    begin
      note_len = i_len - 1;
    end
  endfunction
  
  localparam LEN_1 = note_len(1);
  localparam LEN_2 = note_len(2);
  localparam LEN_3 = note_len(3);
  localparam LEN_4 = 5'd3;
  localparam LEN_6 = 5'd5;
  localparam LEN_7 = 32'd14_583_333;
  localparam LEN_9 = 32'd18_750_000;
  localparam LEN_15 = 32'd31_250_000;

  localparam LEN_THIRTY_SECOND = LEN_1;
  localparam LEN_SIXTEENTH = LEN_2;
  localparam LEN_EIGHTH = LEN_4;
  localparam LEN_QUARTER = 32'd16_666_667;
  localparam LEN_HALF = 32'd33_333_333;
  localparam LEN_WHOLE = 32'd66_666_667;

  reg [31:0]  r_duration = 0;
  reg [4:0]   r_note_len = 0;
  always @(*) begin
    case (r_note_len)
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

  reg [31:0] r_duration_count = 0;
  reg [3:0] r_note_index = 0;

  reg [5:0]  r_note = 0;
  wire [31:0] r_note_duration = r_duration;
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
      4'd00: begin r_note = `NOTE_Cs4;  r_note_len = note_len(18); end
      4'd01: begin r_note = `NOTE_Fs4;  r_note_len = note_len(4); end
      4'd02: begin r_note = `NOTE_Gs4;  r_note_len = note_len(4); end
      4'd03: begin r_note = `NOTE_B4;   r_note_len = note_len(4); end

      4'd04: begin r_note = `NOTE_B4; r_note_len = note_len(6); end
      4'd05: begin r_note = `NOTE_As4; r_note_len = note_len(2); end
      4'd06: begin r_note = `NOTE_As4; r_note_len = note_len(14); end
      4'd07: begin r_note = `NOTE_Gs4; r_note_len = note_len(4); end
      4'd08: begin r_note = `NOTE_Fs4; r_note_len = note_len(4); end

      4'd09: begin r_note = `NOTE_Cs5; r_note_len = note_len(12); end
      4'd10: begin r_note = `NOTE_Fs4; r_note_len = note_len(12); end
      4'd11: begin r_note = `NOTE_Fs5; r_note_len = note_len(30); end
      4'd12: begin r_note = `NOTE_Gs5; r_note_len = note_len(4); end
      4'd13: begin r_note = `NOTE_Fs5; r_note_len = note_len(1); end
      4'd14: begin r_note = `NOTE_Cs6; r_note_len = note_len(30); end
      4'd15: begin r_note = `NOTE_RST; r_note_len = note_len(4); end
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
      
      default: begin r_note = `NOTE_RST;   r_note_len = note_len(4); end
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  note_table note_table(.i_note(r_note), .o_compare(o_phase_delta));

endmodule