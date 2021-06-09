# Copyright (c) 2020-2021 R. Tohid (@rtohid)
#
#  Distributed under the Boost Software License, Version 1.0. (See accompanying
#  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

BASE_DIR=$(HOME)/git

# TIRAMISU
TIRAMISU_ROOT=$(BASE_DIR)/tiramisu
TIRAMISU_LIB_DIR=$(TIRAMISU_ROOT)/build
TIRAMISU_INC_DIR=$(TIRAMISU_ROOT)/include

# ISL
ISL_SOURCE_BASE_DIR=$(TIRAMISU_ROOT)/3rdParty/isl
ISL_ROOT=$(ISL_SOURCE_BASE_DIR)/build
ISL_LIB_DIR=$(ISL_ROOT)/lib
ISL_INC_DIR=$(ISL_ROOT)/include

# HALIDE
HALIDE_ROOT=$(TIRAMISU_ROOT)/3rdParty/Halide
HALIDE_LIB_DIR=$(HALIDE_ROOT)/bin
HALIDE_INC_DIR=$(HALIDE_ROOT)/include


tutorial_01:
	mkdir -p build
	g++ -std=c++11 -fno-rtti -DHALIDE_NO_JPEG \
		-I${TIRAMISU_ROOT}/include -I${TIRAMISU_ROOT}/3rdParty/isl/include/ \
		-I${TIRAMISU_ROOT}/3rdParty/Halide/include -I${TIRAMISU_ROOT}/build \
		-L${TIRAMISU_ROOT}/build -L${TIRAMISU_ROOT}/3rdParty/isl/build/lib \
		-L${TIRAMISU_ROOT}/3rdParty/Halide/lib/ \
		-o developers_tutorial_01_fct_generator \
		-Wl,-rpath,${TIRAMISU_ROOT}/build tutorial_01.cpp \
		-ltiramisu -lisl -lHalide -ldl -lpthread -lz -lm

	./developers_tutorial_01_fct_generator
	
	g++ -std=c++11 -fno-rtti \
		-I${TIRAMISU_ROOT}/include -I${TIRAMISU_ROOT}/3rdParty/Halide/include \
		-L${TIRAMISU_ROOT}/build -L${TIRAMISU_ROOT}/3rdParty/Halide/lib/ \
		-o build/wrapper_tutorial_01 \
		-Wl,-rpath,${TIRAMISU_ROOT}/build wrapper_tutorial_01.cpp \
		build/generated_fct_developers_tutorial_01.o \
		-ltiramisu -lHalide -ldl -lpthread -lz -lm

clean:
	rm -f developers_tutorial_01_fct_generator
	rm -rf build