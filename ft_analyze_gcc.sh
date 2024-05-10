#!/bin/bash

DATA_DIR="results/ft/graphs"
OUTPUT_FILE="results/ft/ft_analyze_gcc.tsv"

printf "contract_id\tcomp_nodes\tcomp_edges\ttransitivity\tdensity\tcoverage\telapsed_time\n" > $OUTPUT_FILE
for i in {0..99}; do
    printf "%d\t" $i >> $OUTPUT_FILE
    ./igraph/analyzer_gcc "${DATA_DIR}/ft_graph_${i}.tsv" >> $OUTPUT_FILE
done
