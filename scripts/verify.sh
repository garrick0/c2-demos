#!/bin/bash
set -e

echo "=========================================="
echo "Demo Environment Verification"
echo "=========================================="
echo ""

# Load configuration
SCRIPT_DIR="$(dirname "$0")"
if [ ! -f "${SCRIPT_DIR}/demo-config.sh" ]; then
    echo "❌ Configuration not found"
    echo "   Expected: ${SCRIPT_DIR}/demo-config.sh"
    echo "   Run ./scripts/setup.sh first"
    exit 1
fi

source "${SCRIPT_DIR}/demo-config.sh"

# Load state file if it exists
STATE_FILE=".demo-state"
if [ -f "$STATE_FILE" ]; then
    source "$STATE_FILE"
fi

echo "📌 Pinned Version: ${PACKAGE_VERSION}"
echo "📅 Created: ${CREATED_DATE}"
if [ -n "$LAST_SETUP" ]; then
    echo "📝 Last Setup: ${LAST_SETUP}"
fi
echo ""

ERRORS=0
WARNINGS=0

# Check Node.js version
echo "🔍 Checking prerequisites..."
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    # Extract major version number
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
    if [ "$NODE_MAJOR" -ge 16 ]; then
        echo "  ✓ Node.js: ${NODE_VERSION}"
    else
        echo "  ❌ Node.js: ${NODE_VERSION} (requires >= 16.0.0)"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "  ❌ Node.js not installed"
    ERRORS=$((ERRORS + 1))
fi

# Check npm version
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "  ✓ npm: ${NPM_VERSION}"
else
    echo "  ❌ npm not installed"
    ERRORS=$((ERRORS + 1))
fi

# Check Claude CLI
if command -v claude &> /dev/null; then
    echo "  ✓ Claude CLI is installed"
else
    echo "  ⚠ Claude CLI not found"
    echo "    Install from: https://claude.ai/download"
    WARNINGS=$((WARNINGS + 1))
fi

# Check Git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo "  ✓ Git: ${GIT_VERSION}"
else
    echo "  ❌ Git not installed"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "🔍 Checking demo structure..."

# Check example-monorepo exists
if [ -d "example-monorepo" ]; then
    echo "  ✓ Example monorepo exists"

    # Verify it's at the right commit
    cd example-monorepo
    CURRENT_COMMIT=$(git rev-parse HEAD)
    if [ "$CURRENT_COMMIT" = "$DEMO_COMMIT" ]; then
        echo "  ✓ Correct commit checked out (${DEMO_COMMIT:0:7})"
    else
        echo "  ❌ Wrong commit checked out"
        echo "    Expected: ${DEMO_COMMIT:0:7}"
        echo "    Current:  ${CURRENT_COMMIT:0:7}"
        ERRORS=$((ERRORS + 1))
    fi

    # Check for clean state (no claude configs should exist)
    if [ -f ".claudemonorepo" ]; then
        echo "  ❌ .claudemonorepo exists (should be clean)"
        echo "    Run: ./scripts/cleanup.sh"
        ERRORS=$((ERRORS + 1))
    else
        echo "  ✓ No .claudemonorepo file (clean)"
    fi

    if [ -d ".claude" ]; then
        echo "  ❌ .claude/ directory exists (should be clean)"
        echo "    Run: ./scripts/cleanup.sh"
        ERRORS=$((ERRORS + 1))
    else
        echo "  ✓ No .claude/ directory (clean)"
    fi

    # Check monorepo structure
    if [ -f "pnpm-workspace.yaml" ]; then
        echo "  ✓ pnpm-workspace.yaml exists"
    else
        echo "  ❌ pnpm-workspace.yaml missing"
        ERRORS=$((ERRORS + 1))
    fi

    # Check project directories
    MISSING_DIRS=0
    for dir in apps/api apps/web packages/core packages/ui; do
        if [ ! -d "$dir" ]; then
            MISSING_DIRS=$((MISSING_DIRS + 1))
        fi
    done

    if [ $MISSING_DIRS -eq 0 ]; then
        echo "  ✓ All project directories present"
    else
        echo "  ❌ Missing ${MISSING_DIRS} project directories"
        ERRORS=$((ERRORS + 1))
    fi

    cd ..
else
    echo "  ❌ Example monorepo not found"
    echo "    Run: ./scripts/setup.sh"
    ERRORS=$((ERRORS + 1))
fi

echo ""
echo "🔍 Checking claude-monorepo-guard installation..."

# First check if the command exists
if ! command -v claude-monorepo-guard &> /dev/null; then
    echo "  ⚠ claude-monorepo-guard not installed"
    echo "    Run: npm install -g claude-monorepo-guard@${PACKAGE_VERSION}"
    WARNINGS=$((WARNINGS + 1))
else
    # Check the actual binary version
    BINARY_VERSION=$(claude-monorepo-guard --version 2>/dev/null || echo "unknown")

    # Also check npm list to detect linked packages
    NPM_OUTPUT=$(npm list -g claude-monorepo-guard --depth=0 2>/dev/null || echo "")
    IS_LINKED=$(echo "$NPM_OUTPUT" | grep ">" 2>/dev/null | wc -l | tr -d ' ')

    if [ "$IS_LINKED" -gt 0 ]; then
        echo "  ⚠ Development version is linked (not using published package)"
        echo "    Binary reports version: ${BINARY_VERSION}"
        echo "    Expected: ${PACKAGE_VERSION}"
        echo "    Run: npm unlink -g claude-monorepo-guard"
        echo "         npm uninstall -g claude-monorepo-guard"
        echo "         npm install -g claude-monorepo-guard@${PACKAGE_VERSION}"
        WARNINGS=$((WARNINGS + 1))
    elif [ "$BINARY_VERSION" = "$PACKAGE_VERSION" ]; then
        echo "  ✓ claude-monorepo-guard@${PACKAGE_VERSION} is installed"
    else
        echo "  ⚠ Wrong version installed: ${BINARY_VERSION}"
        echo "    Expected: ${PACKAGE_VERSION}"
        echo "    Run: npm uninstall -g claude-monorepo-guard"
        echo "         npm install -g claude-monorepo-guard@${PACKAGE_VERSION}"
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Check if scripts are executable
echo ""
echo "🔍 Checking scripts..."
SCRIPTS_OK=true
for script in setup.sh verify.sh cleanup.sh; do
    if [ -f "scripts/$script" ]; then
        if [ -x "scripts/$script" ]; then
            echo "  ✓ $script is executable"
        else
            echo "  ⚠ $script is not executable"
            echo "    Run: chmod +x scripts/$script"
            SCRIPTS_OK=false
            WARNINGS=$((WARNINGS + 1))
        fi
    else
        echo "  ❌ $script not found"
        ERRORS=$((ERRORS + 1))
    fi
done

# Summary
echo ""
echo "=========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ All checks passed!"
    echo ""
    echo "Ready to start demo:"
    echo "  cd example-monorepo"
    echo "  Follow ../docs/DEMO-COMMANDS.md"
elif [ $ERRORS -eq 0 ]; then
    echo "⚠ Verification completed with $WARNINGS warning(s)"
    echo ""
    echo "Demo can proceed, but consider fixing warnings."
else
    echo "❌ Verification failed with $ERRORS error(s) and $WARNINGS warning(s)"
    echo ""
    echo "Please fix errors before proceeding."
    exit 1
fi
echo "=========================================="