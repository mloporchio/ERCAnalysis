#!/bin/bash
#
#   Author: Matteo Loporchio
#

BIN_DIR="bin"
TMP_DIR="tmp"
IGRAPH_ANALYZER_FULL="${BIN_DIR}/graph_analyzer_full"
IGRAPH_ANALYZER_GCC="${BIN_DIR}/graph_analyzer_gcc"
WEBGRAPH_ANALYZER="jars/PathAnalyzer.jar"

FT_BASE_DIR="results/ft"
FT_GRAPH_DIR="${FT_BASE_DIR}/graphs"
FT_WEBGRAPH_DIR="${FT_BASE_DIR}/webgraphs"
FT_OUTPUT_FILE="${FT_BASE_DIR}/ft_graph_analysis.tsv"
FT_OUTPUT_DIR="${FT_BASE_DIR}/graph_analysis"

NFT_BASE_DIR="results/nft"
NFT_GRAPH_DIR="${NFT_BASE_DIR}/graphs"
NFT_WEBGRAPH_DIR="${NFT_BASE_DIR}/webgraphs"
NFT_OUTPUT_FILE="${NFT_BASE_DIR}/nft_graph_analysis.tsv"
NFT_OUTPUT_DIR="${NFT_BASE_DIR}/graph_analysis"

mkdir -p "${TMP_DIR}" "${FT_OUTPUT_DIR}" "${NFT_OUTPUT_DIR}"

# Analyze ERC-20 networks.
echo "Analyzing ERC-20 networks..."
printf "rank\tnum_nodes\tnum_edges\tnum_wcc\tcomp_nodes\tcomp_edges\ttransitivity\tdensity\tcoverage\tdiameter\test_apl\n" > "${FT_OUTPUT_FILE}"
for i in {0..99}; do
    echo "Processing contract $i..."
    FT_IGRAPH_FILE="${FT_GRAPH_DIR}/ft_graph_${i}.tsv"
    FT_WEBGRAPH_FILE="${FT_WEBGRAPH_DIR}/ft_webgraph_${i}"
    IGRAPH_FULL_OUTPUT=$("./${IGRAPH_ANALYZER_FULL}" "${FT_IGRAPH_FILE}" "${FT_OUTPUT_DIR}/ft_full_${i}.csv")
    IGRAPH_GCC_OUTPUT=$("./${IGRAPH_ANALYZER_GCC}" "${FT_IGRAPH_FILE}" "${FT_OUTPUT_DIR}/ft_gcc_${i}.csv")
    java -Xmx128g -jar "${WEBGRAPH_ANALYZER}" "${FT_WEBGRAPH_FILE}" "${TMP_DIR}/ft_nf_${i}.csv" > "${TMP_DIR}/ft_path_${i}.log"
    WEBGRAPH_OUTPUT=$(tail -n 1 "${TMP_DIR}/ft_path_${i}.log")
    printf "%d\t" $i >> ${FT_OUTPUT_FILE}
    NUM_NODES=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f1)
    NUM_EDGES=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f2)
    NUM_WCC=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f3)
    COMP_NODES=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f1)
    COMP_EDGES=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f2)
    TRANSITIVITY=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f3)
    DENSITY=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f4)
    COVERAGE=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f5)
    DIAMETER=$(echo "$WEBGRAPH_OUTPUT" | cut -d$'\t' -f1)
    EST_APL=$(echo "$WEBGRAPH_OUTPUT" | cut -d$'\t' -f2)
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$NUM_NODES" "$NUM_EDGES" "$NUM_WCC" "$COMP_NODES" "$COMP_EDGES" "$TRANSITIVITY" "$DENSITY" "$COVERAGE" "$DIAMETER" "$EST_APL" >> "${FT_OUTPUT_FILE}"
done
echo "Analysis completed. Results saved in ${FT_OUTPUT_FILE}."

# Analyze ERC-721 networks.
echo "Analyzing ERC-721 networks..."
printf "rank\tnum_nodes\tnum_edges\tnum_wcc\tcomp_nodes\tcomp_edges\ttransitivity\tdensity\tcoverage\tdiameter\test_apl\n" > "${NFT_OUTPUT_FILE}"
for i in {0..99}; do
    echo "Processing contract $i..."
    NFT_IGRAPH_FILE="${NFT_GRAPH_DIR}/nft_graph_${i}.tsv"
    NFT_WEBGRAPH_FILE="${NFT_WEBGRAPH_DIR}/nft_webgraph_${i}"
    IGRAPH_FULL_OUTPUT=$("./${IGRAPH_ANALYZER_FULL}" "${NFT_IGRAPH_FILE}" "${NFT_OUTPUT_DIR}/nft_full_${i}.csv")
    IGRAPH_GCC_OUTPUT=$("./${IGRAPH_ANALYZER_GCC}" "${NFT_IGRAPH_FILE}" "${NFT_OUTPUT_DIR}/nft_gcc_${i}.csv")
    java -Xmx128g -jar "${WEBGRAPH_ANALYZER}" "${NFT_WEBGRAPH_FILE}" "${TMP_DIR}/nft_nf_${i}.csv" > "${TMP_DIR}/nft_path_${i}.log"
    WEBGRAPH_OUTPUT=$(tail -n 1 "${TMP_DIR}/nft_path_${i}.log")
    printf "%d\t" $i >> ${NFT_OUTPUT_FILE}
    NUM_NODES=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f1)
    NUM_EDGES=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f2)
    NUM_WCC=$(echo "$IGRAPH_FULL_OUTPUT" | cut -d$'\t' -f3)
    COMP_NODES=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f1)
    COMP_EDGES=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f2)
    TRANSITIVITY=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f3)
    DENSITY=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f4)
    COVERAGE=$(echo "$IGRAPH_GCC_OUTPUT" | cut -d$'\t' -f5)
    DIAMETER=$(echo "$WEBGRAPH_OUTPUT" | cut -d$'\t' -f1)
    EST_APL=$(echo "$WEBGRAPH_OUTPUT" | cut -d$'\t' -f2)
    printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$NUM_NODES" "$NUM_EDGES" "$NUM_WCC" "$COMP_NODES" "$COMP_EDGES" "$TRANSITIVITY" "$DENSITY" "$COVERAGE" "$DIAMETER" "$EST_APL" >> "${NFT_OUTPUT_FILE}"
done
echo "Analysis completed. Results saved in ${NFT_OUTPUT_FILE}."

rm -rf "${TMP_DIR}"