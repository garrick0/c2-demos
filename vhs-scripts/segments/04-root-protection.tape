# VHS Script: Root Protection Demo
# Shows how monorepo root is protected

# Output configuration
Output recordings/segments/04-root-protection.gif
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1200
Set Height 800
Set TypingSpeed 50ms

# Assume we're on feature branch
Type "# Confirm we're in monorepo root"
Enter
Sleep 500ms

Type "pwd"
Enter
Sleep 1s

Type "ls -la"
Enter
Sleep 1.5s

Type "# Try Claude Code from monorepo root"
Enter
Sleep 500ms

Type "../scripts/mock-claude.sh"
Enter
Sleep 4s  # Let block message with project list display

Type "# Navigate to a specific project"
Enter
Sleep 500ms

Type "cd apps/web"
Enter
Sleep 500ms

Type "pwd"
Enter
Sleep 1s

Type "# Claude Code works in project directory!"
Enter
Sleep 500ms

Type "../../scripts/mock-claude.sh"
Enter
Sleep 3s

# Hold final screen
Sleep 2s