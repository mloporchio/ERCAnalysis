#!/bin/bash
#
#   This script performs all clustering experiments.
#
#   Author: Matteo Loporchio
#

PREPARE_SCRIPT="clust_prepare.py"
CLUST_SCRIPT="clust_kmeans.py"

FT_CLUST_DIR="results/ft/clustering"
NFT_CLUST_DIR="results/nft/clustering"
FT_OUTPUT_FILE="${FT_CLUST_DIR}/ft_kmeans.csv"
NFT_OUTPUT_FILE="${NFT_CLUST_DIR}/nft_kmeans.csv"

FT_LABELS_FILE="results/provided/ft_labels.tsv"
FT_GRAPH_FILE="results/ft/ft_graph_analysis.tsv"
FT_PREP_FILE="${FT_CLUST_DIR}/ft_prep.csv"
NFT_LABELS_FILE="results/provided/nft_labels.tsv"
NFT_GRAPH_FILE="results/nft/nft_graph_analysis.tsv"
NFT_PREP_FILE="${NFT_CLUST_DIR}/nft_prep.csv"

# Create output folders.
mkdir -p "${FT_CLUST_DIR}" "${NFT_CLUST_DIR}"

# Prepare data for clustering.
echo "Preparing data..."
python3 ${PREPARE_SCRIPT} ${FT_LABELS_FILE} ${FT_GRAPH_FILE} ${FT_PREP_FILE} ${NFT_LABELS_FILE} ${NFT_GRAPH_FILE} ${NFT_PREP_FILE}
echo "Done!"

# Run the K-means clustering for both token types.
echo "Running clustering..."
python3 ${CLUST_SCRIPT} ${FT_PREP_FILE} ${NFT_PREP_FILE} ${FT_OUTPUT_FILE} ${NFT_OUTPUT_FILE}
echo "Done!"