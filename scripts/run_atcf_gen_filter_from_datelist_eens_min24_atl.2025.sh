#!/usr/bin/ksh

# This is the driver for the script that filters the atcf_gen files
# to keep only storms that are truly TCs that live for a minimum,
# specified period of time and meet CPS thresholds.
#
# Written by Tim Marchok, 8/11/2023
#
basin=altg
#module load python/3.12.0
python3 --version
which python
which python3
scrdir=/lfs/h2/emc/ens/noscrub/hananeh.jafary/ens_package_20260512/scripts
rawbase=/lfs/h2/emc/ptmp/hananeh.jafary/eens_genesis_00.o4030125/eens
stormdir=/lfs/h2/emc/ptmp/hananeh.jafary

datelist_file=${scrdir}/model_common_gen_dates.2025.txt

mkdir -p "${stormdir}"

pertstring="p01 p02 p03 p04 p05 p06 p07 p08 p09 p10
            p11 p12 p13 p14 p15 p16 p17 p18 p19 p20
            p21 p22 p23 p24 p25
            n01 n02 n03 n04 n05 n06 n07 n08 n09 n10
            n11 n12 n13 n14 n15 n16 n17 n18 n19 n20
            n21 n22 n23 n24 n25"

for model in ${pertstring}; do

    # Convert directory member name to track member name:
    # p01 -> ep01
    # n01 -> en01
    model_id="e${model}"

    rawdir="${rawbase}/${model}"

    echo "========================================"
    echo "Processing model=${model}"
    echo "model_id=${model_id}"
    echo "rawdir=${rawdir}"
    echo "========================================"

    if [ ! -d "${rawdir}" ]; then
        echo "xxxx Raw directory does not exist: ${rawdir}"
        continue
    fi

    cd "${rawdir}" || continue

    while IFS= read -r iymdh
    do

        trakfile="trak.${model_id}.atcf_gen.${basin}.${iymdh}"
        outfile="${stormdir}/storms.${model_id}.atcf_gen.${basin}.${iymdh}"

        if [ -s "${trakfile}" ]; then

            set +x
	    echo "${trakfile}"
            echo "+++ Processing ${model_id} tracks for ${iymdh}...."
            set -x

            # Prevent accidentally using an old output file
            rm -f storms_filtered

            ${scrdir}/filter_tracks_6h_min24h.sh "${trakfile}"

            if [ -s storms_filtered ]; then
                set +x
                echo "  ---> A-Okay: Moving processed storm file for ${model_id} ${iymdh}...."
                set -x

                mv storms_filtered "${outfile}"
            else
                set +x
                echo "  xxxx No processed storm file for ${model_id} ${iymdh}...."
                set -x
            fi

        else
            set +x
            echo "  xxxx No original trak file for ${model_id} ${iymdh}...."
            set -x
        fi

    done < "${datelist_file}"

done
