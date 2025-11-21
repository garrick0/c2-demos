# VHS Script: Branch Protection Demo
# Shows how main branch is protected

# Output configuration
Output recordings/segments/03-branch-protection.gif
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1200
Set Height 700
Set TypingSpeed 50ms

# Show current branch
Type "# Check current branch"
Enter
Sleep 500ms

Type "git branch --show-current"
Enter
Sleep 1.5s

Type "# Try to run Claude Code on main branch"
Enter
Sleep 500ms

# Use mock Claude script
Type "../scripts/mock-claude.sh"
Enter
Sleep 4s  # Let the block message display

Type "# Switch to feature branch"
Enter
Sleep 500ms

Type "git checkout -b feature/demo"
Enter
Sleep 1.5s

Type "# Now Claude Code works on feature branch"
Enter
Sleep 500ms

Type "../scripts/mock-claude.sh"
Enter
Sleep 3s

# Hold final screen
Sleep 2s