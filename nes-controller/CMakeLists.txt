set(BASE_NAME nes-controller)

set(LIB_TARGET_NAME ${BASE_NAME}-library)
add_library(${LIB_TARGET_NAME} STATIC)
target_compile_features(${LIB_TARGET_NAME} PUBLIC cxx_std_11)

verilate(${LIB_TARGET_NAME} SOURCES nes_controller.v TRACE
    VERILATOR_ARGS -GCYCLES_PER_PULSE=5)
verilate(${LIB_TARGET_NAME} SOURCES nes_controller_top.v)

include(Catch)

set(TEST_TARGET_NAME ${BASE_NAME}-tests)
add_executable(${TEST_TARGET_NAME}
    test_nes_controller.cpp
    ../common/test-common.hpp
    ../common/test-main.cpp
)

verilatest_setup(${TEST_TARGET_NAME})

target_include_directories(${TEST_TARGET_NAME} PRIVATE ../common)
target_link_libraries(${TEST_TARGET_NAME} PRIVATE
    ${LIB_TARGET_NAME} Catch2::Catch2)
target_compile_definitions(${TEST_TARGET_NAME} PRIVATE VERILATEST_TRACE=1)
catch_discover_tests(${TEST_TARGET_NAME})
