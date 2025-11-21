# VHS Script: Installation Demo
# Shows package installation and verification

# Output configuration
Output recordings/segments/01-installation.gif
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1200
Set Height 600
Set TypingSpeed 50ms

# Starting point
Type "# Install claude-monorepo-guard globally"
Enter
Sleep 1s

Type "npm install -g claude-monorepo-guard@2.1.2"
Enter
Sleep 3s

# Simulate installation output
Type "# Verify installation"
Enter
Sleep 500ms

Type "claude-monorepo-guard --version"
Enter
Sleep 1s

# Show output
Type "# Check current status"
Enter
Sleep 500ms

Type "cd example-monorepo"
Enter
Sleep 500ms

Type "claude-monorepo-guard status"
Enter
Sleep 3s

# Hold final screen
Sleep 2s