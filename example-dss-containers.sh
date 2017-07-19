#!/bin/bash

set -e

export PYTHONPATH=`pegasus-config --python`:$PYTHONPATH

if [ ! -e montage-workflow.py ]; then
    echo "Error: You have to run this script from the top level workflow checkout" 1>&2
    exit 1
fi
rm -rf data

singularity exec \
            --bind $PWD:/srv --workdir /srv \
            shub://pegasus-isi/montage-workflow-v2 \
            /srv/montage-workflow.py \
                --tc-target container \
                --center "56.7 24.00" \
                --degrees 2.0 \
                --band dss:DSS2B:blue \
                --band dss:DSS2R:green \
                --band dss:DSS2IR:red

pegasus-plan \
        --dir work \
        --relative-dir `date +'%s'` \
        --dax data/montage.dax \
        --sites condor_pool \
        --output-site local
