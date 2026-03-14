#
#	File:	makefile
#	Author:	Matteo Loporchio
#

CXX=g++
CXX_FLAGS=-O3 --std=c++11 -I /data/matteoL/igraph/include/igraph
LD_FLAGS=-L /data/matteoL/igraph/lib -ligraph -fopenmp
SRC_DIR=src
OBJ_DIR=obj
BIN_DIR=bin

.PHONY: all clean

# Create output directories
$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXX_FLAGS) -c $< -o $@

$(BIN_DIR)/graph_analyzer_full: $(OBJ_DIR)/graph_analyzer_full.o
	$(CXX) $(CXX_FLAGS) $^ -o $@ $(LD_FLAGS)

$(BIN_DIR)/graph_analyzer_gcc: $(OBJ_DIR)/graph_analyzer_gcc.o
	$(CXX) $(CXX_FLAGS) $^ -o $@ $(LD_FLAGS)

$(BIN_DIR)/graph_assortativity: $(OBJ_DIR)/graph_assortativity.o
	$(CXX) $(CXX_FLAGS) $^ -o $@ $(LD_FLAGS)

$(BIN_DIR)/graph_builder: $(OBJ_DIR)/graph_builder.o
	$(CXX) $(CXX_FLAGS) $^ -o $@ $(LD_FLAGS)

all: $(BIN_DIR)/graph_analyzer_full $(BIN_DIR)/graph_analyzer_gcc $(BIN_DIR)/graph_assortativity $(BIN_DIR)/graph_builder

clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)