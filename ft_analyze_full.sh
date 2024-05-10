#!/bin/bash

DATA_DIR="results/ft/graphs"
OUTPUT_FILE="results/ft/ft_analyze_full.tsv"

printf "contract_id\tnum_nodes\tnum_edges\tnum_wcc\telapsed_time\n" > $OUTPUT_FILE
for i in {0..99}; do
    printf "%d\t" $i >> $OUTPUT_FILE
    ./igraph/analyzer_full "${DATA_DIR}/ft_graph_${i}.tsv" "results/ft/ft_stats_${i}.csv" >> $OUTPUT_FILE
done
