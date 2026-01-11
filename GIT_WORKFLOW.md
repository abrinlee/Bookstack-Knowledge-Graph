# Git Workflow Guide

This document explains how to use the included Git helper scripts for easy collaboration.

## First Time Setup

### Option 1: SSH Authentication (Recommended)

If you have SSH keys set up with GitHub:

```bash
# Change remote to SSH
git remote set-url origin git@github.com:abrinlee/Bookstack-Knowledge-Graph.git

# Test connection
ssh -T git@github.com

# Push
git push -u origin main
```

### Option 2: Personal Access Token

If using HTTPS:

1. Create a Personal Access Token on GitHub:
   - Go to: https://github.com/settings/tokens
   - Generate new token (classic)
   - Select scopes: `repo` (full control)
   - Copy the token

2. Configure Git to cache credentials:
   ```bash
   git config --global credential.helper store
   ```

3. Push (you'll be prompted for username and token):
   ```bash
   git push -u origin main
   ```
   - Username: `abrinlee`
   - Password: `<paste your token>`

## Daily Workflow

### Making Changes and Pushing

Use the provided helper script:

```bash
# Quick push with message
./git-push.sh "Added new feature"

# Interactive mode (will prompt for message)
./git-push.sh
```

The script will:
1. Show you what changed
2. Ask for confirmation
3. Add, commit, and push changes
4. Display success message with repository URL

### Pulling Latest Changes

Use the pull helper script:

```bash
./git-pull.sh
```

The script will:
1. Check for uncommitted local changes
2. Offer to stash them if needed
3. Pull from GitHub
4. Restore stashed changes
5. Show current status

## Manual Git Commands

If you prefer not to use the scripts:

```bash
# Check status
git status

# Add changes
git add .

# Commit
git commit -m "Your message here"

# Push
git push origin main

# Pull
git pull origin main
```

## Important Notes

### Protected Files

The following files are **automatically excluded** from commits via `.gitignore`:

- `secrets/config.php` (contains API credentials)
- `secrets/config.js` (contains BookStack URL)
- `.claude/` (development files)
- `*.backup.*` (backup files)

These files will **never be committed** even if you use `git add .`

### Checking What Will Be Committed

Before pushing:

```bash
# See what will be committed
git status

# See specific changes
git diff

# Dry run of what would be added
git add -n .
```

### Verifying Secrets Are Protected

```bash
# List ignored files
git status --ignored

# You should see:
# Ignored files:
#   secrets/config.js
#   secrets/config.php
```

## Troubleshooting

### "Authentication failed"

- For HTTPS: Regenerate your Personal Access Token
- For SSH: Check your SSH keys (`ssh -T git@github.com`)

### "Your branch is behind"

Someone else pushed changes. Pull first:

```bash
./git-pull.sh
```

### "Merge conflict"

1. Edit conflicted files (marked with `<<<<<<<`, `=======`, `>>>>>>>`)
2. Resolve conflicts
3. Mark as resolved:
   ```bash
   git add .
   git commit -m "Resolved merge conflicts"
   git push origin main
   ```

### Accidentally Committed Secrets

If you accidentally committed sensitive files:

```bash
# Remove from history (dangerous - use with caution)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch secrets/config.php secrets/config.js" \
  --prune-empty --tag-name-filter cat -- --all

# Force push
git push origin main --force

# Rotate your API tokens immediately!
```

## Repository URL

https://github.com/abrinlee/Bookstack-Knowledge-Graph
