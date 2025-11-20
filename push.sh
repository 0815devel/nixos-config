#!/usr/bin/env bash

# Änderungen anzeigen
git status

echo
echo "→ Prüfe, ob Änderungen vorhanden sind…"

# Prüfen, ob nichts geändert wurde (auch keine untracked files)
if git diff-index --quiet HEAD -- && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    echo "✓ Keine Änderungen gefunden. Nichts zu committen oder zu pushen."
    exit 0
fi

# Commit-Nachricht abfragen
read -p "Commit-Nachricht: " msg

# Falls Nachricht leer: abbrechen
if [ -z "$msg" ]; then
    echo "❌ Keine Commit-Nachricht eingegeben. Abbruch."
    exit 1
fi

# Hinzufügen aller Änderungen
git add .

# Commit erstellen
git commit -m "$msg"

# Pushen
git push

echo "✓ Erfolgreich gepusht."
