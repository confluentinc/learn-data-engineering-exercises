# TableFlow Trino Demo

Simple Trino Docker setup that connects to Confluent Cloud TableFlow for querying Iceberg tables via web UI. It uses configuration values that are in the `flink.properties` and `tableflow.properties` files.

## Quick Start

1. **Setup:**
   ```bash
   ./update-config.sh
   docker compose up -d
   docker exec 
   ```
## Commands

```bash
# Start Trino
docker-compose up -d

# Stop Trino
docker-compose down

# View logs
docker-compose logs -f

# Restart after config changes
docker-compose restart
```
