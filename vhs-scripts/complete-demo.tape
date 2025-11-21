# VHS Script: Complete Demo (7 minutes)
# Full walkthrough of all features

# Output configuration
Output recordings/complete-demo.mp4
Set Theme "Catppuccin Mocha"
Set FontSize 16
Set Width 1400
Set Height 900
Set TypingSpeed 50ms

# Introduction
Type "# Claude Monorepo Guard - Complete Demo"
Enter
Sleep 1.5s

Type "# A tool to prevent Claude Code confusion in monorepos"
Enter
Sleep 2s

Type "clear"
Enter

# Section 1: Show the monorepo structure
Type "# 1. Examining our monorepo structure"
Enter
Sleep 1s

Type "cd example-monorepo"
Enter
Sleep 500ms

Type "ls -la"
Enter
Sleep 1.5s

Type "cat pnpm-workspace.yaml"
Enter
Sleep 2s

Type "tree -L 2 apps packages || ls -la apps/ packages/"
Enter
Sleep 2s

Type "clear"
Enter

# Section 2: Installation
Type "# 2. Installing claude-monorepo-guard"
Enter
Sleep 1s

Type "npm install -g claude-monorepo-guard@2.1.2"
Enter
Sleep 3s

Type "claude-monorepo-guard --version"
Enter
Sleep 1.5s

Type "clear"
Enter

# Section 3: Check initial status
Type "# 3. Checking current status"
Enter
Sleep 1s

Type "claude-monorepo-guard status"
Enter
Sleep 3s

Type "clear"
Enter

# Section 4: Initialize configuration
Type "# 4. Initializing protection"
Enter
Sleep 1s

Type "claude-monorepo-guard init"
Enter
Sleep 2s

# Answer prompts
Type "y"  # YES to block root
Enter
Sleep 1.5s

Type "n"  # NO to warn on top-level
Enter
Sleep 1.5s

Enter  # Default message
Sleep 3s

Type "clear"
Enter

# Section 5: Verify configuration
Type "# 5. Configuration created"
Enter
Sleep 1s

Type "cat .claudemonorepo"
Enter
Sleep 2s

Type "cat .claude/settings.json"
Enter
Sleep 2.5s

Type "clear"
Enter

# Section 6: Demo branch protection
Type "# 6. Branch protection demo"
Enter
Sleep 1s

Type "git branch --show-current"
Enter
Sleep 1.5s

Type "# Switching to main branch to test protection"
Enter
Sleep 500ms

Type "git checkout -b main 2>/dev/null || git checkout main"
Enter
Sleep 1.5s

Type "../scripts/mock-claude.sh"
Enter
Sleep 4s

Type "# Creating feature branch"
Enter
Sleep 500ms

Type "git checkout -b feature/demo"
Enter
Sleep 1.5s

Type "clear"
Enter

# Section 7: Demo root protection
Type "# 7. Root directory protection"
Enter
Sleep 1s

Type "pwd"
Enter
Sleep 1.5s

Type "# Try Claude from monorepo root"
Enter
Sleep 500ms

Type "../scripts/mock-claude.sh"
Enter
Sleep 4s

Type "clear"
Enter

# Section 8: Navigate to project
Type "# 8. Working in a specific project"
Enter
Sleep 1s

Type "cd apps/web"
Enter
Sleep 500ms

Type "pwd"
Enter
Sleep 1s

Type "# Claude Code works in project directories!"
Enter
Sleep 500ms

Type "../../scripts/mock-claude.sh"
Enter
Sleep 3s

Type "cd ../.."
Enter
Sleep 500ms

Type "clear"
Enter

# Section 9: Show uncommitted changes warning
Type "# 9. Uncommitted changes warning"
Enter
Sleep 1s

Type "echo 'test' > test.txt"
Enter
Sleep 500ms

Type "cd apps/api"
Enter
Sleep 500ms

Type "../../scripts/mock-claude.sh"
Enter
Sleep 3s

Type "cd ../.."
Enter
Sleep 500ms

Type "rm test.txt"
Enter
Sleep 500ms

Type "clear"
Enter

# Section 10: List projects
Type "# 10. Listing available projects"
Enter
Sleep 1s

Type "claude-monorepo-guard list"
Enter
Sleep 3.5s

Type "clear"
Enter

# Section 11: Final status
Type "# 11. Final status check"
Enter
Sleep 1s

Type "claude-monorepo-guard status"
Enter
Sleep 3s

# Section 12: Summary
Type "clear"
Enter

Type "# Summary: Claude Monorepo Guard"
Enter
Sleep 1s

Type "# ✅ Auto-detects monorepo type"
Enter
Sleep 500ms

Type "# ✅ Protects main/master branches"
Enter
Sleep 500ms

Type "# ✅ Prevents root directory confusion"
Enter
Sleep 500ms

Type "# ✅ Shows available projects"
Enter
Sleep 500ms

Type "# ✅ Warns about uncommitted changes"
Enter
Sleep 500ms

Type "# ✅ Git-trackable configuration"
Enter
Sleep 500ms

Type "# ✅ Team shareable via repository"
Enter
Sleep 1s

Type "#"
Enter
Type "# Install: npm install -g claude-monorepo-guard"
Enter
Sleep 500ms

Type "# GitHub: github.com/garrick0/claude-guard"
Enter
Sleep 3s

# Hold final screen
Sleep 2s