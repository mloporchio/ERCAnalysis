#!/bin/bash

INPUT_FILE="data/nft/erc721_transfers.csv"
CONTRACT_IDS_FILE="results/nft/ranking/nft_top_ids_filter.txt"
OUTPUT_PATH_PREFIX="results/nft/contracts/nft_contract"

java -Xmx64g -jar jars/ContractCreator.jar "${INPUT_FILE}" "${CONTRACT_IDS_FILE}" "${OUTPUT_PATH_PREFIX}" 