#!/bin/bash
# MEA DA Dashboard — daily backup + git commit
# Run this at the end of any work session, or let Claude run it automatically.

DATE=$(date +%Y-%m-%d)
BACKUP_DIR="backups"
mkdir -p "$BACKUP_DIR"

# Copy key files with date stamp (only if changed since last backup)
for f in index.html police-voice-report.html; do
  if [ -f "$f" ]; then
    DEST="$BACKUP_DIR/${f%.html}-$DATE.${f##*.}"
    if [ ! -f "$DEST" ]; then
      cp "$f" "$DEST"
      echo "✓ Backed up $f → $DEST"
    else
      echo "↩ Backup already exists for $f today"
    fi
  fi
done

# Git commit everything changed
git add -A
if git diff --cached --quiet; then
  echo "↩ No changes to commit"
else
  git commit -m "Session backup — $DATE"
  echo "✓ Git commit saved"
fi

echo ""
echo "All done. Backups in: $(pwd)/backups/"
