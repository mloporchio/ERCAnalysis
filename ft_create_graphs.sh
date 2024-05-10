#!/bin/bash

CONTRACT_DIR="results/ft/contracts"
DATA_DIR="results/ft/graphs"
WEBGRAPH_DIR="results/ft/graphs/webgraph"

IGRAPH_OUTPUT_FILE="results/ft/ft_graph_builder.tsv"

printf "contract_id\tnum_nodes\tnum_edges\telapsed_time\n" > $IGRAPH_OUTPUT_FILE
for i in {0..99}; do
    printf "%d\t" $i >> $IGRAPH_OUTPUT_FILE
    # First, transform each contract event list into an edge list.
    ./igraph/builder "${CONTRACT_DIR}/ft_contract_${i}.csv" "${DATA_DIR}/ft_graph_${i}.tsv" "${DATA_DIR}/ft_map_${i}.csv" >> $IGRAPH_OUTPUT_FILE
    # Then, transform each edge list into the Webgraph format.
    java -Xmx64g -jar jars/WebgraphBuilder.jar "${DATA_DIR}/ft_graph_${i}.tsv" "${WEBGRAPH_DIR}/ft_webgraph_${i}"
done