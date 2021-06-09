#include "Halide.h"
#include "wrapper_tutorial_01.h"
#include "tiramisu/utils.h"
#include <cstdlib>
#include <iostream>
#include <future>         // std::async, std::future
#include <chrono>         // std::chrono::milliseconds

int main(int, char**)
{
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
