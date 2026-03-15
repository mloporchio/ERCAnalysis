#
#   Author: Matteo Loporchio
#

import polars as pl
import sys

FT_INPUT_FILE=sys.argv[1]
FT_CONTRACT_FILE=sys.argv[2]
FT_OUTPUT_FILE=sys.argv[3]
NFT_INPUT_FILE=sys.argv[4]
NFT_CONTRACT_FILE=sys.argv[5]
NFT_OUTPUT_FILE=sys.argv[6]

tdf1 = pl.read_csv(FT_INPUT_FILE, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
cdf1 = pl.read_csv(FT_CONTRACT_FILE, has_header=False, new_columns=["contract_address", "contract_id"])
res1 = tdf1.group_by("contract_id").agg(pl.len().alias("count")).sort("count", descending=True)
res1 = res1.join(cdf1, on="contract_id", how="left").with_row_index("rank").select(["rank", "contract_id", "contract_address", "count"])
res1.write_csv(FT_OUTPUT_FILE, include_header=True)

df2 = pl.read_csv(NFT_INPUT_FILE, has_header=False, new_columns=["block_id", "contract_id", "from_id", "to_id"])
cdf2 = pl.read_csv(NFT_CONTRACT_FILE, has_header=False, new_columns=["contract_address", "contract_id"])
df2 = df2.filter((pl.col("from_id") > 0) & (pl.col("to_id") > 0)) # Filter out minting and burning events.
res2 = df2.group_by("contract_id").agg(pl.len().alias("count")).sort("count", descending=True)
res2 = res2.join(cdf2, on="contract_id", how="left").with_row_index("rank").select(["rank", "contract_id", "contract_address", "count"])
res2.write_csv(NFT_OUTPUT_FILE, include_header=True)