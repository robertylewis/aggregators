#!/bin/bash

# Global 
mkdir outputs
INPUT_DIR="inputs/"
OUTPUT_DIR="outputs/"
FILE_TYPE=".txt"

CMD="grep Project"
INPUT_FILE1="yw"
OUTPUT_FILE="grep-yw"
PY_COMB="python s_grep.py"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
${PY_COMB} "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}" "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"


CMD="wc"
INPUT_FILE1="yw"
OUTPUT_FILE="wc-yw"
PY_COMB="python s_wc.py"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
${PY_COMB} "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}" "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"

CMD="wc -l"
INPUT_FILE1="yw"
OUTPUT_FILE="wc-l-yw"
PY_COMB="python s_wc.py"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
${PY_COMB} "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}" "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"

CMD="wc -lm"
INPUT_FILE1="yw"
OUTPUT_FILE="wc-lm-yw"
PY_COMB="python s_wc.py"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
${PY_COMB} "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}" "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"

CMD="grep -c Project"
INPUT_FILE1="yw"
OUTPUT_FILE="grep-c-yw"
PY_COMB="python s_grep_c.py"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
${PY_COMB} "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}" "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"

CMD="grep -n Project"
INPUT_FILE1="yw"
OUTPUT_FILE="grep-n-yw"
PY_COMB="import grep_n; grep_n.s_combine"
cat "${INPUT_DIR}${INPUT_FILE1}${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-seq${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-1${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}"
cat "${INPUT_DIR}${INPUT_FILE1}-2${FILE_TYPE}" | $CMD > "${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}"
# python -c "${PY_COMB}('${OUTPUT_DIR}${OUTPUT_FILE}-1${FILE_TYPE}', '${OUTPUT_DIR}${OUTPUT_FILE}-2${FILE_TYPE}')" > "${OUTPUT_DIR}${OUTPUT_FILE}-par${FILE_TYPE}"


# grep_c.py
# grep_meta.py
# grep_n.py
# wc.py