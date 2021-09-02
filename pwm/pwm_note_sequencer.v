`default_nettype none

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

  // phase delta = (FREQ_HZ / SAMPLE_HZ) * 2^32;
  `define NOTE_RST  32'd0         // 0.000000 Hz

  `define NOTE_A2   32'd18898     // 110.000000 Hz

  `define NOTE_C3   32'd22473     // 130.812800 Hz
  `define NOTE_D3   32'd25226     // 146.832400 Hz
  `define NOTE_E3   32'd28315     // 164.813800 Hz
  `define NOTE_F3   32'd29998     // 174.614100 Hz
  `define NOTE_G3   32'd33672     // 195.997700 Hz
  `define NOTE_A3   32'd37796     // 220.000000 Hz
  `define NOTE_B3   32'd42424     // 246.941700 Hz

  `define NOTE_C4   32'd44947     // 261.625600 Hz
  `define NOTE_D4   32'd50451     // 293.664800 Hz
  `define NOTE_E4   32'd56630     // 329.627600 Hz
  `define NOTE_F4   32'd59997     // 349.228200 Hz
  `define NOTE_Fs4  32'd63565     // 369.994400 Hz
  `define NOTE_A4   32'd75591     // 440.000000 Hz

  `define NOTE_C5   32'd89894     // 523.251100 Hz
  `define NOTE_Cs5  32'd95239     // 554.365300 Hz
  `define NOTE_Fs5  32'd127129    // 739.988800 Hz
  `define NOTE_Gs5  32'd142698    // 830.609400 Hz
  `define NOTE_A5   32'd151183    // 880.000000 Hz
  `define NOTE_As5  32'd160173    // 932.327500 Hz
  `define NOTE_B5   32'd169697    // 987.766600 Hz


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

  wire [31:0] note_table[7:0];
  reg [31:0]  r_phase_delta;
  always @(*) begin
    case (r_note_index)
      4'd00: r_phase_delta = `NOTE_Fs4;
      4'd01: r_phase_delta = `NOTE_Cs5;
      4'd02: r_phase_delta = `NOTE_Fs5;
      4'd03: r_phase_delta = `NOTE_Gs5;
      4'd04: r_phase_delta = `NOTE_Cs5;
      4'd05: r_phase_delta = `NOTE_Fs5;
      4'd06: r_phase_delta = `NOTE_Gs5;
      4'd07: r_phase_delta = `NOTE_B5;
      4'd08: r_phase_delta = `NOTE_Cs5;
      4'd09: r_phase_delta = `NOTE_B5;
      4'd10: r_phase_delta = `NOTE_As5;
      4'd11: r_phase_delta = `NOTE_Cs5;
      4'd12: r_phase_delta = `NOTE_As5;
      4'd13: r_phase_delta = `NOTE_Gs5;
      4'd14: r_phase_delta = `NOTE_Fs5;
      4'd15: r_phase_delta = `NOTE_RST;
    endcase
  end

  assign o_top = 8'hff;
  assign o_top_valid = 1;
  assign o_phase_delta = r_phase_delta;
  
endmodule