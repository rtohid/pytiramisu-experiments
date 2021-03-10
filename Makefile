# Copyright (c) 2019-2020 Christopher Taylor
# Copyright (c) 2020-2021 R. Tohid (@rtohid)
#
#  Distributed under the Boost Software License, Version 1.0. (See accompanying
#  file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt)

BASE_DIR=$(HOME)/git

ISL_SOURCE_BASE_DIR=$(TIRAMISU_ROOT_DIR)/3rdParty/isl
ISL_ROOT_DIR=$(ISL_SOURCE_BASE_DIR)/build
ISL_LIB_DIR=$(ISL_ROOT_DIR)/lib
ISL_INC_DIR=$(ISL_ROOT_DIR)/include

TIRAMISU_ROOT_DIR=$(BASE_DIR)/tiramisu
TIRAMISU_LIB_DIR=$(TIRAMISU_ROOT_DIR)/build
TIRAMISU_INC_DIR=$(TIRAMISU_ROOT_DIR)/include

PHYFLOW_ROOT_DIR=$(BASE_DIR)/phyflow/backend
PHYFLOW_LIB_DIR=$(PHYFLOW_ROOT_DIR)/
PHYFLOW_INC_DIR=$(PHYFLOW_ROOT_DIR)/

APPS_ROOT_DIR=$(BASE_DIR)/pytiramisu-experiments
OBJ_DIR=$(APPS_ROOT_DIR)/obj
BIN_DIR=$(APPS_ROOT_DIR)/bin
LINALG_DIR=$(APPS_ROOT_DIR)/linalg
TUTORIAL_DIR=$(APPS_ROOT_DIR)/tutorials

INC_FLAGS=-I$(ISL_INC_DIR) -I$(TIRAMISU_INC_DIR) -I$(ISL_SOURCE_BASE_DIR) -I$(PHYFLOW_INC_DIR)
LIB_FLAGS=-L$(ISL_LIB_DIR) -L$(TIRAMISU_LIB_DIR) -L$(PHYFLOW_LIB_DIR)
LIBS=-lisl -ltiramisu
CXX_FLAGS=-g -Wall -shared -std=c++14 -fPIC
CXX_FLAGS_APP=-g -Wall -std=c++14 -fPIC $(INC_FLAGS) $(LIB_FLAGS)

CXX=clang++-8

physl_isl.o: $(PHYFLOW_ROOT_DIR)/physl_isl.cpp
	mkdir -p $(OBJ_DIR)
	$(CXX) -O3 -std=c++17 -fPIC $(INC_FLAGS) -c $(PHYFLOW_ROOT_DIR)/physl_isl.cpp -o $(OBJ_DIR)/physl_isl.o

physl_tiramisu.o: physl_isl.o $(PHYFLOW_ROOT_DIR)/physl_tiramisu.cpp
	$(CXX) -O3 -std=c++17 -fPIC $(INC_FLAGS) -c $(PHYFLOW_ROOT_DIR)/physl_tiramisu.cpp -o $(OBJ_DIR)/physl_tiramisu.o

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

axpy.py: $(LINALG_DIR)/axpy.py
	python3.8 $(LINALG_DIR)/axpy.py

tutorial_01.py: $(TUTORIAL_DIR)/tutorial_01.py
	python3.8 $(TUTORIAL_DIR)/tutorial_01.py
 
clean:
	rm -r $(OBJ_DIR)
	rm -r $(BIN_DIR)
