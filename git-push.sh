#!/bin/bash
# Push changes to GitHub repository
#
# This script helps you quickly commit and push changes to GitHub.
# Usage:
#   ./git-push.sh "Your commit message"
#   ./git-push.sh           (will prompt for commit message)

set -e  # Exit on error

cd "$(dirname "$0")"

# Check if there are changes to commit
if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "No changes to commit."
    echo ""
    echo "Status:"
    git status
    exit 0
fi

# Get commit message
if [ -z "$1" ]; then
    echo "Enter commit message:"
    read -r COMMIT_MSG
else
    COMMIT_MSG="$1"
fi

if [ -z "$COMMIT_MSG" ]; then
    echo "Error: Commit message cannot be empty"
    exit 1
fi

echo "================================"
echo "Git Push Helper"
echo "================================"
echo ""

# Show what will be committed
echo "Changes to be committed:"
git status --short
echo ""

# Ask for confirmation
read -p "Commit and push these changes? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

# Add all changes (respecting .gitignore)
echo "Adding changes..."
git add .

# Commit with provided message
echo "Committing..."
git commit -m "${COMMIT_MSG}

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>"

# Push to GitHub
echo "Pushing to GitHub..."
git push origin main

echo ""
echo "✓ Successfully pushed to GitHub!"
echo ""
echo "View at: https://github.com/abrinlee/Bookstack-Knowledge-Graph"
echo ""
