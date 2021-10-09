cmake_minimum_required(VERSION 3.19)
project(go-board-fun)

include(CTest)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})
find_package(Catch2 REQUIRED)

include(CTest)

function(test_setup TARGET_NAME)
    include(Catch)
    target_include_directories(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}/common
    )
    target_sources(${TARGET_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}/common/test-main.cpp
        ${PROJECT_SOURCE_DIR}/common/test-listener.cpp
    )
    target_link_libraries(${TARGET_NAME} PRIVATE Catch2::Catch2)
    catch_discover_tests(${TARGET_NAME})
endfunction()

add_subdirectory(verilatest)

add_subdirectory(nes-controller)
add_subdirectory(pwm)
add_subdirectory(hdlbits)

