# Minecraft BDS versions

<table align="right">
  <tr><th></th><th><strong>Linux</strong></th><th><strong>Windows</strong></th></tr>
<tr><td><strong>Stable</strong></td>
<td>
<code>1.21.114.1</code>
</td>
<td>
<code>1.21.114.1</code>
</td>
</tr>
<tr><td><strong>Preview</strong></td>
<td>
<code>1.21.130.22</code>
</td>
<td>
<code>1.21.130.22</code>
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

## People/Projects using this repo
- [@DarkGamerYT - MinecraftUpdatesBot](https://github.com/DarkGamerYT/MinecraftUpdatesBot)
- [Gamemode One](https://github.com/Gamemode-One)
- [Bedrock APIs - BDS Metadata Generator](https://github.com/Bedrock-APIs/bds-docs)
- [Bedrock APIs - Carolina Server Software](https://github.com/Bedrock-APIs/carolina)
- [Bedrock APIs - Virtual APIs](https://github.com/Bedrock-APIs/virtual-apis)
- [bedrock APIs - GitHub Action - BDS Setup](https://github.com/Bedrock-APIs/bds-setup)
- [bedrock APIs - GitHub Action - BDS Utils](https://github.com/Bedrock-APIs/bds-utils)