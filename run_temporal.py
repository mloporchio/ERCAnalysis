#
#   Author: Matteo Loporchio
#

import polars as pl
import os

TIMESTAMPS_FILE = "data/block_timestamps_0-14999999.csv"
FT_RANKING_FILE = "results/ft/ft_ranking.csv"
FT_LABELS_FILE = "results/provided/ft_labels.tsv"
FT_TRANSFERS_FILE = "data/ft/erc20_transfers.csv"
NFT_RANKING_FILE = "results/nft/nft_ranking.csv"
NFT_LABELS_FILE = "results/provided/nft_labels.tsv"
NFT_TRANSFERS_FILE = "data/nft/erc721_transfers.csv"

FT_OUTPUT_DIR = "results/ft/temporal"
FT_OUTPUT_FILE_1 = f"{FT_OUTPUT_DIR}/ft_category_count.csv"
FT_OUTPUT_FILE_2 = f"{FT_OUTPUT_DIR}/ft_contract_count.csv"
NFT_OUTPUT_DIR = "results/nft/temporal"
NFT_OUTPUT_FILE_1 = f"{NFT_OUTPUT_DIR}/nft_category_count.csv"
NFT_OUTPUT_FILE_2 = f"{NFT_OUTPUT_DIR}/nft_contract_count.csv"

os.makedirs(FT_OUTPUT_DIR, exist_ok=True)
os.makedirs(NFT_OUTPUT_DIR, exist_ok=True)

# Load the block timestamp dataframe.
print("Loading block timestamp dataset...", end=" ")
timestamps = (
    pl.read_csv(TIMESTAMPS_FILE, has_header=False, new_columns=['block_id', 'timestamp'])
    .with_columns(timestamp=pl.from_epoch(pl.col("timestamp"), time_unit="s"))
)
print("Done!")

# Computes the category count dataframe. For each block, this dataframe counts
# how many transfer events were triggered by each contract category.
def category_count(ranking_file, labels_file, transfers_file):
    top_contracts=pl.read_csv(ranking_file).head(100).select("rank", "contract_id").join(
        pl.read_csv(labels_file, separator="\t"),
        on="rank",
        how="left"
    ).select("contract_id", "category")
    unique_ids = set(top_contracts["contract_id"])
    tdf = (
        pl.read_csv(transfers_file, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
        .filter(pl.col("contract_id").is_in(unique_ids))
        .filter((pl.col("from_id") > 0) & (pl.col("to_id") > 0))
    )
    res = (
        tdf.join(top_contracts, on="contract_id", how="left")
        .group_by("block_id", "category").len().sort("block_id")
        .pivot(values="len", index="block_id", on="category")
        .fill_null(0)
        .join(timestamps, on="block_id", how="left")
    )
    return res

# Computes the contract count dataframe. For each block, this dataframe counts
# how many transfer events were triggered by each of the top 100 contracts.
def contract_count(ranking_file, transfers_file):
    top_contracts=pl.read_csv(ranking_file).head(100).select("rank", "contract_id")
    unique_ids = set(top_contracts["contract_id"])
    tdf = (
        pl.read_csv(transfers_file, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
        .filter(pl.col("contract_id").is_in(unique_ids))
        .filter((pl.col("from_id") > 0) & (pl.col("to_id") > 0))
    )
    res = (
        tdf.group_by("block_id", "contract_id").len().sort("block_id")
        .pivot(values="len", index="block_id", on="contract_id")
        .fill_null(0)
        .join(timestamps, on="block_id", how="left")
    )
    return res

print("Computing category count for ERC-20 transfers...", end=" ")
res = category_count(FT_RANKING_FILE, FT_LABELS_FILE, FT_TRANSFERS_FILE)
res.write_csv(FT_OUTPUT_FILE_1)
print("Done!")

print("Computing contract count for ERC-20 transfers...", end=" ")
res = contract_count(FT_RANKING_FILE, FT_TRANSFERS_FILE)
res.write_csv(FT_OUTPUT_FILE_2)
print("Done!")

print("Computing category count for ERC-721 transfers...", end=" ")
res = category_count(NFT_RANKING_FILE, NFT_LABELS_FILE, NFT_TRANSFERS_FILE)
res.write_csv(NFT_OUTPUT_FILE_1)
print("Done!")

print("Computing contract count for ERC-721 transfers...", end=" ")
res = contract_count(NFT_RANKING_FILE, NFT_TRANSFERS_FILE)
res.write_csv(NFT_OUTPUT_FILE_2)
print("Done!")