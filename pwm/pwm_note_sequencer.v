`default_nettype none

module pwm_note_sequencer (
  input wire          i_clk,

  output wire [7:0]   o_top,
  output wire         o_top_valid,
  output wire [31:0]   o_phase_delta
);

  // localparam DURATION = 25_000_000/4;
  localparam DURATION = 6_250_000;
  localparam DURATION_WIDTH = $clog2(DURATION);

  // phase delta = (FREQ_HZ / SAMPLE_HZ) * 2^32;
  localparam NOTE_A2 = 32'd18_898;    // 110.0000 Hz
  localparam NOTE_C3 = 32'd22_473;    // 130.8128 Hz
  localparam NOTE_D3 = 32'd25_226;    // 146.8324 Hz
  localparam NOTE_E3 = 32'd28_315;    // 164.8138 Hz
  localparam NOTE_F3 = 32'd29_998;    // 174.6141 Hz
  localparam NOTE_G3 = 32'd33_672;    // 195.9977 Hz
  localparam NOTE_A3 = 32'd37_796;    // 220.0000 Hz
  localparam NOTE_B3 = 32'd42_424;    // 246.9417 Hz
  localparam NOTE_C4 = 32'd44_947;    // 261.6256 Hz
  localparam NOTE_A4 = 32'd75_591;    // 440.0000 Hz
  localparam NOTE_A5 = 32'd151_183;   // 880.0000 Hz


  reg [DURATION_WIDTH-1:0] r_duration_count = 0;
  reg [2:0] r_note_index = 0;

  always @(posedge i_clk) begin
    if (r_duration_count == DURATION-1) begin
      r_duration_count <= 0;
      r_note_index <= r_note_index + 1;
    end else begin
      r_duration_count <= r_duration_count + 1;
    end
  end

  wire [31:0] note_table[7:0];
  reg [31:0]  r_phase_delta;
  always @(*) begin
    case (r_note_index)
      3'd0: r_phase_delta = NOTE_C3;
      3'd1: r_phase_delta = NOTE_D3;
      3'd2: r_phase_delta = NOTE_E3;
      3'd3: r_phase_delta = NOTE_F3;
      3'd4: r_phase_delta = NOTE_G3;
      3'd5: r_phase_delta = NOTE_A3;
      3'd6: r_phase_delta = NOTE_B3;
      3'd7: r_phase_delta = NOTE_C4;
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  assign o_phase_delta = r_phase_delta;
  
endmodule