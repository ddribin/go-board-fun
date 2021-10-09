set(BASE_NAME hdlbits)

set(LIB_TARGET_NAME ${BASE_NAME}-library)
add_library(${LIB_TARGET_NAME} STATIC)
target_compile_features(${LIB_TARGET_NAME} PUBLIC cxx_std_11)

verilate(${LIB_TARGET_NAME} SOURCES dff.v TRACE)

add_executable(dff_main dff_main.cpp)
verilate(dff_main SOURCES dff.v TRACE)

include(Catch)

set(TEST_TARGET_NAME ${BASE_NAME}-tests)
add_executable(${TEST_TARGET_NAME} dff_test.cpp)
target_compile_definitions(${TEST_TARGET_NAME} PRIVATE VERILATEST_TRACE=1)
target_link_libraries(${TEST_TARGET_NAME} PRIVATE ${LIB_TARGET_NAME})

verilatest_setup(${TEST_TARGET_NAME})
test_setup(${TEST_TARGET_NAME})
