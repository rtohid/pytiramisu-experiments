#include <isl/ast_build.h>
#include <isl/schedule.h>
#include <isl/schedule_node.h>
#include <isl/set.h>
#include <isl/union_map.h>
#include <isl/union_set.h>

#include <tiramisu/core.h>
#include <tiramisu/debug.h>
#include "physl_tiramisu.hpp"

/**

  https://github.com/Tiramisu-Compiler/tiramisu/blob/master/tutorials/developers/tutorial_02/tutorial_02.cpp

  The goal of this tutorial is to implement in Tiramisu a code that is
  equivalent to the following
  for (int i = 0; i < 10; i++)
    for (int j = 0; j < 20; j++)
      output[i, j] = A[i, j] + i + 4;

*/

#define NN 10
#define MM 20

using namespace tiramisu;

int main(int argc, char** argv)
{
    tiramisu::init("tut_02");

    constant N("N", NN);
    constant M("M", MM);

    input A("A", {"i", "j"}, {N, M}, p_uint8);
    var i("i", 0, N), j("j", 0, M);

    computation output(
        "output", {i, j}, (A(i, j) + cast(p_uint8, i) + (uint8_t) 4));

    var i0("i0"), i1("i1"), j0("j0"), j1("j1");
    output.tile(i, j, 2, 2, i0, j0, i1, j1);
    output.parallelize(i0);

    buffer b_A("b_A", {expr(NN), expr(MM)}, p_uint8, a_input);
    buffer b_output("b_output", {expr(NN), expr(MM)}, p_uint8, a_output);

    A.store_in(&b_A);
    output.store_in(&b_output);

    tiramisu::codegen(
        {&b_A, &b_output}, "build/generated_fct_developers_tutorial_02.o");

    return 0;
}
