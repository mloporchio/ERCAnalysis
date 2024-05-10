#!/bin/bash

DATA_DIR="results/nft/graphs"
OUTPUT_FILE="results/nft/nft_analyze_full.tsv"

printf "contract_id\tnum_nodes\tnum_edges\tnum_wcc\telapsed_time\n" > $OUTPUT_FILE
for i in {0..99}; do
    printf "%d\t" $i >> $OUTPUT_FILE
    ./igraph/analyzer_full "${DATA_DIR}/nft_graph_${i}.tsv" "results/nft/nft_stats_${i}.csv" >> $OUTPUT_FILE
done
