# Claude Monorepo Guard - Demo Commands

This document provides the exact commands to run for demonstrating claude-monorepo-guard v2.1.2.

## ⚠️ Important: Pinned Version

This demo uses **claude-monorepo-guard@2.1.2** (not @latest) for reproducibility.

## Prerequisites

Before starting, ensure you've:
1. Run `../scripts/setup.sh` from demo kit root
2. Run `../scripts/verify.sh` to check environment
3. Installed the pinned version: `npm install -g claude-monorepo-guard@2.1.2`

## Demo Commands

### 1. Show the Monorepo Structure

First, examine the demo monorepo:

```bash
# Confirm we're in example-monorepo
pwd

# Show directory structure
ls -la

# Show the pnpm workspace configuration
cat pnpm-workspace.yaml

# Show project structure
tree -L 2 apps packages
# Or if tree is not available:
ls -la apps/ packages/
```

**Expected Output:**
```
apps/
├── api/     - API server project
└── web/     - Web application project
packages/
├── core/    - Shared core utilities
└── ui/      - Shared UI components
```

### 2. Verify Claude Monorepo Guard Installation

```bash
# Check the installed version (should be 2.1.2)
claude-monorepo-guard --version

# Or check globally installed packages
npm list -g claude-monorepo-guard
```

**Expected:** Version 2.1.2

### 3. Check Current Status

Before initialization, check the current status:

```bash
claude-monorepo-guard status
```

**Expected Output:**
```
ℹ This is a monorepo root: example-monorepo
  Type: pnpm
  Path: /path/to/example-monorepo
  Projects: 4

⚠ Not initialized - run "claude-monorepo-guard init"
```

### 4. Initialize Configuration

Run the initialization command:

```bash
claude-monorepo-guard init
```

**Interactive Prompts:**

1. **"Block Claude Code from running in monorepo root?"**
   - Answer: **YES** (press Enter for default)
   - This prevents context confusion

2. **"Warn when running in top-level directories (apps/, libs/, etc)?"**
   - Answer: **NO** (or as preferred)
   - Optional additional safety

3. **"Custom blocked message (press enter for default):"**
   - Press Enter to use default message

**Expected Output:**
```
✓ Created .claudemonorepo configuration
✓ Updated .claude/settings.json with hook
✓ Claude Monorepo Guard initialized successfully!

Found 4 projects:
  📦 @demo/api (apps/api) - app
  📦 @demo/web (apps/web) - app
  📦 @demo/core (packages/core) - package
  📦 @demo/ui (packages/ui) - package
```

### 5. Verify Configuration Files

Check the created configuration:

```bash
# Show monorepo configuration
cat .claudemonorepo

# Show Claude hook configuration
cat .claude/settings.json
```

### 6. Demo: Branch Protection

Try to work on the main branch:

```bash
# Check current branch
git branch --show-current
# Output: demo/example-project (or main if you've changed)

# If not on main, switch to it for demo
git checkout -b main

# Try to run Claude Code
claude
```

**Expected Output:**
```
╔══════════════════════════════════════════════════════════════╗
║  🚫 Cannot work on main branch directly                     ║
║                                                              ║
║  Create a worktree for feature work:                        ║
║    git worktree add ../demo-wt/my-feature -b feature/xyz   ║
║    cd ../demo-wt/my-feature                                ║
║    npm install && npm run build                             ║
╚══════════════════════════════════════════════════════════════╝
```

### 7. Switch to Feature Branch

Create and switch to a feature branch:

```bash
git checkout -b feature/demo-feature

# Now we're on a feature branch
git branch --show-current
```

### 8. Demo: Monorepo Root Protection

Try to run Claude Code from the monorepo root:

```bash
# Confirm we're in the root
pwd

# Try to run Claude Code
claude
```

**Expected Output:**
```
╔══════════════════════════════════════════════════════════════╗
║  🚫 Claude Code blocked in monorepo root                    ║
║                                                              ║
║  Running from root causes context confusion.                ║
║                                                              ║
║  Available projects:                                        ║
║                                                              ║
║    cd apps/api                                              ║
║    cd apps/web                                              ║
║    cd packages/core                                         ║
║    cd packages/ui                                           ║
║                                                              ║
║  Navigate to a specific project directory first             ║
╚══════════════════════════════════════════════════════════════╝
```

### 9. Navigate to a Project

Move to a specific project:

```bash
# Navigate to the web app
cd apps/web

# Confirm location
pwd

# Now Claude Code works!
claude
```

**Expected:** Claude Code launches successfully in the project directory.

### 10. Demo: Uncommitted Changes Warning

Make a change to trigger the warning:

```bash
# Create a test file
echo "test content" > test.txt

# Go back to root (still on feature branch)
cd ../..

# Try Claude Code with uncommitted changes
claude
```

**Expected Output:**
```
⚠️  Uncommitted changes detected - commit before major work

[Claude Code may continue with warning, or may be blocked depending on config]
```

### 11. List Available Projects

Use the list command to see all projects:

```bash
claude-monorepo-guard list
```

**Expected Output:**
```
Available projects:
  📦 @demo/api (apps/api) - app
  📦 @demo/web (apps/web) - app
  📦 @demo/core (packages/core) - package
  📦 @demo/ui (packages/ui) - package

Navigate to any project:
  cd apps/api
  cd apps/web
  cd packages/core
  cd packages/ui
```

### 12. Check Final Status

Review the complete configuration:

```bash
claude-monorepo-guard status
```

**Expected Output:**
```
ℹ This is a monorepo root: example-monorepo
  Type: pnpm
  Path: /path/to/example-monorepo
  Projects: 4

ℹ Claude Code blocked: YES

Available projects:
  📦 @demo/api (apps/api)
  📦 @demo/web (apps/web)
  📦 @demo/core (packages/core)
  📦 @demo/ui (packages/ui)
```

## Key Features Demonstrated

✅ **Version Pinning** - Using specific version 2.1.2
✅ **Automatic Detection** - Recognized pnpm workspace automatically
✅ **Branch Protection** - Blocks work on main/master branches
✅ **Root Protection** - Prevents Claude Code in monorepo root
✅ **Project Discovery** - Automatically finds all projects
✅ **Clear Guidance** - Shows available projects and navigation
✅ **Warnings** - Alerts for uncommitted changes
✅ **Team Friendly** - Config in Git, shareable with team

## Troubleshooting During Demo

### If Claude Code still launches from root:

```bash
# Check the hook is installed
cat .claude/settings.json

# Verify package is installed
which claude-monorepo-guard

# Reinstall if needed
claude-monorepo-guard init --force
```

### If not detected as monorepo:

```bash
# Force initialization
claude-monorepo-guard init --force
```

### Wrong version installed:

```bash
# Check version
npm list -g claude-monorepo-guard

# Reinstall correct version
npm uninstall -g claude-monorepo-guard
npm install -g claude-monorepo-guard@2.1.2
```

## Cleanup After Demo

To reset for next demo:

```bash
# Go back to demo kit root
cd ../..

# Run cleanup
./scripts/cleanup.sh

# Verify clean state
./scripts/verify.sh
```

## Demo Timing

- **Total Duration:** ~5-7 minutes
- Section 1-3: 1 minute (setup and status)
- Section 4-5: 1.5 minutes (initialization)
- Section 6-8: 2 minutes (protection demos)
- Section 9-10: 1.5 minutes (navigation and warnings)
- Section 11-12: 1 minute (list and final status)

## Notes for Presenter

- Pause after each major output to let audience read
- Emphasize the version number (2.1.2) at start
- Highlight that config is Git-trackable
- Show that no shell modifications are needed
- Mention token savings from not processing entire monorepo

---

**Demo Version:** claude-monorepo-guard@2.1.2
**Demo Commit:** cb149a8b228004ac94100eb507fd362e0ff65c89
**Last Updated:** 2025-11-21