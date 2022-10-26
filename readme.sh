#!/bin/bash

LINUX_STABLE_VERSION=$1
WINDOWS_STABLE_VERSION=$2

rm README.md

echo "# Minecraft BDS versions" >> README.md
echo "" >> README.md
echo "<table align=\"right\">" >> README.md
echo "  <tr><th colspan="2"><strong>⚠️ Latest Version ⚠️</strong></th></tr>" >> README.md
echo "  <tr><th><strong>Linux 🐧</strong></th><th><strong>Windows 🪟</strong></th></tr>" >> README.md
echo "  <tr><td>$LINUX_STABLE_VERSION</td><td>$WINDOWS_STABLE_VERSION</td></tr>" >> README.md
echo "</table>" >> README.md
echo "" >> README.md
cat ./README/core.header >> README.md
echo "" >> README.md