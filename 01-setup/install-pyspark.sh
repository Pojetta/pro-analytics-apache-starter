#!/bin/bash
# 01-setup/install-pyspark.sh

# Download and install Apache Spark to the project folder
# Spark supports JDK 8, 11, and 17 (NOT 18 or later).
# We'll use OpenJDK 17 for compatibility with Kafka and Flink.

# See:
# - https://spark.apache.org/downloads.html
# - https://community.cloudera.com/t5/Community-Articles/Spark-and-Java-versions-Supportability-Matrix/ta-p/383669

# TODO: Change the JDK version in the 01-setup/download-jdk.sh script if needed
# TODO: Change the SPARK_VERSION to the desired version if needed
SPARK_VERSION="3.5.5"
HADOOP_VERSION="3"
SPARK_FOLDER="spark"
JDK_FOLDER="jdk"

# Fail fast on errors
set -e

# Detect platform (macOS only for this version)
OS=$(uname -s)

if [ "$OS" != "Darwin" ]; then
    echo "ERROR: This script is configured for macOS only. Detected platform: $OS"
    exit 1
fi

echo "✅ Detected platform: macOS"

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
    echo "ERROR: 'curl' not installed. Please install it with 'brew install curl' and try again."
    exit 1
fi

# Create Spark installation folder if it doesn't exist
mkdir -p "$SPARK_FOLDER"
echo "✅ Spark folder created at: $(pwd)/$SPARK_FOLDER"

# Construct the download URL
DOWNLOAD_URL="https://downloads.apache.org/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz"
FILE_NAME="spark-$SPARK_VERSION.tgz"

# Download Spark if not already installed
if [ ! -f "$SPARK_FOLDER/bin/spark-shell" ]; then
    echo "✅ Downloading Apache Spark $SPARK_VERSION (Hadoop $HADOOP_VERSION)..."
    curl -L -o "$FILE_NAME" "$DOWNLOAD_URL"

    # ✅ Verify that the downloaded file is a valid gzip archive
    echo "✅ Verifying file type..."
    if file "$FILE_NAME" | grep -q 'gzip compressed data'; then
        echo "✅ File is a valid gzip archive."
        
        # Extract Spark
        echo "✅ Extracting Spark..."
        tar -xzf "$FILE_NAME" -C "$SPARK_FOLDER" --strip-components=1
        
        echo "✅ Spark extracted successfully."
    else
        echo "ERROR: Downloaded file is not a valid gzip archive. Please check the URL or network connection."
        rm "$FILE_NAME"
        exit 1
    fi

    # Remove tar file after extraction
    rm "$FILE_NAME"
    echo "✅ Spark archive removed."
else
    echo "✅ Spark $SPARK_VERSION is already installed."
fi

# Confirm that Spark binary exists
if [ ! -f "$SPARK_FOLDER/bin/spark-shell" ]; then
    echo "ERROR: Spark installation failed. Cleaning up..."
    rm -rf "$SPARK_FOLDER"
    exit 1
fi

# Set temporary JAVA_HOME and PATH for Spark
JAVA_HOME="$(pwd)/$JDK_FOLDER/Contents/Home"
PATH="$JAVA_HOME/bin:$(pwd)/$SPARK_FOLDER/bin:$PATH"
echo "✅ JAVA_HOME set to: $JAVA_HOME"

# Test Spark shell version
if spark-shell --version; then
    echo "✅ Spark $SPARK_VERSION installed correctly."
else
    echo "ERROR: Spark configuration failed. Check logs for details."
    exit 1
fi

# Display quick instructions for starting Spark shell and PySpark
echo ""
echo "To start Spark shell:"
echo "./$SPARK_FOLDER/bin/spark-shell"
echo ""
echo "To start PySpark:"
echo "./$SPARK_FOLDER/bin/pyspark"
echo ""
echo "✅ Spark installation complete!"
