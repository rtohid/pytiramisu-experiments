#include <isl/ast_build.h>
#include <isl/schedule.h>
#include <isl/schedule_node.h>
#include <isl/set.h>
#include <isl/union_map.h>
#include <isl/union_set.h>

#include <tiramisu/core.h>
#include <tiramisu/debug.h>
#include <tiramisu/tiramisu.h>

#include <string.h>

using namespace tiramisu;

/**
 * Benchmark for BLAS SAXPY
 *     y = a*x + y
 */

void generate_function(std::string name, int size) {
    tiramisu::global::set_default_tiramisu_options();

    // -------------------------------------------------------
    // Layer I
    // -------------------------------------------------------

    tiramisu::function function0(name);
    tiramisu::constant N("N", tiramisu::expr((int32_t)size), p_int32, true,
                         NULL, 0, &function0);
    tiramisu::var i("i");
    tiramisu::var j("j");
    tiramisu::computation x("[N]->{x[i]: 0<=i<N}", tiramisu::expr(), false,
                            p_float32, &function0);
    tiramisu::computation y("[N]->{y[i]: 0<=i<N}", tiramisu::expr(), false,
                            p_float32, &function0);
    tiramisu::computation a("{a[0]}", tiramisu::expr(), false, p_float32,
                            &function0);
    tiramisu::computation result("[N]->{result[i]: 0<=i<N}", a(0) * x(i) + y(i),
                                 true, p_float32, &function0);

    // -------------------------------------------------------
    // Layer III
    // -------------------------------------------------------

    tiramisu::buffer buf_a("buf_a", {1}, tiramisu::p_float32, a_input,
                           &function0);
    tiramisu::buffer buf_x("buf_x", {10}, tiramisu::p_float32, a_input,
                           &function0);
    tiramisu::buffer buf_y("buf_y", {10}, tiramisu::p_float32, a_output,
                           &function0);

    a.set_access("{a[0]->buf_a[0]}");
    x.set_access("[N]->{x[i]->buf_x[i]: 0<=i<N}");
    y.set_access("[N]->{y[i]->buf_y[i]: 0<=i<N}");
    result.set_access("[N]->{result[i]->buf_y[i]: 0<=i<N}");

    // -------------------------------------------------------
    // Code Generation
    // -------------------------------------------------------

    // function0.set_arguments({&buf_a, &buf_x, &buf_y});
    // function0.gen_time_space_domain();
    // function0.gen_isl_ast();

    // physl::codegen::generate_physl({&buf_a, &buf_x, &buf_y});
    function0.codegen({&buf_a, &buf_x, &buf_y}, "hello.o");

    // function0.gen_halide_stmt();
    // function0.gen_halide_obj("generated_" + std::string(TEST_NAME_STR) +
    // ".o");
}

int main(int argc, char **argv) {
    generate_function("tiramisu_generated_code", 20);
    std::cout << "DONEd" << std::endl;

    return 0;
}
