#!/bin/bash
# 01-setup/download-jdk.sh

# Download OpenJDK 17 for macOS arm64 (Apple Silicon)
JDK_VERSION="17.0.10"
JDK_FOLDER="jdk"
FILE_NAME="jdk-${JDK_VERSION}.tar.gz"
DOWNLOAD_URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JDK_VERSION}%2B7/OpenJDK17U-jdk_aarch64_mac_hotspot_${JDK_VERSION}_7.tar.gz"

set -e

echo "Step 1: Checking for curl..."
if ! command -v curl &> /dev/null; then
    echo "❗️ ERROR: curl is not installed. Please install it using Homebrew: brew install curl"
    exit 1
fi

echo "Step 2: Creating JDK folder..."
mkdir -p "$JDK_FOLDER"
echo "✅ JDK folder created at: $(pwd)/$JDK_FOLDER"

if [ ! -d "$JDK_FOLDER/Contents/Home/bin" ]; then
    echo "Step 3: Downloading OpenJDK from:"
    echo "$DOWNLOAD_URL"
    curl -L -o "$FILE_NAME" "$DOWNLOAD_URL"

    echo "Step 4: Extracting JDK..."
    tar -xvzf "$FILE_NAME" -C "$JDK_FOLDER" --strip-components=1

    echo "✅ Extraction complete. Cleaning up..."
    rm "$FILE_NAME"
else
    echo "✅ JDK already installed."
fi

echo "Step 5: Setting JAVA_HOME and PATH..."
# Updated path to reference Contents/Home/bin/java
JAVA_HOME="$(pwd)/$JDK_FOLDER/Contents/Home"
PATH="$JAVA_HOME/bin:$PATH"
echo "✅ JAVA_HOME set to: $JAVA_HOME"

echo "Step 6: Testing JDK installation..."
if java -version; then
    echo "✅ JDK $JDK_VERSION installed successfully."
else
    echo "❗️ ERROR: JDK install failed. Cleaning up..."
    rm -rf "$JDK_FOLDER"
    exit 1
fi

echo "✅ All steps completed successfully!"
