#include "test-common.hpp"
#include "Vnes_controller.h"


TEST_CASE("[led] Initial state", "[project-01]")
{
    Vnes_controller core;

    core.eval();
}
