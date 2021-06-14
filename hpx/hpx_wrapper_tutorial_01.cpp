#include <hpx/hpx_main.hpp>
#include <hpx/iostream.hpp>
#include <hpx/hpx_init.hpp>
#include <hpx/include/lcos.hpp>
#include <hpx/include/util.hpp>

#include "wrapper_tutorial_01.h"

hpx::future<int> wrapper(Halide::Buffer<int32_t> output){
    std::cout << "Function: wrapper" << std::endl;
    hpx::future<int> fut;
    return hpx::async(function0, output.raw_buffer());
}
int main()
{
    // Say hello to the world!
    hpx::cout << "Hello World!\n" << hpx::flush;

    int N = 1000000;

    Halide::Buffer<int32_t> output(N);
    init_buffer(output, (int32_t)9);
    hpx::future<int> fut =  wrapper(output);
    hpx::cout << "*** wrapper's called, waiting ...." << hpx::endl; 


    // hpx::cout << "Array (after initialization)" << hpx::endl;
    // print_buffer(output);


    // do something while waiting for function to set future:
    std::chrono::milliseconds span(1);
    while (fut.wait_for(span) == hpx::lcos::future_status::timeout)
        hpx::cout << '.' << hpx::flush;

    int x = fut.get();     // retrieve return value

    Halide::Buffer<int32_t> expected(N);
    init_buffer(expected, (int32_t)7);
    hpx::cout << hpx::endl;

    compare_buffers("tutorial_01", output, expected);

    return 0;
}
