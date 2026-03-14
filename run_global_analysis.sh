#!/bin/bash
#
#   Runs the global analysis of ERC-20 and ERC-721 transfers.
#   This script computes, for each block, the number of transfers and 
#   the number of distinct contracts involved in the transfers.
#
#   Author: Matteo Loporchio
#

FT_DATA_DIR="data/ft"
NFT_DATA_DIR="data/nft"
FT_RESULTS_DIR="results/ft"
NFT_RESULTS_DIR="results/nft"

TIMESTAMP_FILE="data/block_timestamps_0-14999999.csv"
FT_TRANSFERS_FILE="$FT_DATA_DIR/erc20_transfers.csv"
NFT_TRANSFERS_FILE="$NFT_DATA_DIR/erc721_transfers.csv"
FT_BLOCK_STATS_FILE="$FT_RESULTS_DIR/ft_block_stats.csv"
NFT_BLOCK_STATS_FILE="$NFT_RESULTS_DIR/nft_block_stats.csv"

echo "Computing block statistics..."
python3 block_stats.py "$TIMESTAMP_FILE" "$FT_TRANSFERS_FILE" "$NFT_TRANSFERS_FILE" "$FT_BLOCK_STATS_FILE" "$NFT_BLOCK_STATS_FILE"
echo "Done!"