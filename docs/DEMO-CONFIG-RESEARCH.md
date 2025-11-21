# Demo Kit Configuration Research and Recommendations

## Executive Summary

This research document analyzes the current VERSION file approach in the Claude Monorepo Guard Demo Kit and compares it with industry best practices for demo/example repository configuration management. Based on extensive research of GitHub best practices, popular frameworks, and configuration patterns, I recommend transitioning from the current mixed-concern VERSION file to a separated configuration/state pattern.

## Current Approach Analysis

### The VERSION File Problem

The current VERSION file serves multiple conflicting purposes:

```bash
# VERSION file (current approach)
PACKAGE_VERSION=2.2.1                  # ← Configuration (should be immutable)
DEMO_COMMIT=cb149a8b...                # ← Configuration (should be immutable)
DEMO_BRANCH=demo/example-project       # ← Configuration (should be immutable)
CREATED=2025-11-21                     # ← Metadata (semi-immutable)
LAST_SETUP="2025-11-21 23:17:11 UTC"   # ← Runtime state (mutable)
```

**Core Issues:**
1. **Mixed Concerns**: Combines immutable configuration with mutable runtime state
2. **Git Pollution**: Runtime updates (`LAST_SETUP`) create unnecessary commits
3. **Bidirectional Flow**: `setup.sh` both reads from and writes to VERSION
4. **Unclear Purpose**: Acts as both source of truth AND execution log
5. **Non-Standard**: Doesn't follow established patterns from the ecosystem

## Industry Best Practices Research

### 1. Repository Configuration Standards

Based on [GitHub's best practices documentation](https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories) and [community guidelines](https://dev.to/pwd9000/github-repository-best-practices-23ck):

- **Configuration should be versioned** but runtime state should not
- **Use .gitignore** for temporary state files
- **Provide example/template files** for configuration
- **Separate concerns** between config, state, and secrets

### 2. Environment Variable Patterns

According to [environment variable best practices](https://dev.to/khalidk799/environment-variables-its-best-practices-1o1o) and [Stack Overflow discussions](https://stackoverflow.com/questions/51600299/best-practice-to-source-a-config-file-in-bash):

- **Never commit actual .env files** containing secrets
- **Use .env.example** files with dummy values
- **Prefer explicit sourcing** in scripts for clarity
- **Use dot (.) operator** for POSIX compatibility over `source`

Example from popular projects:
```bash
# .env.example (committed)
API_KEY=your_api_key_here
DATABASE_URL=postgresql://localhost/myapp

# .env (gitignored)
API_KEY=sk-1234567890
DATABASE_URL=postgresql://prod.db.example.com/myapp
```

### 3. Popular Framework Approaches

#### Vite Configuration
[Vite](https://vite.dev/guide/) uses a clean separation:
- `vite.config.js` - Build configuration (committed)
- Environment variables in `.env` files (gitignored)
- Example files provided as `.env.example`

#### Next.js Configuration
[Next.js](https://nextjs.org/docs/app/getting-started/installation) follows similar patterns:
- `next.config.js` - Application configuration (committed)
- `.env.local` - Local overrides (gitignored)
- `.env.example` - Template file (committed)

#### Create React App (Legacy)
Even the deprecated CRA used:
- `package.json` for version/dependency config
- `.env` files for runtime configuration
- Clear separation of concerns

### 4. Configuration Management Tools

The [launchcodedev/app-config](https://github.com/launchcodedev/app-config) project demonstrates enterprise patterns:
- **Strict validation** using schemas
- **Multiple format support** (YAML, TOML, JSON)
- **Environment-specific configs** with inheritance
- **Encrypted secrets** using OpenPGP

## Comparison of Approaches

| Approach | Pros | Cons | Best For | Industry Adoption |
|----------|------|------|----------|-------------------|
| **Current (VERSION)** | Simple, single file | Mixed concerns, git noise | Nothing | ❌ Non-standard |
| **Config + State Files** | Clear separation, standard pattern | Two files to manage | Most projects | ✅ Very common |
| **JSON Configuration** | Universal, schema validation | Requires JSON parser | Complex configs | ✅ Standard |
| **.env Pattern** | Familiar, tooling support | Not ideal for bash sourcing | App configuration | ✅ Industry standard |
| **Makefile Variables** | Build tool integration | Requires make | Build automation | ⭐ Common in C/C++ |
| **package.json config** | Native to Node.js | Node.js specific | JS/TS projects | ✅ Standard for Node |

## Recommended Solution

Based on research and industry standards, I recommend **Option 1: Separated Config + State Pattern**

### Implementation Structure

```
claude-monorepo-guard-demo-kit/
├── scripts/
│   ├── demo-config.sh     # Immutable configuration (committed)
│   ├── setup.sh
│   ├── verify.sh
│   └── cleanup.sh
├── .demo-state            # Runtime state (gitignored)
└── .gitignore             # Include .demo-state
```

### File Contents

**demo-config.sh** (committed):
```bash
#!/bin/bash
# Demo Kit Configuration - DO NOT EDIT AT RUNTIME
# To update versions, edit this file and commit changes

readonly PACKAGE_VERSION="2.2.1"
readonly DEMO_COMMIT="cb149a8b228004ac94100eb507fd362e0ff65c89"
readonly DEMO_BRANCH="demo/example-project"
readonly CREATED_DATE="2025-11-21"

# Export for child processes
export PACKAGE_VERSION DEMO_COMMIT DEMO_BRANCH CREATED_DATE
```

**.demo-state** (gitignored):
```bash
# Runtime state - automatically updated by scripts
LAST_SETUP="2025-11-21 23:17:11 UTC"
LAST_VERIFY="2025-11-21 23:18:00 UTC"
LAST_CLEANUP=""
SETUP_COUNT=3
```

**Script Usage Pattern**:
```bash
#!/bin/bash
# All scripts start with:
SCRIPT_DIR="$(dirname "$0")"
source "${SCRIPT_DIR}/demo-config.sh"

# Optional: Load state if needed
STATE_FILE="${SCRIPT_DIR}/../.demo-state"
[ -f "$STATE_FILE" ] && source "$STATE_FILE"

# Update state (only in setup.sh)
cat > "$STATE_FILE" << EOF
LAST_SETUP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
LAST_VERIFY="${LAST_VERIFY:-}"
LAST_CLEANUP="${LAST_CLEANUP:-}"
SETUP_COUNT=$((${SETUP_COUNT:-0} + 1))
EOF
```

### Migration Path

1. **Phase 1: Create new files**
   - Extract config values to `scripts/demo-config.sh`
   - Add `.demo-state` to `.gitignore`
   - Keep VERSION temporarily for backward compatibility

2. **Phase 2: Update scripts**
   - Modify scripts to source from `demo-config.sh`
   - Write state to `.demo-state` instead of VERSION
   - Test all functionality

3. **Phase 3: Deprecate VERSION**
   - Add deprecation notice to VERSION
   - Update documentation
   - Remove VERSION after grace period

## Additional Recommendations

### 1. Add Config Validation
```bash
# In demo-config.sh
validate_config() {
    [ -z "$PACKAGE_VERSION" ] && echo "Error: PACKAGE_VERSION not set" && exit 1
    [ -z "$DEMO_COMMIT" ] && echo "Error: DEMO_COMMIT not set" && exit 1
    return 0
}
```

### 2. Provide Config Override Mechanism
```bash
# Allow local overrides for development
[ -f "${SCRIPT_DIR}/demo-config.local.sh" ] && source "${SCRIPT_DIR}/demo-config.local.sh"
```

### 3. Add Config Documentation
```bash
# demo-config.sh
# PACKAGE_VERSION: NPM package version to install (format: X.Y.Z)
# DEMO_COMMIT: Git commit hash for example-monorepo checkout
# DEMO_BRANCH: Fallback branch if commit not found
```

### 4. Consider Future JSON Migration
If the configuration grows complex, consider migrating to JSON:
```json
{
  "demo": {
    "packageVersion": "2.2.1",
    "repository": {
      "commit": "cb149a8b228004ac94100eb507fd362e0ff65c89",
      "branch": "demo/example-project"
    },
    "features": {
      "autoInstall": true,
      "verifyOnSetup": true
    }
  }
}
```

## Security Considerations

1. **Never store secrets** in any committed configuration file
2. **Use read-only variables** (`readonly` in bash) for immutable configs
3. **Validate all sourced files** before execution
4. **Document security implications** in README

## Conclusion

The current VERSION file approach violates several established best practices by mixing configuration with runtime state. The recommended separated configuration/state pattern aligns with industry standards seen in popular frameworks like Vite, Next.js, and enterprise configuration management tools.

This approach provides:
- **Clear separation of concerns**
- **Git-friendly** (no runtime changes in tracked files)
- **Industry-standard patterns** familiar to developers
- **Flexibility** for future enhancements
- **Security** through proper secret management patterns

## Sources

- [GitHub Repository Best Practices](https://docs.github.com/en/repositories/creating-and-managing-repositories/best-practices-for-repositories)
- [GitHub Best Practices - DEV Community](https://dev.to/pwd9000/github-repository-best-practices-23ck)
- [Environment Variables Best Practices](https://dev.to/khalidk799/environment-variables-its-best-practices-1o1o)
- [Best Practice to Source Config in Bash](https://stackoverflow.com/questions/51600299/best-practice-to-source-a-config-file-in-bash)
- [Vite Configuration Guide](https://vite.dev/guide/)
- [Next.js Getting Started](https://nextjs.org/docs/app/getting-started/installation)
- [launchcodedev/app-config](https://github.com/launchcodedev/app-config)
- [Best Practices for .env Files](https://www.getfishtank.com/insights/best-practices-for-committing-env-files-to-version-control)

---

**Document Location**: `/Users/samuelgleeson/dev/c2/claude-monorepo-guard-demo-kit/docs/DEMO-CONFIG-RESEARCH.md`
**Created**: 2025-11-21
**Author**: Claude (AI Assistant)