# Minecraft BDS versions

<table align="right">
  <tr><th colspan=2><strong>Latest Version</strong></th></tr>
  <tr><th><strong>Linux</strong></th><th><strong>Windows</strong></th></tr>
  <tr><td>1.19.40.02</td><td>1.19.40.02</td></tr>
</table>

This repository acts as an automatic archive of BDS versions.
You can consume the `versions.json` file to get the stable build
and a history of versions.

OCI images are built automatically on detection of a new version.
You can view those over [Here](https://github.com/ScriptAPIOSS/BDS-OCI).

An example to get the latest stable build:

```bash
#!/bin/bash

LATEST_VERSION=`curl -s https://raw.githubusercontent.com/ScriptAPIOSS/BDS-Versions/main/versions.json | jq -r '.linux.stable'`

echo "The latest Linux BDS is [${LATEST_VERSION}]"

DOWNLOAD_URL=`curl -s https://raw.githubusercontent.com/ScriptAPIOSS/BDS-Versions/main/linux/${LATEST_VERSION}.json | jq -r '.download_url'`

wget ${DOWNLOAD_URL}
```

