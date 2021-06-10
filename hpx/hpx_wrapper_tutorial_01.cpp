#include <hpx/hpx_main.hpp>
#include <hpx/iostream.hpp>
#include <hpx/hpx_init.hpp>
#include <hpx/include/lcos.hpp>
#include <hpx/include/util.hpp>

#include "wrapper_tutorial_01.h"

int main()
{
    // Say hello to the world!
    hpx::cout << "Hello World!\n" << hpx::flush;

    int N = 1000000;

    Halide::Buffer<int32_t> output(N);
    init_buffer(output, (int32_t)9);

    std::cout << "Array (after initialization)" << std::endl;
    // print_buffer(output);

    std::future<int> fut = std::async(function0, output.raw_buffer());

    // do something while waiting for function to set future:
    std::cout << "checking, please wait";
    std::chrono::milliseconds span(1);
    while (fut.wait_for(span) == std::future_status::timeout)
        std::cout << '.' << std::flush;

    int x = fut.get();     // retrieve return value

    Halide::Buffer<int32_t> expected(N);
    init_buffer(expected, (int32_t)7);
    std::cout << std::endl;

    compare_buffers("tutorial_01", output, expected);

    return 0;
}
