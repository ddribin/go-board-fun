`default_nettype none
`include "nes_controller.vh"

module nes_controller #(
  CYCLES_PER_PULSE = 0
) (
  input wire          clk,
  input wire          i_rst,
  // Control
  input wire          i_read_buttons,
  output reg          o_valid,
  output reg  [7:0]   o_buttons,
  // Controller signals
  input wire          i_controller_data,
  output reg          o_controller_latch,
  output reg          o_controller_clock
);

  localparam STATE_IDLE       = 3'd0;
  localparam STATE_BUTTON_A   = 3'd1;
  localparam STATE_OTHER_BUTTONS = 3'd2;
  localparam STATE_VALID    = 3'd3;

  localparam COUNT_WIDTH = $clog2(CYCLES_PER_PULSE*2);
  localparam CYCLES_PER_BIT = CYCLES_PER_PULSE*2;
  localparam CYCLES_PER_READ_BIT = CYCLES_PER_PULSE + (CYCLES_PER_PULSE)/2;

  reg [2:0]     r_state = STATE_IDLE;
  reg [COUNT_WIDTH-1:0] r_count = 0;
  reg [2:0]     r_button_count;

  always @(posedge clk) begin
    case (r_state)
      STATE_IDLE : begin
        o_valid <= 0;
        o_buttons <= 0;
        o_controller_latch <= 0;
        o_controller_clock <= 1;
        if (i_read_buttons) begin
          r_state <= STATE_BUTTON_A;
          r_count <= 0;
          o_controller_latch <= 1;
        end
      end

      STATE_BUTTON_A : begin
        if (r_count == CYCLES_PER_BIT-1) begin
          r_state <= STATE_OTHER_BUTTONS;
          r_count <= 0;
          r_button_count <= 0;
          o_controller_clock <= 0;
        end else begin
          if (r_count == CYCLES_PER_PULSE-1) begin
            o_controller_latch <= 0;
          end else if (r_count == CYCLES_PER_READ_BIT-1) begin
            o_buttons <= {o_buttons[6:0], !i_controller_data};
          end
          r_count <= r_count + 1;
        end
      end

      STATE_OTHER_BUTTONS : begin
        if (r_count == CYCLES_PER_BIT-1) begin
          if (r_button_count == 6) begin
            r_state <= STATE_VALID;
            o_valid <= 1;
          end else begin
            r_button_count <= r_button_count + 1;
            r_count <= 0;
            o_controller_clock <= 0;
          end
        end else begin
          if (r_count == CYCLES_PER_PULSE-1) begin
            o_controller_clock <= 1;
          end else if (r_count == CYCLES_PER_READ_BIT-1) begin
            o_buttons <= {o_buttons[6:0], !i_controller_data};
          end
         r_count <= r_count + 1;
        end
      end

      STATE_VALID : begin
        r_state <= STATE_IDLE;
        o_valid <= 0;
      end

      default: r_state <= STATE_IDLE;
    endcase

  end
  
endmodule
