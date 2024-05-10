#!/bin/bash

INPUT_FILE="data/ft/erc20_transfers.csv"
CONTRACT_IDS_FILE="results/ft/ranking/ft_top_ids_nofilter.txt"
OUTPUT_PATH_PREFIX="results/ft/contracts/ft_contract"

java -Xmx64g -jar jars/ContractCreator.jar "${INPUT_FILE}" "${CONTRACT_IDS_FILE}" "${OUTPUT_PATH_PREFIX}" 