# VHS Script: Project List Demo
# Shows listing available projects

# Output configuration
Output recordings/segments/05-project-list.gif
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1200
Set Height 700
Set TypingSpeed 50ms

# Navigate back to root
Type "# List all available projects"
Enter
Sleep 500ms

Type "cd ../.."  # Back to monorepo root
Enter
Sleep 500ms

Type "claude-monorepo-guard list"
Enter
Sleep 3s  # Show full project list

Type "# Check final status"
Enter
Sleep 500ms

Type "claude-monorepo-guard status"
Enter
Sleep 3s

# Hold final screen
Sleep 2s