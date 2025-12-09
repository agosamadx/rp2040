cmake_minimum_required(VERSION 4.1)

include($ENV{PICO_SDK_PATH}/pico_sdk_init.cmake)

project(program C CXX ASM)

pico_sdk_init()

file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp)
file(GLOB_RECURSE HEADERS RELATIVE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/include/*.h)

add_executable(${PROJECT_NAME})

target_compile_features(
  ${PROJECT_NAME}
  PRIVATE
  cxx_std_26
)

set_target_properties(${PROJECT_NAME}
  PROPERTIES
    EXPORT_COMPILE_COMMANDS ON
)

target_compile_options(
  ${PROJECT_NAME}
  PUBLIC
)

target_compile_definitions(
  ${PROJECT_NAME}
  PRIVATE
  $<$<CONFIG:RELEASE>:NDEBUG>
)

target_sources(
  ${PROJECT_NAME}
  PRIVATE
  ${HEADERS} ${SOURCES}
)

target_include_directories(
  ${PROJECT_NAME}
  PRIVATE
  ${CMAKE_CURRENT_SOURCE_DIR}/include
)

target_link_libraries(
  ${PROJECT_NAME}
  PRIVATE
  pico_stdlib
)

install(
    FILES
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.uf2
    DESTINATION
        .
)

pico_add_extra_outputs(program)
