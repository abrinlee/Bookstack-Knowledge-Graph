<?php
/**
 * BookStack API Configuration Template
 *
 * SETUP INSTRUCTIONS:
 * 1. Copy this file to config.php in the same directory:
 *    cp config.example.php config.php
 *
 * 2. Edit config.php with your actual credentials
 *
 * 3. Set proper file permissions:
 *    chmod 600 config.php
 *
 * 4. Never commit config.php to version control
 */

return [
    // BookStack instance base URL (no trailing slash)
    // Example: 'http://192.168.0.94' or 'https://bookstack.example.com'
    'bookstack_url' => 'YOUR_BOOKSTACK_URL_HERE',

    // BookStack API credentials
    // Generate from BookStack: Settings -> Users -> [Your User] -> API Tokens
    'api_token_id' => 'YOUR_TOKEN_ID_HERE',
    'api_token_secret' => 'YOUR_TOKEN_SECRET_HERE',

    // Optional: CORS settings
    // Restrict in production for better security
    // Examples:
    //   ['*'] - Allow all origins (development only)
    //   ['http://192.168.0.94'] - Allow specific origin
    //   ['http://localhost:8000', 'https://example.com'] - Multiple origins
    'allowed_origins' => ['*'],
];
