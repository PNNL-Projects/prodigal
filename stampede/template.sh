IMG="/work/05066/imicrobe/singularity/prodigal-2.6.3.img"

if [[ ! -e "$IMG" ]]; then
    echo "Missing Singularity image \"$IMG\""
    exit 1
fi

singularity exec $IMG run_prodigal -o "prodigal-out" ${QUERY} ${WRITE_PROT} ${CLOSED_ENDS} ${WRITE_NUCL} ${OUTPUT_FORMAT} ${NS_AS_MASKED} ${BYPASS_SHINE_DALGARNO} ${PROCEDURE} ${WRITE_GENES}
