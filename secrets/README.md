# Secrets Configuration

This directory contains sensitive configuration files that should **never be committed to version control**.

## Quick Setup

### 1. Server-side Configuration (PHP)

Copy the example file and edit with your credentials:

```bash
cp config.example.php config.php
```

Edit `config.php` and set:
- `bookstack_url`: Your BookStack instance URL
- `api_token_id`: Your BookStack API token ID
- `api_token_secret`: Your BookStack API token secret

**Generate API tokens:** BookStack → Settings → Users → [Your User] → API Tokens

### 2. Client-side Configuration (JavaScript)

Copy the example file and edit with your BookStack URL:

```bash
cp config.example.js config.js
```

Edit `config.js` and set:
- `bookstackBaseUrl`: Your BookStack instance URL (same as in config.php)

### 3. Set Permissions

```bash
chmod 600 config.php
chmod 644 config.js
```

## Security Notes

- **config.php** contains API credentials and must be protected
- **config.js** only contains the base URL (no secrets, but still excluded from git)
- Both files are listed in `.gitignore` and will not be committed
- In production, consider placing `config.php` outside the web root
- The API proxy (`bookstack_proxy.php`) ensures tokens never reach the client

## File Structure

```
secrets/
├── README.md              (this file)
├── config.example.php     (template - safe to commit)
├── config.example.js      (template - safe to commit)
├── config.php            (your actual config - DO NOT COMMIT)
└── config.js             (your actual config - DO NOT COMMIT)
```

## Troubleshooting

**Error: "Configuration file not found"**
- Make sure you've copied `config.example.php` to `config.php`

**Error: "Configuration incomplete"**
- Edit `config.php` and replace all `YOUR_*_HERE` placeholders with real values

**Pages won't open**
- Check that `bookstackBaseUrl` in `config.js` matches your BookStack URL
- Verify the URL doesn't have a trailing slash
