#!/bin/bash
# Deploy Second Brain Visualization to the web server

PROJECT_DIR="/home/abrinlee/Projects/Second_Mind"
WEB_DIR="/var/www/bookstack/public"

echo "Deploying Second Brain Visualization to web server..."

# Create backup with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Backup HTML file if it exists
if [ -f "$WEB_DIR/bookstack-visual.html" ]; then
    echo "Creating backup: bookstack-visual.html.backup.$TIMESTAMP"
    sudo cp "$WEB_DIR/bookstack-visual.html" "$WEB_DIR/bookstack-visual.html.backup.$TIMESTAMP"
fi

# Backup proxy file if it exists
if [ -f "$WEB_DIR/bookstack_proxy.php" ]; then
    echo "Creating backup: bookstack_proxy.php.backup.$TIMESTAMP"
    sudo cp "$WEB_DIR/bookstack_proxy.php" "$WEB_DIR/bookstack_proxy.php.backup.$TIMESTAMP"
fi

# Copy HTML file
echo "Copying bookstack-visual.html to $WEB_DIR"
sudo cp "$PROJECT_DIR/bookstack-visual.html" "$WEB_DIR/"
sudo chown www-data:www-data "$WEB_DIR/bookstack-visual.html"

# Copy proxy file
echo "Copying bookstack_proxy.php to $WEB_DIR"
sudo cp "$PROJECT_DIR/bookstack_proxy.php" "$WEB_DIR/"
sudo chown www-data:www-data "$WEB_DIR/bookstack_proxy.php"

# Create secrets directory if it doesn't exist
if [ ! -d "$WEB_DIR/secrets" ]; then
    echo "Creating secrets directory"
    sudo mkdir -p "$WEB_DIR/secrets"
fi

# Copy secrets README and example files (always safe to overwrite)
echo "Copying secrets configuration templates"
sudo cp "$PROJECT_DIR/secrets/README.md" "$WEB_DIR/secrets/"
sudo cp "$PROJECT_DIR/secrets/config.example.php" "$WEB_DIR/secrets/"
sudo cp "$PROJECT_DIR/secrets/config.example.js" "$WEB_DIR/secrets/"

# Only copy actual config files if they don't exist (preserve existing configs)
if [ ! -f "$WEB_DIR/secrets/config.php" ]; then
    echo "⚠️  config.php not found - copying from project (you'll need to edit it!)"
    sudo cp "$PROJECT_DIR/secrets/config.php" "$WEB_DIR/secrets/"
else
    echo "✓ Preserving existing secrets/config.php"
fi

if [ ! -f "$WEB_DIR/secrets/config.js" ]; then
    echo "⚠️  config.js not found - copying from project (you'll need to edit it!)"
    sudo cp "$PROJECT_DIR/secrets/config.js" "$WEB_DIR/secrets/"
else
    echo "✓ Preserving existing secrets/config.js"
fi

# Set permissions
sudo chown -R www-data:www-data "$WEB_DIR/secrets"
sudo chmod 600 "$WEB_DIR/secrets/config.php"
sudo chmod 644 "$WEB_DIR/secrets/config.js"
sudo chmod 644 "$WEB_DIR/secrets/README.md"
sudo chmod 644 "$WEB_DIR/secrets/config.example.php"
sudo chmod 644 "$WEB_DIR/secrets/config.example.js"

echo ""
echo "✓ Deployment complete!"
echo ""
echo "Access at: http://[your-server]/bookstack-visual.html"
echo ""
echo "Files deployed:"
echo "  - bookstack-visual.html (knowledge graph interface)"
echo "  - bookstack_proxy.php (API proxy)"
echo "  - secrets/ (configuration directory)"
echo ""
echo "⚠️  IMPORTANT: Make sure secrets/config.php and secrets/config.js"
echo "   are configured with your BookStack URL and API credentials!"
echo ""
