# VHS Script: Initialization Demo
# Shows the interactive initialization process

# Output configuration
Output recordings/segments/02-initialization.gif
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1200
Set Height 700
Set TypingSpeed 50ms

# Assume we're in example-monorepo
Type "# Initialize claude-monorepo-guard"
Enter
Sleep 1s

Type "claude-monorepo-guard init"
Enter
Sleep 1.5s

# Simulate interactive prompts
# Question 1: Block Claude Code from running in monorepo root?
Sleep 2s
Type "y"  # YES to block root
Enter
Sleep 1s

# Question 2: Warn when running in top-level directories?
Sleep 2s
Type "n"  # NO to additional warnings
Enter
Sleep 1s

# Question 3: Custom blocked message
Sleep 2s
Enter  # Use default message
Sleep 2s

# Show created files
Type "# Check created configuration"
Enter
Sleep 500ms

Type "cat .claudemonorepo"
Enter
Sleep 2s

Type "cat .claude/settings.json"
Enter
Sleep 3s

# Hold final screen
Sleep 2s