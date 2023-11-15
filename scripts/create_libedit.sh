#!/bin/sh
set -e

ROOT_DIR="$(realpath .)"
NETBSD_SRC=""
STAGING_DIR="${ROOT_DIR}/staging"

# check if "${NETBSD_SRC}" is empty
if [ "${NETBSD_SRC}" == "" ]; then
    echo 'ERROR: ${NETBSD_SRC} is not set'
    exit 1
fi

cp -r "${NETBSD_SRC}/lib/libedit" "${STAGING_DIR}"

# source files
rm -r "${ROOT_DIR}/src/readline"
mv "${STAGING_DIR}"/*.c "${STAGING_DIR}"/*.h "${STAGING_DIR}/readline" \
    "${STAGING_DIR}/Makefile" "${STAGING_DIR}/shlib_version" "${ROOT_DIR}/src"

# tests
rm -r "${ROOT_DIR}/tests" || true
mv "${STAGING_DIR}/TEST" "${ROOT_DIR}/tests"

# man pages and scripts
mv "${STAGING_DIR}/editline.3" "${STAGING_DIR}/editrc.5" \
    "${STAGING_DIR}/editline.7" "${ROOT_DIR}/doc"
mv "${STAGING_DIR}/makelist" "${ROOT_DIR}/scripts"

# changelog
mv "${STAGING_DIR}"/ChangeLog "${ROOT_DIR}"
cd $NETBSD_SRC
git log lib/libedit > "${ROOT_DIR}/ChangeLog-full"
cd "${ROOT_DIR}"

rm -r "${STAGING_DIR}"
