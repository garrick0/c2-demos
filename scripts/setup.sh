#!/bin/bash
set -e

# Configuration
DEMO_VERSION="2.1.2"
DEMO_COMMIT="cb149a8b228004ac94100eb507fd362e0ff65c89"
DEMO_BRANCH="demo/example-project"

echo "=========================================="
echo "Claude Monorepo Guard Demo Kit Setup"
echo "Version: ${DEMO_VERSION}"
echo "=========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "VERSION" ]; then
    echo "❌ Error: Must run from demo kit root directory"
    echo "   Current directory: $(pwd)"
    exit 1
fi

# Create structure if needed
echo "📁 Creating folder structure..."
mkdir -p recordings docs assets scripts

# Check if example-monorepo already exists
if [ -d "example-monorepo" ]; then
    echo "✓ Example monorepo already exists"
    echo "  Verifying commit..."
    cd example-monorepo
    CURRENT_COMMIT=$(git rev-parse HEAD)
    if [ "$CURRENT_COMMIT" = "$DEMO_COMMIT" ]; then
        echo "  ✓ Correct commit checked out"
    else
        echo "  ⚠ Wrong commit, switching to ${DEMO_COMMIT:0:7}..."
        git checkout ${DEMO_COMMIT}
    fi
    cd ..
else
    echo "📥 Cloning example monorepo..."
    # Try to clone from parent directory first (local development)
    if [ -d "../claude-monorepo-guard-demo" ]; then
        echo "  Cloning from local worktree..."
        git clone ../claude-monorepo-guard-demo example-monorepo
    elif [ -d "../claude-monorepo-guard-cleanup" ]; then
        echo "  Cloning from main repo..."
        git clone ../claude-monorepo-guard-cleanup example-monorepo
    elif [ -n "$GITHUB_ACTIONS" ]; then
        echo "  Cloning from GitHub (CI environment)..."
        git clone --branch ${DEMO_BRANCH} https://github.com/garrick0/claude-guard.git example-monorepo
    else
        echo "  ❌ Error: Cannot find source repository"
        echo "     Expected ../claude-monorepo-guard-demo or ../claude-monorepo-guard-cleanup"
        echo "     Or GITHUB_ACTIONS environment variable for CI"
        exit 1
    fi

    cd example-monorepo
    echo "  Checking out demo commit..."
    git checkout ${DEMO_COMMIT}
    cd ..
fi

# Update VERSION file
echo "📝 Updating VERSION file..."
cat > VERSION << EOF
PACKAGE_VERSION=${DEMO_VERSION}
DEMO_COMMIT=${DEMO_COMMIT}
DEMO_BRANCH=${DEMO_BRANCH}
CREATED=$(date -u +"%Y-%m-%d")
LAST_SETUP="$(date -u +"%Y-%m-%d %H:%M:%S UTC")"
EOF

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x scripts/*.sh 2>/dev/null || true

# Check Node.js
echo ""
echo "📋 Environment Check:"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    echo "  ✓ Node.js: ${NODE_VERSION}"
else
    echo "  ❌ Node.js not found - please install Node.js >= 16.0.0"
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    echo "  ✓ npm: ${NPM_VERSION}"
else
    echo "  ❌ npm not found"
fi

# Check Claude CLI
if command -v claude &> /dev/null; then
    echo "  ✓ Claude CLI is installed"
else
    echo "  ⚠ Claude CLI not found - install from https://claude.ai/download"
fi

echo ""
echo "=========================================="
echo "✅ Demo kit setup complete!"
echo ""
echo "Next steps:"
echo "1. Install pinned version:"
echo "   npm install -g claude-monorepo-guard@${DEMO_VERSION}"
echo ""
echo "2. Verify setup:"
echo "   ./scripts/verify.sh"
echo ""
echo "3. Start demo:"
echo "   cd example-monorepo"
echo "   Follow ../docs/DEMO-COMMANDS.md"
echo "=========================================="