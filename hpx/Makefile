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
	g++  -I${TIRAMISU_INC_DIR} -I${ISL_INC_DIR} -I${HALIDE_INC_DIR} -I${HALIDE_ROOT}/tools -I${TIRAMISU_LIB_DIR} \
		 -std=c++11 -Wall -Wno-sign-compare -fno-rtti -DHALIDE_NO_JPEG -g -O0 -MD -MT tutorial_01.cpp.o \
		 -c /home/stellar/git/tiramisu/tutorials/developers/tutorial_01/tutorial_01.cpp\
		 -o build/tutorial_01.o

	g++ -std=c++11 -Wall -Wno-sign-compare -fno-rtti -DHALIDE_NO_JPEG -g -O0 build/tutorial_01.o \
		-Wl,-rpath,${TIRAMISU_LIB_DIR}:${ISL_LIB_DIR} ${TIRAMISU_LIB_DIR}/libtiramisu.so \
		${HALIDE_LIB_DIR}/libHalide.so ${ISL_LIB_DIR}/libisl.so -ldl -lpthread -lrt -ldl -lpthread -lz -lm \
		-o build/tutorial_01_fct_generator  

# g++ -std=c++11 -Wall -Wno-sign-compare -fno-rtti -DHALIDE_NO_JPEG -g -O0 CMakeFiles/tutorial_developers_01.dir/tutorials/developers/tutorial_01/wrapper_tutorial_01.cpp.o generated_fct_developers_tutorial_01.o -o tutorial_developers_01  -Wl,-rpath,/home/stellar/git/tiramisu/build:/home/stellar/git/tiramisu/3rdParty/isl/build/lib libtiramisu.so ../3rdParty/Halide/lib/libHalide.a ../3rdParty/isl/build/lib/libisl.so -ldl -lpthread -lrt -ldl -lpthread -lz -lm 