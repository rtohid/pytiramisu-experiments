__license__ = """
Copyright (c) 2021 Shahrzad Shirzad (@shahrzad)
Copyright (c) 2021 R. Tohid (@rtohid)

Distributed under the Boost Software License, Version 1.0. (See accompanying
file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)
"""

from pytiramisu import a_input, a_output, argument_t, buffer, codegen_physl
from pytiramisu import computation, constant, expr, function, init_physl
from pytiramisu import p_uint8, p_int32, p_float32, primitive_t, var

"""
Implementation of axpy in PyTIramisu 
https://github.com/Tiramisu-Compiler/tiramisu/blob/a9972a21e2b966f7d3719c583c04dfc2112e3fe5/benchmarks/linear_algebra/blas/level1/axpy/
"""
init_physl("function0")

f = function("function0")
N = constant("N", expr(20), p_int32, True, None, 0, f)
i = var("i")
j = var("j")
x = computation("[N]->{x[i]: 0<=i<N}", expr(), False, p_float32, f)
y = computation("[N]->{y[i]: 0<=i<N}", expr(), False, p_float32, f)
a = computation("{a[0]}", expr(), False, p_float32, f)

result = computation("[N]->{result[i]: 0<=i<N}",
                     a(i) * x(i) + y(i), True, p_float32, f)

buf_a = buffer("buf_a", list([expr(1)]), p_float32, a_input, f)
buf_x = buffer("buf_x", list([expr(10)]), p_float32, a_input, f)
buf_y = buffer("buf_y", list([expr(10)]), p_float32, a_output, f)

a.set_access("{a[0]->buf_a[0]}")
x.set_access("[N]->{x[i]->buf_x[i]: 0<=i<N}")
y.set_access("[N]->{y[i]->buf_y[i]: 0<=i<N}")
result.set_access("[N]->{result[i]->buf_y[i]: 0<=i<N}")

f.set_arguments(list([buf_a, buf_x, buf_y]))
f.gen_time_space_domain()
physl_computations = codegen_physl(list([buf_a, buf_x, buf_y]))

for computation in physl_computations:
    if len(computation['iterators']) < 1:
        print("computation is an input variable")
    for k, v in computation.items():
        print(k, v)
    print()
