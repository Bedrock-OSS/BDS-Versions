# Minecraft BDS versions

<table align="right">
  <tr><th></th><th><strong>Linux</strong></th><th><strong>Windows</strong></th></tr>
<tr><td><strong>Stable</strong></td>
<td>
<code>1.21.44.01</code>
</td>
<td>
<code>1.21.50.07</code>
</td>
</tr>
<tr><td><strong>Preview</strong></td>
<td>
<code>1.21.60.22</code>
</td>
<td>
<code>1.21.60.22</code>
</td>
</tr>
</table>

This repository acts as an automatic archive of BDS versions.
You can consume the `versions.json` file to get the stable build
and a history of versions.

An example to get the latest stable build:

```bash
#!/bin/bash

LATEST_VERSION=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/versions.json | jq -r '.linux.stable'`

echo "The latest Linux BDS is [${LATEST_VERSION}]"

DOWNLOAD_URL=`curl -s https://raw.githubusercontent.com/Bedrock-OSS/BDS-Versions/main/linux/${LATEST_VERSION}.json | jq -r '.download_url'`

wget ${DOWNLOAD_URL}
```

## People using this repo
- [@DarkGamerYT - MinecraftUpdatesBot](https://github.com/DarkGamerYT/MinecraftUpdatesBot)
- [Gamemode One](https://github.com/Gamemode-One)
- [Bedrock APIs - BDS-Docs](https://github.com/Bedrock-APIs/bds-docs)

