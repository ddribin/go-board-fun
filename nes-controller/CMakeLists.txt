set(BASE_NAME nes-controller)

set(LIB_TARGET_NAME ${BASE_NAME}-library)
add_library(${LIB_TARGET_NAME} STATIC)
target_compile_features(${LIB_TARGET_NAME} PUBLIC cxx_std_11)

verilate(${LIB_TARGET_NAME} SOURCES nes_controller.v TRACE
    VERILATOR_ARGS -GCYCLES_PER_PULSE=5)
verilate(${LIB_TARGET_NAME} SOURCES nes_controller_top.v)

include(Catch)

set(TEST_TARGET_NAME ${BASE_NAME}-tests)
add_executable(${TEST_TARGET_NAME} test_nes_controller.cpp)
target_compile_definitions(${TEST_TARGET_NAME} PRIVATE VERILATEST_TRACE=1)
target_link_libraries(${TEST_TARGET_NAME} PRIVATE ${LIB_TARGET_NAME})

verilatest_setup(${TEST_TARGET_NAME})
test_setup(${TEST_TARGET_NAME})
