# pro-analytics-apache-starter

This project provides an isolated development environment for Apache tools like Kafka and PySpark using local JDK and virtual environments.  
Works for macOS aarch64 (Apple Silicon)

---

## Getting Started

### Change to Home Directory

Change to your home directory.
Run these and all following commands in your shell ($ prompt) terminal.

```shell
cd ~/
```

### Clone Your Repository Into Your Home Directory

1. Copy the template repo into your GitHub account. You can change the name as desired.
2. Open a terminal in your "Projects" folder or where ever you keep your coding projects.
3. Avoid using "Documents" or any folder that syncs automatically to OneDrive or other cloud services.
4. Clone this repository into that folder.

In the command below, if you changed the repository name, use that name instead.  

For example - clone with something like this - but use your GitHub account name and repo name:

```shell
git clone https://github.com/Pojetta/pro-analytics-apache-starter
```

Then cd into your new folder (if you changed the name, use that):

```shell
cd pro-analytics-apache-starter
```

### Adjust Requirements (Packages Needed)

Review requirements.txt and comment / uncomment the specific packages needed for your project.  

---

## Create Virtual Environment using Python 3.11

```shell
python3.11 -m venv .venv
source .venv/bin/activate
```

Important Reminder: Always run `source .venv/bin/activate` before working on the project.

## Install Requirements

```shell
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install --upgrade -r requirements.txt

```

## Grant Yourself Execute Permissions on the Script folders

```shell
chmod +x ./01-setup/*.sh
chmod +x ./02-scripts/*.sh
chmod +x ./02-scripts/*.py
```

## Install JDK

Verify compatible versions.
See instructions in the file.
Then, install the necessary OpenJDK locally.

```shell
./01-setup/download-jdk.sh
```

## Install Apache Tools (As Needed)

Use the commands below to install only the tools your project requires:

```shell
./01-setup/install-kafka.sh
./01-setup/install-pyspark.sh
```

---

## Example: Using Apache Kafka (e.g., for Streaming Data)

Start the Kafka service (keep this terminal running)

```shell
./02-scripts/run-kafka.sh
```

In a second terminal, create a Kafka topic

```shell
./kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092
```

In that second terminal, list Kafka topics

```shell
./kafka/bin/kafka-topics.sh --list --bootstrap-server localhost:9092
```

In that second terminal, stop the Kafka service when done working with Kafka. Use whichever works.

```shell
./kafka/bin/kafka-server-stop.sh

pkill -f kafka
```


## Example: Using PySpark (e.g., for BI and Analytics)

Start PySpark (leave this terminal running)

```shell
./02-scripts/run-pyspark.sh
```

Open a browser to <http://localhost:4040/>  to monitor Spark jobs and execution details.

In a second terminal, test Spark

```shell
python3 02-scripts/test-pyspark.py
```

Use that second terminal to stop the service when done:

```shell
pkill -f pyspark
```
