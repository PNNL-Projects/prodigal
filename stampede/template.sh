#!/bin/bash

echo "QUERY                 \"${QUERY}\""
echo "WRITE_PROT            \"${WRITE_PROT}\""
echo "CLOSED_ENDS           \"${CLOSED_ENDS}\""
echo "WRITE_NUCL            \"${WRITE_NUCL}\""
echo "OUTPUT_FORMAT         \"${OUTPUT_FORMAT}\""
echo "NS_AS_MASKED          \"${NS_AS_MASKED}\""
echo "BYPASS_SHINE_DALGARNO \"${BYPASS_SHINE_DALGARNO}\""
echo "PROCEDURE             \"${PROCEDURE}\""
echo "WRITE_GENES           \"${WRITE_GENES}\""

sh run.sh ${QUERY} ${WRITE_PROT} ${CLOSED_ENDS} ${WRITE_NUCL} ${OUTPUT_FORMAT} ${NS_AS_MASKED} ${BYPASS_SHINE_DALGARNO} ${PROCEDURE} ${WRITE_GENES}
