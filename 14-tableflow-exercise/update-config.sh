#!/bin/bash

# Update Trino configuration with environment variables from .env

echo "🔧 Updating Trino configuration..."

if [ ! -f ".env" ]; then
    echo "❌ .env file not found. Please create it from .env.template first."
    echo "   Run: cp .env.template .env"
    echo "   Then edit .env with your Confluent Cloud credentials."
    exit 1
fi

# Load environment variables
source .env

# Validate required environment variables
if [ -z "$CONFLUENT_API_KEY" ] || [ -z "$CONFLUENT_API_SECRET" ] || [ -z "$TABLEFLOW_REST_CATALOG_URI" ] || [ -z "$CONFLUENT_REGION" ]; then
    echo "❌ Missing required environment variables in .env file:"
    echo "   - CONFLUENT_API_KEY"
    echo "   - CONFLUENT_API_SECRET" 
    echo "   - TABLEFLOW_REST_CATALOG_URI"
    echo "   - CONFLUENT_REGION"
    echo ""
    echo "Please update your .env file with the correct values."
    exit 1
fi

echo "📝 Updating iceberg.properties with your credentials..."

# Update iceberg.properties with actual TableFlow values
cat > trino-config/catalog/iceberg.properties << EOF
connector.name=iceberg
iceberg.catalog.type=rest
iceberg.rest-catalog.oauth2.credential=${CONFLUENT_API_KEY}:${CONFLUENT_API_SECRET}
iceberg.rest-catalog.security=OAUTH2
iceberg.rest-catalog.uri=${TABLEFLOW_REST_CATALOG_URI}
iceberg.rest-catalog.vended-credentials-enabled=true

fs.native-s3.enabled=true
s3.region=${CONFLUENT_REGION}

iceberg.security=read_only
EOF

echo "✅ Trino configuration updated with your credentials"
echo "🔄 Restarting Trino container..."
docker compose restart

echo "⏳ Waiting for Trino to be ready..."
sleep 10

if curl -s http://localhost:8080/v1/info > /dev/null 2>&1; then
    echo "✅ Trino is ready with updated configuration!"
    echo "🌐 Web UI: http://localhost:8080"
else
    echo "❌ Trino failed to start. Check logs: docker-compose logs"
fi
