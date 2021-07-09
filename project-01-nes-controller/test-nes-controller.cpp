#include "test-common.hpp"
#include "Vnes_controller_tb.h"

struct Vnes_controller_adapter : public Vnes_controller_tb
{
    void setClock(uint64_t clock) { clk = clock; }
};

using UUT = Vnes_controller_adapter;

struct NesControllerFixture : TestFixture<UUT> {
    Input8 readButtons, controllerData;
    Output8 controllerLatch, controllerClock;
    NesControllerFixture() :
        readButtons(makeInput(&UUT::i_read_buttons)),
        controllerData(makeInput(&UUT::i_controller_data)),
        controllerLatch(makeOutput(&UUT::o_controller_latch)),
        controllerClock(makeOutput(&UUT::o_controller_clock))
    {
    }
};

using Fixture = NesControllerFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[project-01]")
{
    REQUIRE(core.o_controller_latch == 0);
    REQUIRE(core.o_controller_clock == 0);
}

TEST_CASE_METHOD(Fixture, "Idle outputs", "[project-01]")
{
    bench.tick(22);
    CHECK(controllerLatch.changes() == ChangeVector8());
    CHECK(controllerClock.changes() == ChangeVector8({{1, 1}}));
}

TEST_CASE_METHOD(Fixture, "Read strobe outputs controller signals", "[project-01]")
{
    bench.openTrace("/tmp/controller-signals.vcd");
    readButtons.addInputs({{5, 1}, {6, 0}});

    bench.tick(100);

    CHECK(controllerLatch.changes() == ChangeVector8({
        {5, 1}, {10, 0}     // Button A
    }));

    CHECK(controllerClock.changes() == ChangeVector8({
        {1,  1},            // Initial pull up
        {15, 0}, {20, 1},   // Button B
        {25, 0}, {30, 1},   // Button Select
        {35, 0}, {40, 1},   // Button Start
        {45, 0}, {50, 1},   // Button Up
        {55, 0}, {60, 1},   // Button Down
        {65, 0}, {70, 1},   // Button Left
        {75, 0}, {80, 1},   // Button Right
    }));
}
