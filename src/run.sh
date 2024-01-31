#!/bin/bash

TYPE="$1"
MODEL="$2"
PROBES="$3"
PROBES_TXT="with all probes"
PREFIX="runs/${MODEL////_}"
if [ ! -z "$PROBES" ]; then
  PROBES_TXT="with probes $PROBES"
  PROBES="--probes $PROBES"
fi

START_TIME=$(date +%s)
echo "# Starting to process type $TYPE model $MODEL $PROBES_TXT"

python3 -m garak --model_type "$TYPE" --model_name "$MODEL" $PROBES --report_prefix $PREFIX
echo "# End process"
ELAPSED=$(($(date +%s) - START_TIME))
printf "elapsed: %s\n\n" "$(date -d@$ELAPSED -u +%H\ hours\ %M\ min\ %S\ sec)"