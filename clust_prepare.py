#
#   Author: Matteo Loporchio
#

import polars as pl
import numpy as np
import sys

FT_LABELS_FILE = sys.argv[1]
FT_GRAPH_FILE = sys.argv[2]
FT_PREP_FILE = sys.argv[3]
NFT_LABELS_FILE = sys.argv[4]
NFT_GRAPH_FILE = sys.argv[5]
NFT_PREP_FILE = sys.argv[6]

# Prepare ERC-20 data
ft_cat2int = {'defi':0,'other':1,'multimedia':2,'layer-2':3,'content':4,'blockchain':5,'gaming':6,'storage':7,'mining':8}
ft_labels = pl.read_csv(FT_LABELS_FILE, separator="\t", null_values=['None'])
ft_df = (
    pl.read_csv(FT_GRAPH_FILE, separator="\t")
    .join(ft_labels, on="rank", how="left")
    .with_columns(category_id=pl.col("category").replace_strict(ft_cat2int))
    .select("rank", "category", "category_id", "comp_nodes", "coverage", "diameter", "est_apl", "transitivity", "density")
)
relative_distance = (ft_df['est_apl'].to_numpy()) / np.log(ft_df['comp_nodes'].to_numpy())
relative_diameter = (ft_df['diameter'].to_numpy()) / np.log(ft_df['comp_nodes'].to_numpy())
ft_df = ft_df.with_columns(diameter=relative_diameter, est_apl=relative_distance)
ft_df.write_csv(FT_PREP_FILE)

# Prepare ERC-721 data
nft_cat2int = {'pfps':0,'gaming':1,'art':2,'virtual-worlds':3,'domain-names':4,'other':5} #
nft_labels = pl.read_csv(NFT_LABELS_FILE, separator="\t", null_values=['None']).with_columns(category=pl.col("category").fill_null("other"))
nft_df = (
    pl.read_csv(NFT_GRAPH_FILE, separator="\t")
    .join(nft_labels, on="rank", how="left")
    .with_columns(category_id=pl.col("category").replace_strict(nft_cat2int))
    .select("rank", "category", "category_id", "comp_nodes", "coverage", "diameter", "est_apl", "transitivity", "density")
)
relative_distance = (nft_df['est_apl'].to_numpy()) / np.log(nft_df['comp_nodes'].to_numpy())
relative_diameter = (nft_df['diameter'].to_numpy()) / np.log(nft_df['comp_nodes'].to_numpy())
nft_df = nft_df.with_columns(diameter=relative_diameter, est_apl=relative_distance)
nft_df.write_csv(NFT_PREP_FILE)