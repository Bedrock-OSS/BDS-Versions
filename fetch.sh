#!/bin/bash

RELEASE_NOTES_PATH=release_notes

LINUX_PATH=linux
WINDOWS_PATH=windows

LAST_KNOWN_LINUX_STABLE_VERSION=`cat versions.json | jq -r '.linux.stable'`
LAST_KNOWN_WINDOWS_STABLE_VERSION=`cat versions.json | jq -r '.windows.stable'`

LINUX_MANIFEST=`curl -s ${LINUX_MANIFEST_URL} | jq`
WINDOWS_MANIFEST=`curl -s ${WINDOWS_MANIFEST_URL} | jq`

LINUX_STABLE_VERSION=`echo ${LINUX_MANIFEST} | jq -r '.version'`
WINDOWS_STABLE_VERSION=`echo ${WINDOWS_MANIFEST} | jq -r '.version'`

LINUX_CHANGELOG_URL=`echo ${LINUX_MANIFEST} | jq -r '.release_notes'`
WINDOWS_CHANGELOG_URL=`echo ${WINDOWS_MANIFEST} | jq -r '.release_notes'`

mkdir -p ${RELEASE_NOTES_PATH}/${LINUX_PATH}/
mkdir -p ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/

mkdir -p ${LINUX_PATH}/
mkdir -p ${WINDOWS_PATH}/

wget -nc ${LINUX_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${LINUX_PATH}/${LINUX_STABLE_VERSION}.txt
wget -nc ${WINDOWS_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/${WINDOWS_STABLE_VERSION}.txt

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

if [ "$LAST_KNOWN_LINUX_STABLE_VERSION" == "$LINUX_STABLE_VERSION" ]; then
  echo "No change in linux stable version"
  echo "::set-output name=trigger_linux_stable_build::false"
else
  echo "New version of linux stable detected [${LAST_KNOWN_LINUX_STABLE_VERSION}] -> [${LINUX_STABLE_VERSION}]"
  echo "::set-output name=trigger_linux_stable_build::true"
fi

echo "::set-output name=latest_linux_version::${LINUX_STABLE_VERSION}"
echo "::set-output name=latest_windows_version::${WINDOWS_STABLE_VERSION}"

LINUX_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${LINUX_VERSIONS[@]}"`
WINDOWS_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${WINDOWS_VERSIONS[@]}"`

jq -n \
  --arg linux_stable "$LINUX_STABLE_VERSION" \
  --arg windows_stable "$WINDOWS_STABLE_VERSION" \
  --argjson linux_versions "${LINUX_VERSIONS_JSON}" \
  --argjson windows_versions "${WINDOWS_VERSIONS_JSON}" \
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
