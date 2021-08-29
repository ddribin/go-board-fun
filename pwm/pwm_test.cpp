#include "test-common.hpp"
#include "Vpwm_tb.h"

struct Vpwm_adapter : public Vpwm_tb
{
    void setClock(uint64_t clock) { i_clk = clock; }
};

using UUT = Vpwm_adapter;

struct PwmFixture : TestFixture<UUT> {
    Input8 configCompare, configValid;
    Output8 pwm;
    PwmFixture() :
        configCompare(makeInput(&UUT::i_config_compare)),
        configValid(makeInput(&UUT::i_config_valid)),
        pwm(makeOutput(&UUT::o_pwm))
    {
    }
};

using Fixture = PwmFixture;

TEST_CASE_METHOD(Fixture, "Initial state", "[pwm]")
{
    REQUIRE(core.o_pwm == 0);
}

TEST_CASE_METHOD(Fixture, "Test no compare set", "[pwm]")
{
    bench.tick(32);
    CHECK(pwm.changes() == ChangeVector8());
}

TEST_CASE_METHOD(Fixture, "Test compare == 1", "[pwm]")
{
    bench.openTrace("/tmp/pwm_compare_1.vcd");
    configCompare.addInputs({{1, 2}});
    configValid.addInputs({{1, 1}, {2, 0}});

    bench.tick(35);
    CHECK(pwm.changes() == ChangeVector8());
}

