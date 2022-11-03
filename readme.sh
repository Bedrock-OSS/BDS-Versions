#!/bin/bash

LINUX_STABLE_VERSION=$1
LINUX_PREVIEW_VERSION=$3
WINDOWS_STABLE_VERSION=$2
WINDOWS_PREVIEW_VERSION=$4

rm README.md

echo "# Minecraft BDS versions" >> README.md
echo "" >> README.md
echo "<table align=\"right\">" >> README.md
echo "  <tr>Version<th></th><th><strong>Linux</strong></th><th><strong>Windows</strong></th></tr>" >> README.md
printf  "  <tr><td><strong>Stable</strong></td><td>\n\`\`\`bash\n$LINUX_STABLE_VERSION\n\`\`\`</td><td>\n\`\`\`bash\n$WINDOWS_STABLE_VERSION\n\`\`\`</td></tr>\n" >> README.md
printf  "  <tr><td><strong>Preview</strong></td><td>\n\`\`\`bash\n$LINUX_PREVIEW_VERSION\n\`\`\`</td><td>\n\`\`\`bash\n$WINDOWS_PREVIEW_VERSION\n\`\`\`</td></tr>\n" >> README.md
echo "</table>" >> README.md
echo "" >> README.md
cat ./README/core.header >> README.md
echo "" >> README.md
