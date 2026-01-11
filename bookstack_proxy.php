<?php
/**
 * BookStack API Proxy
 *
 * This proxy acts as a security boundary, keeping API credentials server-side
 * and preventing credential exposure to the client browser.
 *
 * Features:
 * - Token isolation (credentials never sent to client)
 * - CORS handling
 * - Read-only API access enforcement
 * - Error handling and logging
 */

header('Content-Type: application/json');

// Load configuration from secrets directory
$configPath = __DIR__ . '/secrets/config.php';

if (!file_exists($configPath)) {
    http_response_code(500);
    echo json_encode([
        'error' => 'Configuration file not found',
        'message' => 'Please copy secrets/config.example.php to secrets/config.php and configure your credentials'
    ]);
    exit;
}

$config = require $configPath;

// Validate required configuration
$requiredKeys = ['bookstack_url', 'api_token_id', 'api_token_secret'];
foreach ($requiredKeys as $key) {
    if (empty($config[$key]) || strpos($config[$key], 'YOUR_') === 0) {
        http_response_code(500);
        echo json_encode([
            'error' => 'Configuration incomplete',
            'message' => "Please configure '{$key}' in secrets/config.php"
        ]);
        exit;
    }
}

// CORS headers
$allowedOrigins = $config['allowed_origins'] ?? ['*'];
$origin = $_SERVER['HTTP_ORIGIN'] ?? '';

if (in_array('*', $allowedOrigins) || in_array($origin, $allowedOrigins)) {
    header('Access-Control-Allow-Origin: ' . ($origin ?: '*'));
    header('Access-Control-Allow-Methods: GET, OPTIONS');
    header('Access-Control-Allow-Headers: Content-Type, Authorization');
}

// Handle preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Only allow GET requests (read-only)
if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed', 'message' => 'Only GET requests are supported']);
    exit;
}

// Get and validate endpoint
$endpoint = $_GET['endpoint'] ?? '';
if (empty($endpoint)) {
    http_response_code(400);
    echo json_encode(['error' => 'Missing endpoint parameter']);
    exit;
}

// Validate endpoint (prevent path traversal)
if (strpos($endpoint, '..') !== false) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid endpoint']);
    exit;
}

// Build BookStack API URL
$apiUrl = rtrim($config['bookstack_url'], '/') . '/api/' . ltrim($endpoint, '/');

// Add query parameters (e.g., count, filter)
$queryParams = $_GET;
unset($queryParams['endpoint']);
if (!empty($queryParams)) {
    $apiUrl .= '?' . http_build_query($queryParams);
}

// Make request to BookStack API
$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => $apiUrl,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => [
        'Authorization: Token ' . $config['api_token_id'] . ':' . $config['api_token_secret'],
        'Accept: application/json'
    ],
    CURLOPT_TIMEOUT => 30,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_SSL_VERIFYPEER => true,
]);

$response = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
curl_close($ch);

// Handle curl errors
if ($response === false) {
    http_response_code(502);
    echo json_encode([
        'error' => 'Failed to connect to BookStack API',
        'message' => $curlError
    ]);
    exit;
}

// Forward response
http_response_code($httpCode);
echo $response;
