#!/bin/bash

#SBATCH -J prodigal
#SBATCH -N 1
#SBATCH -n 1
#SBATCH -p normal
#SBATCH -t 24:00:00
#SBATCH -A iPlant-Collabs

set -u

QUERY=""
OUT_DIR="$PWD/prodigal-out"
CLOSED_ENDS=0
OUTPUT_FORMAT='gff'
NS_AS_MASKED=0
BYPASS_SHINE_DALGARNO=0
PROCEDURE='single'
IMG="prodigal-2.6.3.img"
PRODIGAL="singularity exec $IMG prodigal"

export LAUNCHER_DIR="$HOME/src/launcher"
export LAUNCHER_PLUGIN_DIR="$LAUNCHER_DIR/plugins"
export LAUNCHER_WORKDIR="$PWD"
export LAUNCHER_RMI="SLURM"
export LAUNCHER_SCHED="interleaved"

function lc() {
    wc -l "$1" | cut -d ' ' -f 1
}

function HELP() {
    printf "Usage:\n  %s -q QUERY \n\n" "$(basename "$0")"
  
    echo "Required arguments:"
    echo ""
    echo " -q QUERY (dirs/files)"
    echo ""
    echo "Optional arguments:"
    echo " -c CLOSED_ENDS ($CLOSED_ENDS)"
    echo " -f OUTPUT_FORMAT ($OUTPUT_FORMAT)"
    echo " -m NS_AS_MASKED ($NS_AS_MASKED)"
    echo " -n BYPASS_SHINE_DALGARNO ($BYPASS_SHINE_DALGARNO)"
    echo " -p PROCEDURE ($PROCEDURE)"
    echo " -o OUT_DIR ($OUT_DIR)"
    exit 0
}

[[ $# -eq 0 ]] && HELP

while getopts :f:o:p:q:cmnh OPT; do
    case $OPT in
      c)
          CLOSED_ENDS="1"
          ;;
      f)
          OUTPUT_FORMAT="$OPTARG"
          ;;
      h)
          HELP
          ;;
      m)
          NS_AS_MASKED="1"
          ;;
      n)
          BYPASS_SHINE_DALGARNO="1"
          ;;
      o)
          OUT_DIR="$OPTARG"
          ;;
      p)
          PROCEDURE="$OPTARG"
          ;;
      q)
          QUERY="$QUERY $OPTARG"
          ;;
      :)
          echo "Error: Option -$OPTARG requires an argument."
          exit 1
          ;;
      \?)
          echo "Error: Invalid option: -${OPTARG:-""}"
          exit 1
    esac
done

if [[ -z "$QUERY" ]]; then
    echo "-q QUERY is required"
    exit 1
fi

INPUT_FILES=$(mktemp)
for QRY in $QUERY; do
    echo "QRY \"$QRY\""
    if [[ -f "$QRY" ]]; then
        echo "$QRY" >> "$INPUT_FILES"
    elif [[ -d "$QRY" ]]; then
        find "$QRY" -type f -size +0c >> "$INPUT_FILES"
    else
        echo "\"$QRY\" is neither file nor directory"
    fi
done

NUM_FILES=$(lc "$INPUT_FILES")
if [[ $NUM_FILES -lt 1 ]]; then
    echo "Found no input files in QUERY"
    exit 1
fi

echo "Will process NUM_FILES \"$NUM_FILES\""

[[ ! -d "$OUT_DIR" ]] && mkdir -p "$OUT_DIR"

ARGS="-f $OUTPUT_FORMAT -p $PROCEDURE"
[[ $CLOSED_ENDS -gt 0 ]] && ARGS="$ARGS -c"
[[ $NS_AS_MASKED -gt 0 ]] && ARGS="$ARGS -m"
[[ $BYPASS_SHINE_DALGARNO -gt 0 ]] && ARGS="$ARGS -n"
PARAM="$$.param"

i=0
while read -r FILE; do
    let i++
    BASENAME=$(basename "$FILE")
    printf "%3d: %s\n" $i "$BASENAME"
    DIR="$OUT_DIR/$BASENAME"
    [[ ! -d "$DIR" ]] && mkdir -p "$DIR"
    echo "$PRODIGAL $ARGS -a $DIR/proteins -d $DIR/nucl -i $FILE -o $DIR/prodigal -s $DIR/genes" >> "$PARAM"
done < "$INPUT_FILES"

NJOBS=$(lc "$PARAM")

if [[ $NJOBS -lt 1 ]]; then
    echo 'No launcher jobs to run!'
else
    export LAUNCHER_JOB_FILE="$PARAM"
    [[ $NJOBS -ge 16 ]] && export LAUNCHER_PPN=16
    echo "Starting NJOBS \"$NJOBS\" $(date)"
    "$LAUNCHER_DIR/paramrun"
    echo "Ended LAUNCHER $(date)"
fi

echo "Done."
echo "Comments to kyclark@email.arizona.edu"
