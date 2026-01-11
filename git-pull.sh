#!/bin/bash
# Pull changes from GitHub repository
#
# This script helps you quickly pull the latest changes from GitHub.
# It checks for local changes first to prevent conflicts.

set -e  # Exit on error

cd "$(dirname "$0")"

echo "================================"
echo "Git Pull Helper"
echo "================================"
echo ""

# Check for uncommitted changes
if ! git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "⚠️  Warning: You have uncommitted local changes:"
    echo ""
    git status --short
    echo ""
    read -p "Stash changes and pull? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Stashing local changes..."
        git stash push -m "Auto-stash before pull $(date '+%Y-%m-%d %H:%M:%S')"
        STASHED=true
    else
        echo "Aborted. Please commit or stash your changes first."
        exit 1
    fi
fi

# Pull from GitHub
echo "Pulling from GitHub..."
git pull origin main

echo ""
echo "✓ Successfully pulled from GitHub!"
echo ""

# Restore stashed changes if any
if [ "$STASHED" = true ]; then
    echo "Restoring stashed changes..."
    if git stash pop; then
        echo "✓ Changes restored successfully"
    else
        echo "⚠️  Merge conflicts detected. Please resolve manually."
        echo "   Use 'git stash list' to see stashed changes"
        echo "   Use 'git stash drop' to discard the stash after resolving"
    fi
    echo ""
fi

# Show current status
echo "Current status:"
git status
echo ""
