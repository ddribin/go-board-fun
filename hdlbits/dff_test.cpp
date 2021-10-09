#include "test-common.hpp"
#include "Vdff.h"

void setClock(Vdff& core, uint8_t clock) {
    core.clk = clock;
}

using UUT = Vdff;

struct DffFixture : TestFixture<UUT> {
    Input8 d;
    Output8 q;
    DffFixture() :
        d(makeInput(&UUT::d)),
        q(makeOutput(&UUT::q))
    {
    }
};

using Fixture = DffFixture;

TEST_CASE_METHOD(Fixture, "dff: Test", "[hdlbits]")
{
    // bench.openTrace("/tmp/dff.vcd");
    d.addInputs({
        {2, 1}, {5, 0}, {7, 1}
    });

    bench.tick(15);

    CHECK(q.changes() == ChangeVector8({
        {3, 1}, {6, 0}, {8, 1}
    }));
}
