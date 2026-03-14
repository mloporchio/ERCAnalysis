#!/bin/bash
#
#
#   Author: Matteo Loporchio
#

CREATOR_PATH="jars/ContractCreator.jar"
RANKING_SCRIPT="rank_contracts.py"
TMP_DIR="tmp"

FT_BASE_DIR="results/ft"
FT_INPUT_FILE="data/ft/erc20_transfers.csv"
FT_CONTRACT_FILE="data/ft/erc20_contracts.csv"
FT_RANKING_FILE="${FT_BASE_DIR}/ft_ranking.csv"
FT_OUTPUT_PREFIX="${FT_BASE_DIR}/contracts/ft_contract"

NFT_BASE_DIR="results/nft"
NFT_INPUT_FILE="data/nft/erc721_transfers.csv"
NFT_CONTRACT_FILE="data/nft/erc721_contracts.csv"
NFT_RANKING_FILE="${NFT_BASE_DIR}/nft_ranking.csv"
NFT_OUTPUT_PREFIX="${NFT_BASE_DIR}/contracts/nft_contract"

# Create all necessary directories.
mkdir -p "${TMP_DIR}" "${FT_BASE_DIR}/contracts" "${NFT_BASE_DIR}/contracts"

# Ranking phase.
echo "Computing ranking..."
python3 "${RANKING_SCRIPT}" "${FT_INPUT_FILE}" "${FT_CONTRACT_FILE}" "${FT_RANKING_FILE}" "${NFT_INPUT_FILE}" "${NFT_CONTRACT_FILE}" "${NFT_RANKING_FILE}"
echo "Done!"

# Create ERC-20 transfer lists.
echo "Creating ERC-20 transfer lists..."
FT_CONTRACT_IDS_FILE="${TMP_DIR}/ft_contract_ids.txt"
cut -d, -f2 "${FT_RANKING_FILE}" | tail -n +2 | head -n 100 > "${FT_CONTRACT_IDS_FILE}"
java -Xmx64g -jar "${CREATOR_PATH}" "${FT_INPUT_FILE}" "${FT_CONTRACT_IDS_FILE}" "${FT_OUTPUT_PREFIX}" 
echo "Done!"

# Create ERC-721 transfer lists.
echo "Creating ERC-721 transfer lists..."
NFT_CONTRACT_IDS_FILE="${TMP_DIR}/nft_contract_ids.txt"
cut -d, -f2 "${NFT_RANKING_FILE}" | tail -n +2 | head -n 100 > "${NFT_CONTRACT_IDS_FILE}"
java -Xmx64g -jar "${CREATOR_PATH}" "${NFT_INPUT_FILE}" "${NFT_CONTRACT_IDS_FILE}" "${NFT_OUTPUT_PREFIX}" 
echo "Done!"

# Delete temporary directory.
rm -rf "${TMP_DIR}"