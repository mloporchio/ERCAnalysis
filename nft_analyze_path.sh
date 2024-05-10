#!/bin/bash

BASE_DIR="results/nft"
DATA_DIR="${BASE_DIR}/graphs/webgraph"
OUTPUT_FILE="${BASE_DIR}/nft_path.tsv"

for i in {0..99};
do
        java -Xmx128g -jar jars/PathAnalyzer.jar "${DATA_DIR}/nft_webgraph_${i}" "${BASE_DIR}/nft_nf_${i}.csv" > "${BASE_DIR}/nft_path_${i}.log"
done

printf "contract_id\tdiameter\test_apl\telapsed_time\n" > $OUTPUT_FILE
(for i in {0..99}; do printf "%d\t" $i; tail -n 1 "${BASE_DIR}/nft_path_${i}.log"; done) >> $OUTPUT_FILE

# Cleanup
rm ${BASE_DIR}/nft_path_*.log