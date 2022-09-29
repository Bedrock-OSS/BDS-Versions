#!/bin/bash

RELEASE_NOTES_PATH=release_notes

LINUX_PATH=linux
WINDOWS_PATH=windows

LINUX_MANIFEST=`curl -s ${LINUX_MANIFEST_URL} | jq`
WINDOWS_MANIFEST=`curl -s ${WINDOWS_MANIFEST_URL} | jq`

LINUX_STABLE_VERSION=`echo ${LINUX_MANIFEST} | jq -r '.version'`
WINDOWS_STABLE_VERSION=`echo ${WINDOWS_MANIFEST} | jq -r '.version'`

LINUX_CHANGELOG_URL=`echo ${LINUX_MANIFEST} | jq '.release_notes'`
WINDOWS_CHANGELOG_URL=`echo ${WINDOWS_MANIFEST} | jq '.release_notes'`

mkdir -p ${RELEASE_NOTES_PATH}/${LINUX_PATH}/
mkdir -p ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/

mkdir -p ${LINUX_PATH}/
mkdir -p ${WINDOWS_PATH}/

wget -nc ${LINUX_CHANGELOG_URL} -o ${RELEASE_NOTES_PATH}/${LINUX_PATH}/${LINUX_STABLE_VERSION}.txt
wget -nc ${WINDOWS_CHANGELOG_URL} -o ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/${WINDOWS_STABLE_VERSION}.txt

echo ${LINUX_MANIFEST} > ${LINUX_PATH}/${LINUX_STABLE_VERSION}.json
echo ${WINDOWS_MANIFEST} > ${WINDOWS_PATH}/${WINDOWS_STABLE_VERSION}.json

LINUX_VERSIONS=()
WINDOWS_VERSIONS=()

for filename in ${LINUX_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}          # strip suffix
    filename=${filename#${LINUX_PATH}/} # strip prefix

    LINUX_VERSIONS[${#LINUX_VERSIONS[@]}]="${filename}"
done

for filename in ${WINDOWS_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}            # strip suffix
    filename=${filename#${WINDOWS_PATH}/} # strip prefix

    WINDOWS_VERSIONS[${#WINDOWS_VERSIONS[@]}]="${filename}"
done

jq -n \
  --arg linux_stable "$LINUX_STABLE_VERSION" \
  --arg windows_stable "$WINDOWS_STABLE_VERSION" \
  --arg linux_versions "${LINUX_VERSIONS[*]}" \
  --arg windows_versions "${WINDOWS_VERSIONS[*]}" \
'
{
  "linux": {
    "stable": ($linux_stable),
    "versions": [($linux_versions)]
  },
  "windows": {
    "stable": ($windows_stable),
    "versions": [($windows_versions)]
  },
}
' > versions.json

cat README.header.md > README.md

echo "Latest Linux: \`$LINUX_STABLE_VERSION\`"     >> README.md
echo ""     >> README.md
echo "Latest Windows: \`$WINDOWS_STABLE_VERSION\`" >> README.md
