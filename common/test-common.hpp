#if __INTELLISENSE__
#pragma diag_suppress 2486
#endif

#include "verilatest.h"
#include <verilated.h>

#include "test-fixture.hpp"
#include "test-listener.hpp"

// This must be last so any "operator <<"" overloads work properly for test failures
#include <catch2/catch.hpp>
