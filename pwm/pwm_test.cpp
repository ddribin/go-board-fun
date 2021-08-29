#include "test-common.hpp"
#include "Vpwm_tb.h"

struct Vpwm_adapter : public Vpwm_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = Vpwm_adapter;

struct PwmFixture : TestFixture<UUT>
{
    Input8 top, topValid;
    Input8 compare, compareValid;
    Output8 pwm;
    PwmFixture() : top(makeInput(&UUT::i_top)),
                   topValid(makeInput(&UUT::i_top_valid)),
                   compare(makeInput(&UUT::i_compare)),
                   compareValid(makeInput(&UUT::i_compare_valid)),
                   pwm(makeOutput(&UUT::o_pwm))
    {
    }

    void setupTop(uint8_t top_)
    {
        top.addInputs({{1, top_}, {2, 0}});
        topValid.addInputs({{1, 1}, {2, 0}});
    }

    void setupCompare(uint8_t compare_)
    {
        compare.addInputs({{1, compare_}, {2, 0}});
        compareValid.addInputs({{1, 1}, {2, 0}});
    }
};

using Fixture = PwmFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[pwm]")
{
    REQUIRE(core.o_pwm == 0);
}

TEST_CASE_METHOD(Fixture, "Test no compare set", "[pwm]")
{
    bench.openTrace("/tmp/pwm_unintialized.vcd");
    bench.tick(32);
    CHECK(pwm.changes() == ChangeVector8());
}

TEST_CASE_METHOD(Fixture, "Test 0/16", "[pwm]")
{
    bench.openTrace("/tmp/pwm_0_of_16.vcd");
    setupTop(15);
    setupCompare(0);

    bench.tick(35);
    CHECK(pwm.changes() == ChangeVector8());
}

TEST_CASE_METHOD(Fixture, "Test 1/16", "[pwm]")
{
    bench.openTrace("/tmp/pwm_1_of_16.vcd");
    setupTop(15);
    setupCompare(1);

    bench.tick(35);
    CHECK(pwm.changes() == ChangeVector8({
        {2,  1}, {3,  0},
        {18, 1}, {19, 0},
        {34, 1}, {35, 0},
    }));
}

TEST_CASE_METHOD(Fixture, "Test 15/16", "[pwm]")
{
    bench.openTrace("/tmp/pwm_15_of_16.vcd");
    setupTop(15);
    setupCompare(15);

    bench.tick(35);
    CHECK(pwm.changes() == ChangeVector8({
        {2,  1}, {17, 0},
        {18, 1}, {33, 0},
        {34, 1},
    }));
}

TEST_CASE_METHOD(Fixture, "Test 16/16", "[pwm]")
{
    bench.openTrace("/tmp/pwm_16_of_16.vcd");
    setupTop(15);
    setupCompare(16);

    bench.tick(35);
    CHECK(pwm.changes() == ChangeVector8({
        {2,  1},
    }));
}
