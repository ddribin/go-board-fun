#define CATCH_CONFIG_MAIN
#include "test-common.hpp"
#include <algorithm>

static thread_local std::string sCurrentTestName;

std::string currentTestName(void)
{
    return sCurrentTestName;
}

std::string vcdNameForCurrentTest(void)
{
    std::string s = sCurrentTestName;
    std::string invalidChars = " :/<>*?|+,";
    for (auto invalidChar : invalidChars) {
        std::replace(s.begin(), s.end(), invalidChar, '_');
    }

    return s + ".vcd";
}

struct MyListener : Catch::TestEventListenerBase {

    using TestEventListenerBase::TestEventListenerBase; // inherit constructor

    void testCaseStarting( Catch::TestCaseInfo const& testInfo ) override {
        sCurrentTestName = testInfo.name;
    }
};

CATCH_REGISTER_LISTENER( MyListener )
