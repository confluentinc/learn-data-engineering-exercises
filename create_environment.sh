#!/usr/bin/env bash
# Check if Confluent CLI is installed
if ! command -v confluent &> /dev/null; then
    echo "Confluent CLI is not installed"
    exit 1
fi
# Check if the quickstart plugin is installed
if ! confluent plugin list | grep -q "confluent-quickstart"; then
    echo -n "Confluent Quickstart plugin is not installed. Install? (y/n) "
    read -n 1 -s -r
    echo  # Add a newline after the read
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        confluent plugin install confluent-quickstart
    else
        echo "Exiting..."
        exit 1
    fi
fi
# Create the environment
confluent quickstart \
    --environment-name data_engineering \
    --kafka-cluster-name exercises \
    --cloud gcp \
    --region us-central1 \
    --create-kafka-key \
    --kafka-properties-file ./jr/kafka/config.properties \
    --compute-pool-name data_engineering \
    --max-cfu 10
