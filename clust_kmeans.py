#
#   This script tests all possible feature combinations with K-means clustering.
#   For each feature subset, it tests all values of k from a minimum of 2 to a maximum of 20 (included).
#   For each configuration, it prints the silhouette and homogeneity scores.
#   Homogeneity is computed with respect to the manually-assigned labels describing the application domain  
#   of the token network.
#
#   Author: Matteo Loporchio
#

#import pandas as pd
import polars as pl
import numpy as np
import itertools
import sys
from sklearn.cluster import *
from sklearn.metrics import *
from sklearn.preprocessing import *

FT_PREP_FILE = sys.argv[1]
NFT_PREP_FILE = sys.argv[2]
FT_OUTPUT_FILE = sys.argv[3]
NFT_OUTPUT_FILE = sys.argv[4]

# List of features used for clustering
FEATURES = ['coverage', 'diameter', 'est_apl', 'transitivity', 'density']
K_MIN = 2
K_MAX = 20

def run_experiment(prep_file, output_file):
    final = pl.read_csv(prep_file) #pd.read_csv(prep_file, sep=",")
    categories = final['category_id'].to_numpy() #final.category_id.values
    pt = PowerTransformer()
    fh = open(output_file, 'w')
    fh.write('features,k,silhouette,homogeneity\n')
    for num_features in range(1, len(FEATURES)+1):
        for x in list(itertools.combinations(FEATURES, num_features)):
            feature_subset = list(x)
            feature_subset_str = ' '.join(feature_subset)
            clust_data = pt.fit_transform(final[feature_subset])
            for k in np.arange(K_MIN, K_MAX+1):
                kmeans = KMeans(init='k-means++', n_clusters=k, n_init=100, max_iter=1000, random_state=1)
                pred_labels = kmeans.fit_predict(clust_data)
                sil = silhouette_score(clust_data, pred_labels)
                hom = homogeneity_score(categories, pred_labels)
                fh.write(f'{feature_subset_str},{k},{sil},{hom}\n')
    fh.close()

print("Testing ERC-20...")
run_experiment(FT_PREP_FILE, FT_OUTPUT_FILE)
print("Done!")

print("Testing ERC-721...")
run_experiment(NFT_PREP_FILE, NFT_OUTPUT_FILE)
print("Done!")