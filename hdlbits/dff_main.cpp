#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdio.h>

#include "Vdff.h"

// Legacy function required only for linking
double sc_time_stamp() { return 0; }

int main(int argc, const char*argv[])
{
    VerilatedContext *contextp = new VerilatedContext;
    contextp->traceEverOn(true);
    // contextp->randReset(2);

    Vdff *top = new Vdff(contextp);
    // `timescale 100ps/100ps
    contextp->timeunit(-10);
    contextp->timeprecision(-10);
    top->clk = 0;
    // top->reset = 1;
    top->eval();
    printf("timeunit: %d, timeprecision: %d\n", contextp->timeunit(), contextp->timeprecision());

    VerilatedVcdC *trace = new VerilatedVcdC;
    top->trace(trace, 5);
    trace->open("dff.vcd");
    trace->dump(contextp->time());

    // This puts the rising edge on even 1ns boundaries
    contextp->timeInc(5);

    uint8_t q = top->q;
    int posedge_count = 0;
    while (posedge_count < 15) {
        posedge_count++;
        contextp->timeInc(5);
        top->clk = 1;
        top->eval();

        // Set inputs
        {
            if (posedge_count == 3) {
                top->d = 1;
            }
            if (posedge_count == 6) {
                top->d = 0;
            }
            if (posedge_count == 8) {
                top->d = 1;
            }
        }
        top->eval();
        trace->dump(contextp->time());

        contextp->timeInc(5);
        top->clk = 0;
        top->eval();
        trace->dump(contextp->time());
        // Check outputs
        {
            if (posedge_count == 4) {
                assert((q == 0) && (top->q == 1));
            }
            if (posedge_count == 7) {
                assert((q == 1) && (top->q == 0));
            }
            if (posedge_count == 9) {
                assert((q == 0) && (top->q == 1));
            }
            q = top->q;
        }
    }

    top->final();
    trace->close();

    delete top;
    delete trace;
    delete contextp;

    return 0;
}
