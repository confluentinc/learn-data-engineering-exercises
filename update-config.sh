#!/bin/bash

# Update Trino configuration with values from tableflow.properties

echo "🔧 Updating Trino configuration..."

# Check if property file exists (try both locations for flexibility)
TABLEFLOW_PROPS_FILE=""


if [ -f "./tableflow.properties" ]; then
    TABLEFLOW_PROPS_FILE="./tableflow.properties"
elif [ -f "../tableflow.properties" ]; then
    TABLEFLOW_PROPS_FILE="../tableflow.properties"
else
    echo "❌ tableflow.properties file not found in current or parent directory."
    exit 1
fi


# Read values from tableflow.properties
echo "📖 Reading values from tableflow.properties..."
TABLEFLOW_API_KEY=$(grep "^tableflow.api-key=" "$TABLEFLOW_PROPS_FILE" | cut -d'=' -f2)
TABLEFLOW_API_SECRET=$(grep "^tableflow.api-secret=" "$TABLEFLOW_PROPS_FILE" | cut -d'=' -f2)
TABLEFLOW_CATALOG_ENDPOINT=$(grep "^tableflow.catalog-endpoint=" "$TABLEFLOW_PROPS_FILE" | cut -d'=' -f2)
TABLEFLOW_REGION=$(grep "^tableflow.region=" "$TABLEFLOW_PROPS_FILE" | cut -d'=' -f2)

# Validate required values
if [ -z "$TABLEFLOW_REGION" ] || [ -z "$TABLEFLOW_API_KEY" ] || [ -z "$TABLEFLOW_API_SECRET" ] || [ -z "$TABLEFLOW_CATALOG_ENDPOINT" ]; then
    echo "❌ Missing required values in property files:"
    echo "   - TABLEFLOW_REGION: $TABLEFLOW_REGION"
    echo "   - TABLEFLOW_API_KEY: $TABLEFLOW_API_KEY"
    echo "   - TABLEFLOW_API_SECRET: $TABLEFLOW_API_SECRET"
    echo "   - TABLEFLOW_CATALOG_ENDPOINT: $TABLEFLOW_CATALOG_ENDPOINT"
    echo ""
    echo "Please check your property files have the correct values."
    exit 1
fi

echo "✅ All required values found:"
echo "   - Region: $TABLEFLOW_REGION"
echo "   - API Key: ${TABLEFLOW_API_KEY:0:8}..."
echo "   - Catalog Endpoint: $TABLEFLOW_CATALOG_ENDPOINT"

echo "📝 Updating iceberg.properties with values from property files..."

# Update iceberg.properties with values from tableflow.properties
if ! mkdir -p trino-config/catalog; then
    echo "❌ Failed to create directory trino-config/catalog"
    exit 1
fi
cat > trino-config/catalog/iceberg.properties << EOF
connector.name=iceberg
iceberg.catalog.type=rest
iceberg.rest-catalog.oauth2.credential=${TABLEFLOW_API_KEY}:${TABLEFLOW_API_SECRET}
iceberg.rest-catalog.security=OAUTH2
iceberg.rest-catalog.uri=${TABLEFLOW_CATALOG_ENDPOINT}
iceberg.rest-catalog.vended-credentials-enabled=true

fs.native-s3.enabled=true
s3.region=${TABLEFLOW_REGION}

iceberg.security=read_only
EOF

echo "✅ Trino configuration updated with values from property files"
echo "🎯 Configuration injection complete!"
