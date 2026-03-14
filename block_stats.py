#
#   This script computes block-level statistics for ERC-20 and ERC-721 transfers, 
#   including the number of unique contracts triggering events within the block
#   and the total number of transfers per block. 
#
#   The results are saved to two separate CSV files, one for ERC-20 and one for ERC-721 transfers.
#
#   Each of the output CSV files contains the following columns:
#   - block_id: The unique identifier of the block.
#   - timestamp: The timestamp of the block in human-readable format.
#   - num_contracts: The number of unique contracts that triggered events in the block.
#   - num_transfers: The total number of transfers that occurred in the block.
#
#   Author: Matteo Loporchio
#

import polars as pl
import sys

TIMESTAMP_FILE = sys.argv[1]
FT_TRANSFERS_FILE = sys.argv[2]
NFT_TRANSFERS_FILE = sys.argv[3]
FT_BLOCK_STATS_FILE = sys.argv[4]
NFT_BLOCK_STATS_FILE = sys.argv[5]

# Load block timestamps and convert to datetime.
timestamps = pl.read_csv(TIMESTAMP_FILE, has_header=False, new_columns=['block_id','timestamp'])
timestamps = timestamps.with_columns(timestamp=pl.from_epoch(pl.col("timestamp"), time_unit="s"))

# Analyze ERC-20 transfers.
ft_tdf = pl.read_csv(FT_TRANSFERS_FILE, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
ft_block_stats = ft_tdf.group_by("block_id").agg(pl.col("contract_id").n_unique().alias("num_contracts"), pl.len().alias("num_transfers"))
ft_block_stats = timestamps.join(ft_block_stats, on="block_id", how="left").fill_null(0).sort("block_id")
ft_block_stats.write_csv(FT_BLOCK_STATS_FILE)

# Analyze ERC-721 transfers.
nft_tdf = pl.read_csv(NFT_TRANSFERS_FILE, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
nft_block_stats = nft_tdf.group_by("block_id").agg(pl.col("contract_id").n_unique().alias("num_contracts"), pl.len().alias("num_transfers"))
nft_block_stats = timestamps.join(nft_block_stats, on="block_id", how="left").fill_null(0).sort("block_id")
nft_block_stats.write_csv(NFT_BLOCK_STATS_FILE)