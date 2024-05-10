#!/bin/bash

CONTRACT_DIR="results/nft/contracts"
DATA_DIR="results/nft/graphs"
WEBGRAPH_DIR="results/nft/graphs/webgraph"

IGRAPH_OUTPUT_FILE="results/nft/nft_graph_builder.tsv"

printf "contract_id\tnum_nodes\tnum_edges\telapsed_time\n" > $IGRAPH_OUTPUT_FILE
for i in {0..99}; do
    printf "%d\t" $i >> $IGRAPH_OUTPUT_FILE
    # First, transform each contract event list into an edge list.
    ./igraph/builder "${CONTRACT_DIR}/nft_contract_${i}.csv" "${DATA_DIR}/nft_graph_${i}.tsv" "${DATA_DIR}/nft_map_${i}.csv" >> $IGRAPH_OUTPUT_FILE
    # Then, transform each edge list into the Webgraph format.
    java -Xmx64g -jar jars/WebgraphBuilder.jar "${DATA_DIR}/nft_graph_${i}.tsv" "${WEBGRAPH_DIR}/nft_webgraph_${i}"
done