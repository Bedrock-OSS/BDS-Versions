# Minecraft BDS versions

<table align="right">
  <tr>Version<th></th><th><strong>Linux</strong></th><th><strong>Windows</strong></th></tr>
  <tr><td><strong>Stable</strong></td>
  <td>

```bash
1.19.40.02
```

  </td>
  <td>

```bash
1.19.41.01
```

  </td>
  </tr>
  <tr><td><strong>Preview</strong></td>
  <td>

```bash
1.19.50.21
```

  </td>
  <td>

```bash
1.19.50.21
```

  </td>
  </tr>

</table>

This repository acts as an automatic archive of BDS versions.
You can consume the `versions.json` file to get the stable build
and a history of versions.

OCI images are built automatically on detection of a new version.
You can view those over [HERE](https://github.com/ScriptAPIOSS/BDS-OCI).

An example to get the latest stable build:

```bash
#!/bin/bash

LATEST_VERSION=`curl -s https://raw.githubusercontent.com/ScriptAPIOSS/BDS-Versions/main/versions.json | jq -r '.linux.stable'`

echo "The latest Linux BDS is [${LATEST_VERSION}]"

DOWNLOAD_URL=`curl -s https://raw.githubusercontent.com/ScriptAPIOSS/BDS-Versions/main/linux/${LATEST_VERSION}.json | jq -r '.download_url'`

wget ${DOWNLOAD_URL}
```

