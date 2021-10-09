#include "test-common.hpp"
#include "Vnes_controller.h"

void setClock(Vnes_controller& core, uint8_t clock) {
    core.clk = clock;
}

using UUT = Vnes_controller;

struct NesControllerFixture : TestFixture<UUT> {
    Input8 readButtons, controllerData;
    Output8 controllerLatch, controllerClock;
    Output8 buttonsValid, buttons;
    NesControllerFixture() :
        readButtons(makeInput(&UUT::i_read_buttons)),
        controllerData(makeInput(&UUT::i_controller_data)),
        controllerLatch(makeOutput(&UUT::o_controller_latch)),
        controllerClock(makeOutput(&UUT::o_controller_clock)),
        buttonsValid(makeOutput(&UUT::o_valid)),
        buttons(makeOutput(&UUT::o_buttons))
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
    bench.tick(100);
    CHECK(controllerLatch.changes() == ChangeVector8());
    CHECK(controllerClock.changes() == ChangeVector8({{1, 1}}));
    CHECK(buttonsValid.changes() == ChangeVector8());
    CHECK(buttons.changes() == ChangeVector8());
}

TEST_CASE_METHOD(Fixture, "Controller signals", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}});

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

TEST_CASE_METHOD(Fixture, "Read no buttons", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({{1, 1}});

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8());
}

TEST_CASE_METHOD(Fixture, "Read button A", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({
        {1,  1},            // Initially up
        {6,  0},            // Button A down
        {16, 1},            // Remaining buttons up
    });

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
        {12, 0b00000001},   // Shift in Button A
        {22, 0b00000010},   // Shift in Button B
        {32, 0b00000100},   // Shift in Button Select
        {42, 0b00001000},   // Shift in Button Start
        {52, 0b00010000},   // Shift in Button Up
        {62, 0b00100000},   // Shift in Button Down
        {72, 0b01000000},   // Shift in Button Left
        {82, 0b10000000},   // Shift in Button Right
        {87, 0b00000000},   // Idle
    }));
}

TEST_CASE_METHOD(Fixture, "Read button B", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({
        {1,  1},            // Initially up
        {16, 0},            // Button B down
        {26, 1},            // Remaining buttons up
    });

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
//      {12, 0b00000000},   // Shift in Button A
        {22, 0b00000001},   // Shift in Button B
        {32, 0b00000010},   // Shift in Button Select
        {42, 0b00000100},   // Shift in Button Start
        {52, 0b00001000},   // Shift in Button Up
        {62, 0b00010000},   // Shift in Button Down
        {72, 0b00100000},   // Shift in Button Left
        {82, 0b01000000},   // Shift in Button Right
        {87, 0b00000000},   // Idle
    }));
}

TEST_CASE_METHOD(Fixture, "Read button A, Select, Start", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({
        {1,  1},    // Initially up
        {6,  0},    // Button A down
        {16, 1},    // Button B up
        {26, 0},    // Select and Start down
        {46, 1},    // Remaining buttons up
    });

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
        {12, 0b00000001},   // Shift in Button A
        {22, 0b00000010},   // Shift in Button B
        {32, 0b00000101},   // Shift in Button Select
        {42, 0b00001011},   // Shift in Button Start
        {52, 0b00010110},   // Shift in Button Up
        {62, 0b00101100},   // Shift in Button Down
        {72, 0b01011000},   // Shift in Button Left
        {82, 0b10110000},   // Shift in Button Right
        {87, 0b00000000},   // Idle
    }));
}

TEST_CASE_METHOD(Fixture, "Read button right", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({
        {1,  1},            // Initially up
        {76, 0},            // Right buttons down
    });

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
    //  {12, 0b00000000},   // Shift in Button A
    //  {22, 0b00000000},   // Shift in Button B
    //  {32, 0b00000000},   // Shift in Button Select
    //  {42, 0b00000000},   // Shift in Button Start
    //  {52, 0b00000000},   // Shift in Button Up
    //  {62, 0b00000000},   // Shift in Button Down
    //  {72, 0b00000000},   // Shift in Button Left
        {82, 0b00000001},   // Shift in Button Right
        {87, 0b00000000},   // Idle
    }));
}

TEST_CASE_METHOD(Fixture, "All buttons down", "[project-01]")
{
    readButtons.addInputs({{4, 1}, {5, 0}}); // Start reading
    controllerData.addInputs({
        {1,  1},    // Initially up
        {6,  0},    // Button A down
    });

    bench.tick(100);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1}, {86, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
        {12, 0b00000001},   // Shift in Button A
        {22, 0b00000011},   // Shift in Button B
        {32, 0b00000111},   // Shift in Button Select
        {42, 0b00001111},   // Shift in Button Start
        {52, 0b00011111},   // Shift in Button Up
        {62, 0b00111111},   // Shift in Button Down
        {72, 0b01111111},   // Shift in Button Left
        {82, 0b11111111},   // Shift in Button Right
        {87, 0b00000000},   // Idle
    }));
}

TEST_CASE_METHOD(Fixture, "Multiple reads", "[project-01]")
{
    readButtons.addInputs({
        {4,   1}, {5,   0},
        {104, 1}, {105, 0},
    });
    controllerData.addInputs({
        {1,   1},   // Initially up
        {16,  0},   // Button B down
        {26,  1},   // Select, Sart, Up, Down, Left up
        {76,  0},   // Right button down
        {106, 0},   // Button A down
        {116, 1},   // Remaining buttons up
    });

    bench.tick(200);

    CHECK(buttonsValid.changes() == ChangeVector8({ 
        {85, 1},  {86, 0},
        {185, 1}, {186, 0},
    }));
    CHECK(buttons.changes() == ChangeVector8({
    //  {12,  0b00000000},  // Shift in Button A
        {22,  0b00000001},  // Shift in Button B
        {32,  0b00000010},  // Shift in Button Select
        {42,  0b00000100},  // Shift in Button Start
        {52,  0b00001000},  // Shift in Button Up
        {62,  0b00010000},  // Shift in Button Down
        {72,  0b00100000},  // Shift in Button Left
        {82,  0b01000001},  // Shift in Button Right
        {87,  0b00000000},  // Idle

        {112, 0b00000001},  // Shift in Button A
        {122, 0b00000010},  // Shift in Button B
        {132, 0b00000100},  // Shift in Button Select
        {142, 0b00001000},  // Shift in Button Start
        {152, 0b00010000},  // Shift in Button Up
        {162, 0b00100000},  // Shift in Button Down
        {172, 0b01000000},  // Shift in Button Left
        {182, 0b10000000},  // Shift in Button Right
        {187, 0b00000000},  // Idle
    }));
}
