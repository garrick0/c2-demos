# VHS Script: Quick Demo (30 seconds)
# Fast demonstration for README/social media

# Output configuration
Output recordings/quick-demo.gif
Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1000
Set Height 600
Set TypingSpeed 40ms

# Quick intro
Type "# claude-monorepo-guard - Quick Demo"
Enter
Sleep 1s

Type "cd example-monorepo"
Enter
Sleep 500ms

# Fast init
Type "claude-monorepo-guard init"
Enter
Sleep 1s
Type "y"
Enter
Sleep 500ms
Type "n"
Enter
Sleep 500ms
Enter
Sleep 1.5s

# Show protection working
Type "# Protected from root confusion:"
Enter
Sleep 500ms

Type "../scripts/mock-claude.sh"
Enter
Sleep 2.5s

# Navigate to project
Type "cd apps/web"
Enter
Sleep 500ms

Type "# Works in projects:"
Enter
Sleep 300ms

Type "../../scripts/mock-claude.sh"
Enter
Sleep 2s

# Quick status
Type "cd ../.."
Enter
Sleep 300ms

Type "claude-monorepo-guard status"
Enter
Sleep 2s

# Final message
Type "# Install: npm install -g claude-monorepo-guard"
Enter
Sleep 2s