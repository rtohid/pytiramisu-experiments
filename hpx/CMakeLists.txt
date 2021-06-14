cmake_minimum_required(VERSION 3.13)
project(hpx_tutorial_01 CXX)
find_package(HPX REQUIRED)

set(TIRAMISU_ROOT /home/stellar/git/tiramisu)
set(TIRAMISU_INCLUDE_DIR ${TIRAMISU_ROOT}/include)
set(TIRAMISU_LIB_DIR ${TIRAMISU_ROOT}/build)

set(HALIDE_ROOT ${TIRAMISU_ROOT}/3rdParty/Halide)
set(HALIDE_LIB_DIR ${HALIDE_ROOT}/bin)
set(HALIDE_INC_DIR ${HALIDE_ROOT}/include)

set(ISL_SOURCE_BASE_DIR ${TIRAMISU_ROOT}/3rdParty/isl)
set(ISL_ROOT ${ISL_SOURCE_BASE_DIR}/build)
set(ISL_LIB_DIR ${ISL_ROOT}/lib)
set(ISL_INC_DIR ${ISL_ROOT}/include)

set(GEN_INC_DIRS ${TIRAMISU_INCLUDE_DIR} ${HALIDE_INC_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/build ${ISL_INC_DIR})
set(RUN_INC_DIRS ${TIRAMISU_INCLUDE_DIR} ${HALIDE_INC_DIR} ${CMAKE_CURRENT_SOURCE_DIR}/build)

find_library(HalideLib Halide PATHS ${HALIDE_LIB_DIR} NO_DEFAULT_PATH)
find_library(TiramisuLib tiramisu PATHS ${TIRAMISU_LIB_DIR} NO_DEFAULT_PATH)
find_library(ISLLib isl PATHS ${ISL_LIB_DIR} NO_DEFAULT_PATH)

set(GeneratedObj ${CMAKE_CURRENT_SOURCE_DIR}/build/generated_fct_developers_tutorial_01.o)
set(LIBS ${TiramisuLib} ${HalideLib} dl pthread z m)
set(GEN_LIB ${LIBS} ${ISLLib})
set(RUN_LIB HPX::hpx HPX::wrap_main HPX::iostreams_component ${LIBS} ${GeneratedObj})


# exec_program(make ${CMAKE_CURRENT_SOURCE_DIR})
add_executable(generator_tutorial_01 tutorial_01.cpp)
target_link_libraries(generator_tutorial_01  ${GEN_LIB})
target_include_directories(generator_tutorial_01 PUBLIC ${GEN_INC_DIRS})

# exec_program(${CMAKE_CURRENT_SOURCE_DIR}/generator_tutorial_01)

add_executable(futurized_tutorial_01 hpx_wrapper_tutorial_01.cpp)
target_link_libraries(futurized_tutorial_01  ${RUN_LIB})
target_include_directories(futurized_tutorial_01 PUBLIC ${RUN_INC_DIRS})

# cmake_minimum_required(VERSION 3.13)
# project(hpx_tiramisu CXX)
# find_package(HPX REQUIRED)
# set(TIRAMISU_ROOT /home/stellar/git/tiramisu)
# link_directories(${TIRAMISU_ROOT}/build ${TIRAMISU_ROOT}/3rdParty/Halide/lib)
# add_executable(tutorial_01_hpx wrapper_tutorial_01_hpx.cpp)
# target_link_libraries(tutorial_01_hpx HPX::hpx HPX::wrap_main HPX::iostreams_component ${TIRAMISU_ROOT}/build/tiramisu.so ${TIRAMISU_ROOT}/3rdParty/Halide/lib/Halide.a dl pthread z m ${CMAKE_CURRENT_SOURCE_DIR}/build/generated_fct_developers_tutorial_01.o)
# target_include_directories(tutorial_01_hpx PUBLIC ${TIRAMISU_ROOT}/include ${TIRAMISU_ROOT}/3rdParty/Halide/include)
