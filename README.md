# Claude Monorepo Guard - Demo Kit v2.0.0

This demo kit provides everything needed to demonstrate claude-monorepo-guard with a **pinned, reproducible version**.

## 📌 Important: Pinned Version

This demo uses **claude-monorepo-guard@2.0.0** specifically.
**DO NOT use @latest** - the demo is tested and verified with this exact version.

## 🚀 Quick Start

### 1. Initial Setup

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Run setup
./scripts/setup.sh
```

### 2. Install Pinned Version

```bash
# Install the exact version this demo uses
npm install -g claude-monorepo-guard@2.0.0
```

### 3. Verify Environment

```bash
./scripts/verify.sh
```

### 4. Run Demo

```bash
cd example-monorepo
# Follow the commands in ../docs/DEMO-COMMANDS.md
```

### 5. Clean Up (Between Demos)

```bash
cd ..
./scripts/cleanup.sh
```

## 📁 Kit Contents

```
claude-monorepo-guard-demo-kit/
├── README.md              # This file
├── .demo-state           # Runtime state (gitignored)
├── scripts/
│   ├── demo-config.sh   # Version configuration
│   ├── setup.sh         # Initial setup script
│   ├── verify.sh        # Environment verification
│   └── cleanup.sh       # Reset to clean state
├── example-monorepo/    # Demo monorepo (clean state)
│   ├── apps/
│   │   ├── api/        # Example API project
│   │   └── web/        # Example web project
│   ├── packages/
│   │   ├── core/       # Example core package
│   │   └── ui/         # Example UI package
│   └── pnpm-workspace.yaml
├── docs/
│   ├── DEMO-COMMANDS.md   # Step-by-step commands
│   └── DEMO-NARRATION.md  # Video script
├── recordings/          # Output for recordings
└── assets/             # Supporting materials
```

## 🔧 Scripts

### `setup.sh`
- Creates folder structure
- Clones example monorepo
- Checks out specific commit
- Verifies prerequisites

### `verify.sh`
- Checks Node.js version (>=16)
- Verifies npm installation
- Confirms Claude CLI presence
- Validates demo structure
- Checks package version
- Ensures clean state

### `cleanup.sh`
- Removes `.claudemonorepo` config
- Removes `.claude/` directory
- Cleans test files
- Resets git state
- Returns to clean demo state

## 📋 Prerequisites

- **Node.js** >= 16.0.0
- **npm** (comes with Node.js)
- **Git**
- **Claude CLI** (optional but recommended)
- **Terminal** with bash support

## 🎬 Demo Flow

The demo demonstrates:

1. **Automatic Detection** - Recognizes pnpm workspace
2. **Branch Protection** - Blocks main/master branches
3. **Root Protection** - Prevents monorepo root confusion
4. **Project Discovery** - Lists all available projects
5. **Team Sharing** - Git-tracked configuration

## ⚠️ Common Issues

### Wrong Version Installed

```bash
# Check installed version
npm list -g claude-monorepo-guard

# If wrong version, reinstall
npm uninstall -g claude-monorepo-guard
npm install -g claude-monorepo-guard@2.0.0
```

### Demo Not Clean

```bash
# Reset to clean state
./scripts/cleanup.sh

# Verify it's clean
./scripts/verify.sh
```

### Can't Find Scripts

```bash
# Make sure you're in demo kit root
pwd  # Should show .../claude-monorepo-guard-demo-kit

# Make scripts executable
chmod +x scripts/*.sh
```

## 📝 Demo Commands Reference

Key commands used in the demo:

```bash
# Check status
claude-monorepo-guard status

# Initialize (interactive)
claude-monorepo-guard init

# List projects
claude-monorepo-guard list

# Try Claude (will be blocked in root/main)
claude

# Navigate to project (works)
cd apps/web
claude
```

## 🔄 Reproducibility

This demo is fully reproducible:
- **Pinned npm version:** 2.0.0
- **Pinned git commit:** cb149a8b
- **Automated setup:** Scripts ensure consistency
- **Clean state:** Cleanup script resets everything

## 📊 Demo Statistics

- **Duration:** ~5-7 minutes
- **Setup Time:** <1 minute
- **Projects:** 4 example projects
- **Features:** 5 key features demonstrated

## 🆘 Support

### Demo Kit Issues
If you encounter issues with the demo kit itself:
1. Check `./scripts/verify.sh` output
2. Review prerequisites
3. Try `./scripts/cleanup.sh` then `./scripts/setup.sh`

### Package Issues
For claude-monorepo-guard package issues:
- GitHub: https://github.com/garrick0/claude-guard/issues
- npm: https://www.npmjs.com/package/claude-monorepo-guard

## 📦 Sharing the Demo Kit

To share this demo kit:

```bash
# Create archive (from parent directory)
tar -czf claude-monorepo-guard-demo-kit-v2.0.0.tar.gz \
    --exclude='.git' \
    --exclude='recordings/*' \
    claude-monorepo-guard-demo-kit/

# Extract on another machine
tar -xzf claude-monorepo-guard-demo-kit-v2.0.0.tar.gz
cd claude-monorepo-guard-demo-kit
./scripts/setup.sh
```

## ✅ Checklist Before Demo

- [ ] Run `./scripts/verify.sh` - all checks pass
- [ ] Terminal font size increased (16-18pt)
- [ ] High contrast terminal theme
- [ ] Recording software ready (if recording)
- [ ] `docs/DEMO-COMMANDS.md` open for reference
- [ ] Clean state (no existing configs)

## 🎯 Success Metrics

A successful demo:
- Takes 5-7 minutes
- Shows all 5 key features
- Has no errors or warnings
- Leaves audience understanding the value
- Uses pinned version throughout

---

**Version:** 2.0.0
**Created:** 2025-11-21
**Maintainer:** claude-monorepo-guard team