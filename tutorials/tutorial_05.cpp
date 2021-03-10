#include <isl/set.h>
#include <isl/union_map.h>
#include <isl/union_set.h>
#include <isl/ast_build.h>
#include <isl/schedule.h>
#include <isl/schedule_node.h>

#include <tiramisu/debug.h>
#include <tiramisu/core.h>
#include "physl_tiramisu.hpp"

/**

  https://github.com/Tiramisu-Compiler/tiramisu/blob/master/tutorials/developers/tutorial_05/tutorial_05.cpp

  The goal of this tutorial is to  test reductions.
  result = 0
  for (int i = 0; i < N; i++)
       result = result + input[i];

*/

#define SIZE0 1
#define SIZE1 10

using namespace tiramisu;

void generate_function(std::string name, int size, int val0)
{
  // Set default tiramisu options.
  tiramisu::init();

  // -------------------------------------------------------
  // Layer I
  // -------------------------------------------------------

  function function0(name);
  constant N("N", expr((int32_t)size), p_int32, true, NULL, 0, &function0);
  var i = var("i");
  computation input("[N]->{input[i]}", expr(), false, p_uint8, &function0);
  computation result_init("[N]->{result_init[0]}", expr(input(0)), true, p_uint8, &function0);
  computation result("[N]->{result[i]: 1<=i<N}", expr(), true, p_uint8, &function0);
  result.set_expression((result(i - 1) + input(i)));

  // -------------------------------------------------------
  // Layer II
  // -------------------------------------------------------

  result.after(result_init, computation::root);

  // -------------------------------------------------------
  // Layer III
  // -------------------------------------------------------

  buffer input_buffer("input_buffer", {size}, p_uint8, a_input, &function0);
  buffer result_scalar("result_scalar", {1}, p_uint8, a_output, &function0);
  input.set_access("[N]->{input[i]->input_buffer[i]}");
  result_init.set_access("[N]->{result_init[i]->result_scalar[0]}");
  result.set_access("[N]->{result[i]->result_scalar[0]}");

  // -------------------------------------------------------
  // Code Generation
  // -------------------------------------------------------

  function0.codegen({&input_buffer, &result_scalar}, "build/generated_fct_developers_tutorial_05.o");
}

int main(int argc, char **argv)
{
  generate_function("tiramisu_generated_code", SIZE1, 0);

  return 0;
}
