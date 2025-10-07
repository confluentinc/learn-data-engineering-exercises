#!/bin/bash

# Simple script to bring up Trino and run the CLI
set -e

echo "Starting Trino..."
docker compose up -d

echo "Waiting for Trino to be ready..."
sleep 10

echo "Starting Trino CLI..."
echo "To stop services later, run: docker compose down"
docker compose exec trino trino --server http://localhost:8080
