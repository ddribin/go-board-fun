cmake_minimum_required(VERSION 3.19)
project(nes-controller VERSION 1.0.0)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_library(${PROJECT_NAME}-library STATIC)
target_compile_features(${PROJECT_NAME}-library PUBLIC cxx_std_11)
target_include_directories(${PROJECT_NAME}-library PUBLIC . ../verilatest)

verilatest_setup(${PROJECT_NAME}-library)

verilate(${PROJECT_NAME}-library SOURCES nes_controller_tb.v TRACE)
verilate(${PROJECT_NAME}-library SOURCES nes_controller_top.v)

find_package(Catch2 REQUIRED)
include(CTest)
include(Catch)

add_executable(${PROJECT_NAME}-tests
    test_nes_controller.cpp
    ../common/test-common.hpp
    ../common/test-main.cpp
)

set(TEST_TARGET_NAME ${PROJECT_NAME}-tests)
target_include_directories(${TEST_TARGET_NAME} PRIVATE ../common)
target_link_libraries(${TEST_TARGET_NAME} PRIVATE
    ${PROJECT_NAME}-library Catch2::Catch2)
target_compile_definitions(${TEST_TARGET_NAME} PRIVATE VERILATEST_TRACE=1)
catch_discover_tests(${TEST_TARGET_NAME})
