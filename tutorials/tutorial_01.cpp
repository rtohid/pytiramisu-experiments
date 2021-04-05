#include <isl/ast_build.h>
#include <isl/schedule.h>
#include <isl/schedule_node.h>
#include <isl/set.h>
#include <isl/union_map.h>
#include <isl/union_set.h>

#include "physl_tiramisu.hpp"
#include <tiramisu/core.h>
#include <tiramisu/debug.h>

/**

  https://github.com/Tiramisu-Compiler/tiramisu/blob/master/tutorials/developers/tutorial_01/tutorial_01.cpp

  The goal of this tutorial is to implement, in Tiramisu, a code that is
  equivalent to the following

  for (int i = 0; i < 10; i++)
      buf0[i] = 3 + 4;

**/

using namespace tiramisu;

int main(int argc, char **argv) {
    tiramisu::init("function0");

    var i("i", 0, 10);
    computation S0("S0", {i}, 3 + 4);
    S0.parallelize(i);

    buffer buf0("buf0", {10}, p_uint8, a_output);
    S0.store_in(&buf0);

    tiramisu::codegen({&buf0}, "build/generated_fct_developers_tutorial_01.o");

    return 0;
}
