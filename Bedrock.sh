apt update
apt install -y zip unzip wget curl jq

cd /mnt/server || { echo "Failed to change directory to /mnt/server"; exit 1; }

# Default version to latest if not set
BEDROCK_VERSION=${BEDROCK_VERSION:-latest}

# Filename to use for the downloaded file
DOWNLOAD_FILE="bedrock-server-installer.zip"

# Minecraft CDN Akamai blocks script user-agents
RANDVERSION=$(echo $((1 + $RANDOM % 4000)))


if [ "${BEDROCK_VERSION}" == "latest" ]; then
    echo "Finding latest Bedrock server version"
    DOWNLOAD_URL=$(curl --silent https://net-secondary.web.minecraft-services.net/api/v1.0/download/links | jq -r '.result.links[] | select(.downloadType == "serverBedrockLinux") | .downloadUrl')
    if [ -z "${DOWNLOAD_URL}" ]; then
        echo "Failed to retrieve the latest Bedrock server version. Please check your network connection or the Minecraft API."
        exit 1
    fi
else
    echo "Downloading ${BEDROCK_VERSION} Bedrock server"
    DOWNLOAD_URL=https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-$BEDROCK_VERSION.zip
fi

echo "Download URL: $DOWNLOAD_URL"





echo -e "Backing up config files"
mkdir /tmp/config_backup
cp -v server.properties /tmp/config_backup/ 2>/dev/null 
cp -v permissions.json /tmp/config_backup/ 2>/dev/null 
cp -v allowlist.json /tmp/config_backup/ 2>/dev/null 



echo -e "Downloading files from: $DOWNLOAD_URL"
curl -L -A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/90.0.$RANDVERSION.212 Safari/537.36" -H "Accept-Language: en" -o $DOWNLOAD_FILE $DOWNLOAD_URL

echo -e "Unpacking server files"
unzip -o $DOWNLOAD_FILE

echo -e "Cleaning up after installing"
rm $DOWNLOAD_FILE

echo -e "Restoring backup config files"
cp -rfv /tmp/config_backup/* /mnt/server/ 2>/dev/null || { echo "No files to restore"; }

chmod +x bedrock_server

echo -e "Install Completed"
