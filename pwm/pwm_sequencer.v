`default_nettype none

module pwm_sequencer #(
  parameter RESOLUTION = 4,
  parameter TOP = 4,
  parameter PERIOD = 12_500_000
) (
  input wire        i_clk,

  output wire [7:0] o_top,
  output wire       o_top_valid,
  output wire [8:0] o_compare,
  output wire       o_compare_valid
);

  // localparam STEP = 7; // PERIOD/(TOP+1); // = 35/(4+1) = 35/5 = 7
  // localparam STEP = PERIOD/(TOP+1);
  localparam STEP = 97_276;
  localparam STEP_WIDTH = $clog2(STEP); // = 3
  
  reg [STEP_WIDTH-1:0]   r_step_count = 0;
  reg [8:0]   r_compare = 0;
  reg [1:0]   r_phase = 0;

  assign o_top = 8'hff;
  wire w_valid = r_step_count == 0;
  assign o_top_valid = w_valid;
  assign o_compare_valid = w_valid;

  reg [8:0] r_output;
  always @(*) begin
    case (r_phase)
    2'd0: r_output = 9'h000;
    2'd1: r_output = r_compare;
    2'd2: r_output = 9'h100;
    2'd3: r_output = 9'h100 - r_compare;
    endcase
  end
  assign o_compare = r_output;

  always @(posedge i_clk) begin
    if (r_step_count == STEP-1) begin
      r_step_count <= 0;

      if (r_compare == 9'h100) begin
        r_compare <= 0;
        r_phase <= r_phase + 1;
      end else begin
        r_compare <= r_compare + 1;
      end
    end else begin
      r_step_count <= r_step_count + 1;
    end
  end


  // localparam STEP = 97_656;  localparam W = 25; // $clog2(STEP) - 1;
  // localparam STEP_PERIOD = PERIOD / TOP;
  // localparam STEP_COUNT_WIDTH = $clog2(STEP_PERIOD);

  // reg [W:0]   r_count = 0;
  // reg [4:0]   r_compare = 0;
  // reg [STEP_COUNT_WIDTH-1:0] r_step_count = 0;
  // reg         r_valid = 0;

  // wire w_valid = r_step_count == 0;
  // assign o_top_valid = w_valid;
  // /* verilator lint_off WIDTH */
  // assign o_top = TOP-1;
  // assign o_compare_valid = w_valid;
  // // assign o_compare = r_compare;
  // // wire [W:0] w_top = STEP - 1;

  // always @(posedge i_clk) begin
  //   if (r_step_count == 16-1) begin
  //     r_step_count <= 0;
  //     r_compare <= r_compare + 1;
  //   end else begin
  //     r_step_count <= r_step_count + 1;
  //   end
    
    // if (r_count == STEP - 1) begin
    //   r_count <= 0;
    // end else begin
    //   r_count <= r_count + 1;
    // end
    // r_compare <= w_compare_count[8:0];
// end

  // wire [W:0] w_compare_count = r_count / 4;
  // assign o_compare = w_compare_count[8:0];
  // assign o_compare = r_compare;

endmodule