# Copyright (c) 2019-2020 Christopher Taylor
# Copyright (c) 2020-2021 R. Tohid (@rtohid)
#
#  Distributed under the Boost Software License, Version 1.0. (See accompanying
#  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

BASE_DIR=$(HOME)/git

# TIRAMISU
TIRAMISU_ROOT_DIR=$(BASE_DIR)/tiramisu
TIRAMISU_LIB_DIR=$(TIRAMISU_ROOT_DIR)/build
TIRAMISU_INC_DIR=$(TIRAMISU_ROOT_DIR)/include

# ISL
ISL_SOURCE_BASE_DIR=$(TIRAMISU_ROOT_DIR)/3rdParty/isl
ISL_ROOT_DIR=$(ISL_SOURCE_BASE_DIR)/build
ISL_LIB_DIR=$(ISL_ROOT_DIR)/lib
ISL_INC_DIR=$(ISL_ROOT_DIR)/include

# HALIDE
HALIDE_SOURCE_BASE_DIR=$(TIRAMISU_ROOT_DIR)/3rdParty/Halide
HALIDE_LIB_DIR=$(HALIDE_SOURCE_BASE_DIR)/bin
HALIDE_INC_DIR=$(HALIDE_SOURCE_BASE_DIR)/include

# PHY_TIRAMUSU
PHY_TIRAMISU_ROOT_DIR=$(BASE_DIR)/phytiramisu
PHY_TIRAMISU_LIB_DIR=$(PHY_TIRAMISU_ROOT_DIR)/build
PHY_TIRAMISU_INC_DIR=$(PHY_TIRAMISU_ROOT_DIR)/include

# PyTIRAMISU
PHYFLOW_ROOT_DIR=$(BASE_DIR)/phyflow/backend
PHYFLOW_LIB_DIR=$(PHYFLOW_ROOT_DIR)/
PHYFLOW_INC_DIR=$(PHYFLOW_ROOT_DIR)/

# Compiler
CXX=clang++-8

INC_FLAGS=-I$(ISL_INC_DIR) -I$(TIRAMISU_INC_DIR) -I$(ISL_SOURCE_BASE_DIR) -I$(PHYFLOW_INC_DIR) -I$(HALIDE_INC_DIR)
LIB_FLAGS=-L$(ISL_LIB_DIR) -L$(TIRAMISU_LIB_DIR) -L$(PHYFLOW_LIB_DIR)
LIBS=-lisl -ltiramisu
CXX_FLAGS=-g -Wall -shared -std=c++14 -fPIC
CXX_FLAGS_APP=-g -Wall -std=c++14 -fPIC $(INC_FLAGS) $(LIB_FLAGS)

HALIDE_INC_FLAGS=$(INC_FLAGS) -I$(HALIDE_INC_DIR)
HALIDE_LIB_FLAGS=-L$(TIRAMISU_LIB_DIR)
HALIDE_LIBS=-ltiramisu


APPS_ROOT_DIR=$(BASE_DIR)/pytiramisu-experiments
OBJ_DIR=$(APPS_ROOT_DIR)/obj
BIN_DIR=$(APPS_ROOT_DIR)/bin
LINALG_DIR=$(APPS_ROOT_DIR)/linalg
TUTORIAL_DIR=$(APPS_ROOT_DIR)/tutorials

physl_isl.o: $(PHYFLOW_ROOT_DIR)/physl_isl.cpp
	mkdir -p $(OBJ_DIR)
	$(CXX) $(CXX_FLAGS) -O3 -std=c++17 -fPIC $(INC_FLAGS) -c $(PHYFLOW_ROOT_DIR)/physl_isl.cpp -o $(OBJ_DIR)/physl_isl.o

physl_tiramisu.o: physl_isl.o $(PHYFLOW_ROOT_DIR)/physl_tiramisu.cpp
	$(CXX) $(CXX_FLAGS) -O3 -std=c++17 -fPIC $(INC_FLAGS) -c $(PHYFLOW_ROOT_DIR)/physl_tiramisu.cpp -o $(OBJ_DIR)/physl_tiramisu.o

tutorial_01: physl_isl.o physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_01.cpp
	mkdir -p $(BIN_DIR)
	$(CXX) $(CXX_FLAGS_APP) $(OBJ_DIR)/physl_isl.o $(OBJ_DIR)/physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_01.cpp -o $(BIN_DIR)/tutorial_01 $(LIBS)

tutorial_02: physl_isl.o physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_02.cpp
	mkdir -p $(BIN_DIR)
	$(CXX) $(CXX_FLAGS_APP) $(OBJ_DIR)/physl_isl.o $(OBJ_DIR)/physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_02.cpp -o $(BIN_DIR)/tutorial_02 $(LIBS)

tutorial_05: physl_isl.o physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_05.cpp
	mkdir -p $(BIN_DIR)
	$(CXX) $(CXX_FLAGS_APP) $(OBJ_DIR)/physl_isl.o $(OBJ_DIR)/physl_tiramisu.o $(TUTORIAL_DIR)/tutorial_05.cpp -o $(BIN_DIR)/tutorial_05 $(LIBS)

axpy: physl_isl.o physl_tiramisu.o $(LINALG_DIR)/axpy.cpp

	mkdir -p $(BIN_DIR)
	$(CXX) $(CXX_FLAGS_APP) $(OBJ_DIR)/physl_isl.o $(OBJ_DIR)/physl_tiramisu.o $(LINALG_DIR)/axpy.cpp -o $(BIN_DIR)/axpy $(LIBS)

axpy_halide: $(LINALG_DIR)/axpy_halide.cpp
	mkdir -p $(BIN_DIR)
	$(CXX) $(HALIDE_INC_FLAGS)  $(LINALG_DIR)/axpy_halide.cpp -o $(BIN_DIR)/axpy_halide $(HALIDE_LIB_FLAGS) $(HALIDE_LIBS)

axpy.py: $(LINALG_DIR)/axpy.py
	python3.8 $(LINALG_DIR)/axpy.py

tutorial_01.py: $(TUTORIAL_DIR)/tutorial_01.py
	python3.8 $(TUTORIAL_DIR)/tutorial_01.py
 
clean:
	rm -rf $(OBJ_DIR)
	rm -rf $(BIN_DIR)
