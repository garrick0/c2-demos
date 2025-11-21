#!/bin/bash

# Mock Claude CLI for VHS recordings
# This simulates the blocking behavior without launching actual Claude Code

# Color codes
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Check if we're in monorepo root and should be blocked
if [ -f ".claudemonorepo" ] && [ -f "pnpm-workspace.yaml" ] && [ "$PWD" = "$(git rev-parse --show-toplevel 2>/dev/null)" ]; then
    # In monorepo root - show block message
    echo ""
    echo -e "${RED}❌ Check Failed:${NC}"
    echo ""
    echo -e "  ${BOLD}Operations in monorepo root are restricted${NC}"
    echo -e "  ${CYAN}💡 Navigate to a specific project directory${NC}"
    echo ""
    echo -e "  ${BOLD}Available projects:${NC}"
    echo -e "    - apps/api"
    echo -e "    - apps/web"
    echo -e "    - packages/core"
    echo -e "    - packages/ui"
    echo ""
    exit 1
fi

# Check if we're on main branch and should be blocked
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null)
if [ "$CURRENT_BRANCH" = "main" ] || [ "$CURRENT_BRANCH" = "master" ]; then
    echo ""
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║  🚫 Cannot work on main branch directly                     ║"
    echo "║                                                              ║"
    echo "║  Create a worktree for feature work:                        ║"
    echo "║    git worktree add ../demo-wt/my-feature -b feature/xyz   ║"
    echo "║    cd ../demo-wt/my-feature                                ║"
    echo "║    npm install && npm run build                             ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo ""
    exit 1
fi

# Check for uncommitted changes warning
if ! git diff --quiet 2>/dev/null || ! git diff --staged --quiet 2>/dev/null; then
    echo ""
    echo -e "${YELLOW}⚠️  Uncommitted changes detected - commit before major work${NC}"
    echo ""
    # Continue with warning (don't exit)
fi

# If we get here, Claude would launch successfully
echo ""
echo -e "${GREEN}✓${NC} Claude Code launching..."
echo -e "${CYAN}Starting AI-powered coding assistant...${NC}"
echo ""
echo "Claude> Ready to help with your project!"
echo ""

# Simulate Claude prompt (for visual effect)
sleep 1
echo -e "${BOLD}Claude>${NC} _"