# Überblick
In diesem Verzeichnis liegen die Assembler Module.
Assembler Module werden zwecks Deployment direkt von der Pipeline aufgerufen.
Sie rufen ein oder mehrere Core Module auf, um komplexe Deployments zu konstruieren.

Das sind die Regeln:
- Ein Assembler darf nur Module aufrufen
- Ausnahme: er darf Ressourcen mit "existing" suchen - das geht nur mit Ressourcen
