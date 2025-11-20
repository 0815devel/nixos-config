#!/usr/bin/env bash

# Show changes
git status

echo
echo "→ Checking for changes…"

# Check if nothing has changed (including no untracked files)
if git diff-index --quiet HEAD -- && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✓ No changes found. Nothing to commit or push."
    exit 0
fi

# Ask for commit message
read -p "Commit message: " msg

# If message is empty: abort
if [ -z "$msg" ]; then
    echo "❌ No commit message entered. Aborting."
    exit 1
fi

# Add all changes
git add .

# Create commit
git commit -m "$msg"

# Push
git push

echo "✓ Successfully pushed."
