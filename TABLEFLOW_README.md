# TableFlow Trino Demo

Simple Trino Docker setup that connects to Confluent Cloud TableFlow for querying Iceberg tables via web UI. It uses configuration values that are in the `flink.properties` and `tableflow.properties` files.

## Quick Start

1. **Setup:**
   ```bash
   ./update-config.sh
   ```
## Commands

```bash
# Start Trino
docker compose up -d

# Get a Trino SQL shell
docker compose exec trino trino --server http://localhost:8080sho

# Stop Trino
docker compose down

# View logs
docker compose logs -f

# Restart after config changes
docker compose restart
```
