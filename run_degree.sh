#!/bin/bash
#
#   Author: Matteo Loporchio
#

ASSOR_EXEC="./bin/graph_assortativity"
PLFIT_EXEC="~/plfit-1.0.1/build/src/plfit"
TMP_DIR="tmp"
FT_OUTPUT_FILE="results/ft/ft_degree.tsv"
NFT_OUTPUT_FILE="results/nft/nft_degree.tsv"

mkdir -p $TMP_DIR

echo "Processing ERC-20 graphs..."
printf "rank\talpha\tx_min\tL\tD\tp_value\tassortativity\n" > $FT_OUTPUT_FILE
for i in {0..99}; do
    echo "Processing graph ${i}..."
    INPUT_FILE="results/ft/graphs/ft_graph_${i}.tsv"
    TEMP_FILE="${TMP_DIR}/ft_out_${i}.csv"
    DEG_FILE="${TMP_DIR}/ft_deg_${i}.txt"
    # Compute the assortativity coefficient.
    echo "Computing assortativity for graph ${i}..."
    ASSOR_OUTPUT=$( ${ASSOR_EXEC} ${INPUT_FILE} ${TEMP_FILE} )
    ASSORTATIVITY=$(echo $ASSOR_OUTPUT | cut -d' ' -f3)
    echo "Done!"
    # Preparing input data for plfit.
    cat ${TEMP_FILE} | tail -n +2 | cut -d, -f2 > ${DEG_FILE}
    echo "Fitting power law for graph ${i}..."
    # Fitting power law to input data.
    if PLFIT_OUT=$((eval ${PLFIT_EXEC} -p exact -e 0.1 -b ${DEG_FILE}) 2>/dev/null); then
        echo "Done!"
        # Fitted exponent, minimum X value, log-likelihood (L), Kolmogorov-Smirnov statistic (D) and p-value (p)
        ALPHA=$(echo $PLFIT_OUT | cut -d' ' -f3)
        X_MIN=$(echo $PLFIT_OUT | cut -d' ' -f4)
        LL=$(echo $PLFIT_OUT | cut -d' ' -f5)
        KS=$(echo $PLFIT_OUT | cut -d' ' -f6)
        P_VALUE=$(echo $PLFIT_OUT | cut -d' ' -f7)
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$i" "$ALPHA" "$X_MIN" "$LL" "$KS" "$P_VALUE" "$ASSORTATIVITY" >> $FT_OUTPUT_FILE
    else
        echo "Error: fitting failure for graph ${i}."
        rm -rf $TEMP_DIR
        exit 1
    fi
    rm -f ${TEMP_FILE} ${DEG_FILE}
done
echo "All graphs completed!"

echo "Processing ERC-721 graphs..."
printf "rank\talpha\tx_min\tL\tD\tp_value\tassortativity\n" > $NFT_OUTPUT_FILE
for i in {0..99}; do
    echo "Processing graph ${i}..."
    INPUT_FILE="results/nft/graphs/nft_graph_${i}.tsv"
    TEMP_FILE="${TMP_DIR}/nft_out_${i}.csv"
    DEG_FILE="${TMP_DIR}/nft_deg_${i}.txt"
    # Compute the assortativity coefficient.
    echo "Computing assortativity for graph ${i}..."
    ASSOR_OUTPUT=$( ${ASSOR_EXEC} ${INPUT_FILE} ${TEMP_FILE} )
    ASSORTATIVITY=$(echo $ASSOR_OUTPUT | cut -d' ' -f3)
    echo "Done!"
    # Preparing input data for plfit.
    cat ${TEMP_FILE} | tail -n +2 | cut -d, -f2 > ${DEG_FILE}
    echo "Fitting power law for graph ${i}..."
    # Fitting power law to input data.
    if PLFIT_OUT=$((eval ${PLFIT_EXEC} -p exact -e 0.1 -b ${DEG_FILE}) 2>/dev/null); then
        echo "Done!"
        # Fitted exponent, minimum X value, log-likelihood (L), Kolmogorov-Smirnov statistic (D) and p-value (p)
        ALPHA=$(echo $PLFIT_OUT | cut -d' ' -f3)
        X_MIN=$(echo $PLFIT_OUT | cut -d' ' -f4)
        LL=$(echo $PLFIT_OUT | cut -d' ' -f5)
        KS=$(echo $PLFIT_OUT | cut -d' ' -f6)
        P_VALUE=$(echo $PLFIT_OUT | cut -d' ' -f7)
        printf "%s\t%s\t%s\t%s\t%s\t%s\t%s\n" "$i" "$ALPHA" "$X_MIN" "$LL" "$KS" "$P_VALUE" "$ASSORTATIVITY" >> $NFT_OUTPUT_FILE
    else
        echo "Error: fitting failure for graph ${i}."
        rm -rf $TEMP_DIR
        exit 1
    fi
    rm -f ${TEMP_FILE} ${DEG_FILE}
done
echo "All graphs completed!"

rm -rf $TEMP_DIR
exit 0


