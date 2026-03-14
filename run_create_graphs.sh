#!/bin/bash
#
#   Author: Matteo Loporchio
#

BIN_DIR="bin"
IGRAPH_BUILDER="./${BIN_DIR}/graph_builder"
WEBGRAPH_BUILDER="jars/WebgraphBuilder.jar"

FT_BASE_DIR="results/ft"
FT_CONTRACT_DIR="${FT_BASE_DIR}/contracts"
FT_GRAPH_DIR="${FT_BASE_DIR}/graphs"
FT_WEBGRAPH_DIR="${FT_BASE_DIR}/webgraphs"

NFT_BASE_DIR="results/nft"
NFT_CONTRACT_DIR="${NFT_BASE_DIR}/contracts"
NFT_GRAPH_DIR="${NFT_BASE_DIR}/graphs"
NFT_WEBGRAPH_DIR="${NFT_BASE_DIR}/webgraphs"

# Create all necessary directories.
mkdir -p "${FT_GRAPH_DIR}" "${FT_WEBGRAPH_DIR}" "${NFT_GRAPH_DIR}" "${NFT_WEBGRAPH_DIR}"

# Build ERC-20 graphs.
echo "Building ERC-20 graphs..."
FT_OUTPUT_FILE="${FT_BASE_DIR}/ft_graphs.tsv"
printf "rank\tnum_nodes\tnum_edges\telapsed_time\n" > $FT_OUTPUT_FILE
for i in {0..99}; do
    echo "Processing contract $i..."
    printf "%d\t" $i >> $FT_OUTPUT_FILE
    # First, transform each contract event list into an edge list.
    "${IGRAPH_BUILDER}" "${FT_CONTRACT_DIR}/ft_contract_${i}.csv" "${FT_GRAPH_DIR}/ft_graph_${i}.tsv" "${FT_GRAPH_DIR}/ft_map_${i}.csv" >> $FT_OUTPUT_FILE
    # Then, transform each edge list into the Webgraph format.
    java -Xmx64g -jar "${WEBGRAPH_BUILDER}" "${FT_GRAPH_DIR}/ft_graph_${i}.tsv" "${FT_WEBGRAPH_DIR}/ft_webgraph_${i}"
done
echo "Done!"

# Build ERC-721 graphs.
echo "Building ERC-721 graphs..."
NFT_OUTPUT_FILE="${NFT_BASE_DIR}/nft_graphs.tsv"
printf "rank\tnum_nodes\tnum_edges\telapsed_time\n" > $NFT_OUTPUT_FILE
for i in {0..99}; do
    echo "Processing contract $i..."
    printf "%d\t" $i >> $NFT_OUTPUT_FILE
    # First, transform each contract event list into an edge list.
    "${IGRAPH_BUILDER}" "${NFT_CONTRACT_DIR}/nft_contract_${i}.csv" "${NFT_GRAPH_DIR}/nft_graph_${i}.tsv" "${NFT_GRAPH_DIR}/nft_map_${i}.csv" >> $NFT_OUTPUT_FILE
    # Then, transform each edge list into the Webgraph format.
    java -Xmx64g -jar "${WEBGRAPH_BUILDER}" "${NFT_GRAPH_DIR}/nft_graph_${i}.tsv" "${NFT_WEBGRAPH_DIR}/nft_webgraph_${i}"
done
echo "Done!"
