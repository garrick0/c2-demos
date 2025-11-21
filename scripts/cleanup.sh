#!/bin/bash

echo "=========================================="
echo "Demo Environment Cleanup"
echo "=========================================="
echo ""

# Load version info
if [ -f "VERSION" ]; then
    source ./VERSION
else
    echo "⚠ VERSION file not found, using defaults"
    DEMO_COMMIT="cb149a8b228004ac94100eb507fd362e0ff65c89"
fi

if [ ! -d "example-monorepo" ]; then
    echo "❌ example-monorepo not found"
    echo "   Run ./scripts/setup.sh first"
    exit 1
fi

cd example-monorepo

echo "🧹 Cleaning up demo environment..."
echo ""

# Remove any created configuration files
echo "📄 Removing configuration files..."
if [ -f ".claudemonorepo" ]; then
    rm -f .claudemonorepo
    echo "  ✓ Removed .claudemonorepo"
else
    echo "  - .claudemonorepo not found (already clean)"
fi

if [ -d ".claude" ]; then
    rm -rf .claude/
    echo "  ✓ Removed .claude/ directory"
else
    echo "  - .claude/ directory not found (already clean)"
fi

# Remove any test files that might have been created
echo ""
echo "📝 Removing test files..."
TEST_FILES=(
    "test.txt"
    "test"
    "*.log"
    ".DS_Store"
)

REMOVED_COUNT=0
for pattern in "${TEST_FILES[@]}"; do
    if ls $pattern 2>/dev/null 1>&2; then
        rm -f $pattern
        echo "  ✓ Removed $pattern"
        REMOVED_COUNT=$((REMOVED_COUNT + 1))
    fi
done

if [ $REMOVED_COUNT -eq 0 ]; then
    echo "  - No test files found"
fi

# Check git status
echo ""
echo "🔍 Checking git status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "  ⚠ Uncommitted changes detected"
    echo ""
    echo "  Files with changes:"
    git status --short | sed 's/^/    /'
    echo ""

    read -p "  Reset all changes to demo commit? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ""
        echo "  Resetting to demo commit..."
        git reset --hard ${DEMO_COMMIT}
        git clean -fd
        echo "  ✓ Reset complete"
    else
        echo "  ⚠ Skipping git reset - manual cleanup may be needed"
    fi
else
    echo "  ✓ Working directory clean"
fi

# Verify we're at the right commit
CURRENT_COMMIT=$(git rev-parse HEAD)
if [ "$CURRENT_COMMIT" = "$DEMO_COMMIT" ]; then
    echo "  ✓ On correct demo commit (${DEMO_COMMIT:0:7})"
else
    echo "  ⚠ Not on demo commit"
    echo "    Current:  ${CURRENT_COMMIT:0:7}"
    echo "    Expected: ${DEMO_COMMIT:0:7}"
    echo ""
    read -p "  Checkout demo commit? (y/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git checkout ${DEMO_COMMIT}
        echo "  ✓ Checked out demo commit"
    fi
fi

cd ..

echo ""
echo "=========================================="

# Final verification
CLEAN=true
if [ -f "example-monorepo/.claudemonorepo" ]; then
    CLEAN=false
fi
if [ -d "example-monorepo/.claude" ]; then
    CLEAN=false
fi

if [ "$CLEAN" = true ]; then
    echo "✅ Demo environment reset to clean state!"
    echo ""
    echo "Ready for demo:"
    echo "  cd example-monorepo"
    echo "  npm install -g claude-monorepo-guard@${PACKAGE_VERSION:-2.0.0}"
    echo "  Follow ../docs/DEMO-COMMANDS.md"
else
    echo "⚠ Cleanup completed but some files may remain"
    echo "  Check example-monorepo/ directory manually"
fi
echo "=========================================="