#!/bin/bash

RELEASE_NOTES_PATH=release_notes

LINUX_PATH=linux
LINUX_PREVIEW_PATH=linux_preview
WINDOWS_PATH=windows
WINDOWS_PREVIEW_PATH=windows_preview

LAST_KNOWN_LINUX_STABLE_VERSION=`cat versions.json | jq -r '.linux.stable'`
LAST_KNOWN_LINUX_PREVIEW_VERSION=`cat versions.json | jq -r '.linux.preview'`
LAST_KNOWN_WINDOWS_STABLE_VERSION=`cat versions.json | jq -r '.windows.stable'`
LAST_KNOWN_WINDOWS_PREVIEW_VERSION=`cat versions.json | jq -r '.windows.preview'`

LINUX_MANIFEST=`curl -s ${LINUX_MANIFEST_URL} | jq`
LINUX_PREVIEW_MANIFEST=`curl -s ${LINUX_PREVIEW_MANIFEST_URL} | jq`
WINDOWS_MANIFEST=`curl -s ${WINDOWS_MANIFEST_URL} | jq`
WINDOWS_PREVIEW_MANIFEST=`curl -s ${WINDOWS_PREVIEW_MANIFEST_URL} | jq`

LINUX_STABLE_VERSION=`echo ${LINUX_MANIFEST} | jq -r '.version'`
LINUX_PREVIEW_VERSION=`echo ${LINUX_PREVIEW_MANIFEST} | jq -r '.version'`
WINDOWS_STABLE_VERSION=`echo ${WINDOWS_MANIFEST} | jq -r '.version'`
WINDOWS_PREVIEW_VERSION=`echo ${WINDOWS_PREVIEW_MANIFEST} | jq -r '.version'`

LINUX_STABLE_CHANGELOG_URL=`echo ${LINUX_MANIFEST} | jq -r '.release_notes'`
LINUX_PREVIEW_CHANGELOG_URL=`echo ${LINUX_PREVIEW_MANIFEST} | jq -r '.release_notes'`
WINDOWS_STABLE_CHANGELOG_URL=`echo ${WINDOWS_MANIFEST} | jq -r '.release_notes'`
WINDOWS_PREVIEW_CHANGELOG_URL=`echo ${WINDOWS_PREVIEW_MANIFEST} | jq -r '.release_notes'`

mkdir -p ${RELEASE_NOTES_PATH}/${LINUX_PATH}/
mkdir -p ${RELEASE_NOTES_PATH}/${LINUX_PREVIEW_PATH}/
mkdir -p ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/
mkdir -p ${RELEASE_NOTES_PATH}/${WINDOWS_PREVIEW_PATH}/

mkdir -p ${LINUX_PATH}/
mkdir -p ${LINUX_PREVIEW_PATH}/
mkdir -p ${WINDOWS_PATH}/
mkdir -p ${WINDOWS_PREVIEW_PATH}/

wget -nc ${LINUX_STABLE_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${LINUX_PATH}/${LINUX_STABLE_VERSION}.txt
wget -nc ${LINUX_PREVIEW_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${LINUX_PREVIEW_PATH}/${LINUX_PREVIEW_VERSION}.txt
wget -nc ${WINDOWS_STABLE_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${WINDOWS_PATH}/${WINDOWS_STABLE_VERSION}.txt
wget -nc ${WINDOWS_PREVIEW_CHANGELOG_URL} -q -O ${RELEASE_NOTES_PATH}/${WINDOWS_PREVIEW_PATH}/${WINDOWS_PREVIEW_VERSION}.txt

echo ${LINUX_MANIFEST} > ${LINUX_PATH}/${LINUX_STABLE_VERSION}.json
echo ${LINUX_PREVIEW_MANIFEST} > ${LINUX_PREVIEW_PATH}/${LINUX_PREVIEW_VERSION}.json
echo ${WINDOWS_MANIFEST} > ${WINDOWS_PATH}/${WINDOWS_STABLE_VERSION}.json
echo ${WINDOWS_PREVIEW_MANIFEST} > ${WINDOWS_PREVIEW_PATH}/${WINDOWS_PREVIEW_VERSION}.json

LINUX_STABLE_VERSIONS=()
LINUX_PREVIEW_VERSIONS=()
WINDOWS_STABLE_VERSIONS=()
WINDOWS_PREVIEW_VERSIONS=()

for filename in ${LINUX_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}          # strip suffix
    filename=${filename#${LINUX_PATH}/} # strip prefix

    LINUX_STABLE_VERSIONS[${#LINUX_STABLE_VERSIONS[@]}]="${filename}"
done

for filename in ${LINUX_PREVIEW_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}          # strip suffix
    filename=${filename#${LINUX_PREVIEW_PATH}/} # strip prefix

    LINUX_PREVIEW_VERSIONS[${#LINUX_PREVIEW_VERSIONS[@]}]="${filename}"
done

for filename in ${WINDOWS_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}            # strip suffix
    filename=${filename#${WINDOWS_PATH}/} # strip prefix

    WINDOWS_STABLE_VERSIONS[${#WINDOWS_STABLE_VERSIONS[@]}]="${filename}"
done

for filename in ${WINDOWS_PREVIEW_PATH}/*.json; do
    [ -e "$filename" ] || continue
    filename=${filename%.json}            # strip suffix
    filename=${filename#${WINDOWS_PREVIEW_PATH}/} # strip prefix

    WINDOWS_PREVIEW_VERSIONS[${#WINDOWS_PREVIEW_VERSIONS[@]}]="${filename}"
done

if [ "$LAST_KNOWN_LINUX_STABLE_VERSION" == "$LINUX_STABLE_VERSION" ]; then
  echo "No change in linux stable version"
  echo "trigger_linux_stable_build=false" >> $GITHUB_OUTPUT
else
  echo "New version of linux stable detected [${LAST_KNOWN_LINUX_STABLE_VERSION}] -> [${LINUX_STABLE_VERSION}]"
  echo "trigger_linux_stable_build=true" >> $GITHUB_OUTPUT
fi

if [ "$LAST_KNOWN_LINUX_PREVIEW_VERSION" == "$LINUX_PREVIEW_VERSION" ]; then
  echo "No change in linux preview version"
  echo "trigger_linux_preview_build=false" >> $GITHUB_OUTPUT
else
  echo "New version of linux preview detected [${LAST_KNOWN_LINUX_PREVIEW_VERSION}] -> [${LINUX_PREVIEW_VERSION}]"
  echo "trigger_linux_preview_build=true" >> $GITHUB_OUTPUT
fi

echo "latest_linux_version=${LINUX_STABLE_VERSION}" >> $GITHUB_OUTPUT
echo "latest_linux_preview_version=${LINUX_PREVIEW_VERSION}" >> $GITHUB_OUTPUT
echo "latest_windows_version=${WINDOWS_STABLE_VERSION}" >> $GITHUB_OUTPUT
echo "latest_windows_preview_version=${WINDOWS_PREVIEW_VERSION}" >> $GITHUB_OUTPUT

LINUX_STABLE_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${LINUX_STABLE_VERSIONS[@]}"`
LINUX_PREVIEW_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${LINUX_PREVIEW_VERSIONS[@]}"`
WINDOWS_STABLE_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${WINDOWS_STABLE_VERSIONS[@]}"`
WINDOWS_PREVIEW_VERSIONS_JSON=`jq --compact-output --null-input '$ARGS.positional' --args -- "${WINDOWS_PREVIEW_VERSIONS[@]}"`

LINUX_STABLE_VERSIONS_JSON_SORT=`echo ${LINUX_STABLE_VERSIONS_JSON} | jq 'sort_by(. | split(".") | map(tonumber))'`
LINUX_PREVIEW_VERSIONS_JSON_SORT=`echo ${LINUX_PREVIEW_VERSIONS_JSON} | jq 'sort_by(. | split(".") | map(tonumber))'`
WINDOWS_STABLE_VERSIONS_JSON_SORT=`echo ${WINDOWS_STABLE_VERSIONS_JSON} | jq 'sort_by(. | split(".") | map(tonumber))'`
WINDOWS_PREVIEW_VERSIONS_JSON_SORT=`echo ${WINDOWS_PREVIEW_VERSIONS_JSON} | jq 'sort_by(. | split(".") | map(tonumber))'`

jq -n \
  --arg linux_stable "$LINUX_STABLE_VERSION" \
  --arg windows_stable "$WINDOWS_STABLE_VERSION" \
  --arg linux_preview "$LINUX_PREVIEW_VERSION" \
  --arg windows_preview "$WINDOWS_PREVIEW_VERSION" \
  --argjson LINUX_STABLE_VERSIONS "${LINUX_STABLE_VERSIONS_JSON_SORT}" \
  --argjson WINDOWS_STABLE_VERSIONS "${WINDOWS_STABLE_VERSIONS_JSON_SORT}" \
  --argjson LINUX_PREVIEW_VERSIONS "${LINUX_PREVIEW_VERSIONS_JSON_SORT}" \
  --argjson WINDOWS_PREVIEW_VERSIONS "${WINDOWS_PREVIEW_VERSIONS_JSON_SORT}" \
'
{
  "linux": {
    "stable": ($linux_stable),
    "preview": ($linux_preview),
    "versions": ($LINUX_STABLE_VERSIONS),
    "preview_versions": ($LINUX_PREVIEW_VERSIONS)
  },
  "windows": {
    "stable": ($windows_stable),
    "preview": ($windows_preview),
    "versions": ($WINDOWS_STABLE_VERSIONS),
    "preview_versions": ($WINDOWS_PREVIEW_VERSIONS)
  },
}
' > versions.json

./readme.sh $LINUX_STABLE_VERSION $WINDOWS_STABLE_VERSION $LINUX_PREVIEW_VERSION $WINDOWS_PREVIEW_VERSION
