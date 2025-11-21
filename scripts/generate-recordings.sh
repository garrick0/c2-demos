#!/bin/bash

# Generate VHS recordings for claude-monorepo-guard demo
# This script automates the creation of all demo recordings

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Options
SEGMENTS_ONLY=false
QUICK_ONLY=false
COMPLETE_ONLY=false
SKIP_CLEANUP=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --segments-only)
            SEGMENTS_ONLY=true
            shift
            ;;
        --quick-only)
            QUICK_ONLY=true
            shift
            ;;
        --complete-only)
            COMPLETE_ONLY=true
            shift
            ;;
        --skip-cleanup)
            SKIP_CLEANUP=true
            shift
            ;;
        --help)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --segments-only    Generate only segment recordings"
            echo "  --quick-only       Generate only quick demo GIF"
            echo "  --complete-only    Generate only complete demo video"
            echo "  --skip-cleanup     Skip cleanup before recording"
            echo "  --help            Show this help message"
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}"
            exit 1
            ;;
    esac
done

# Function to print section headers
print_header() {
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}$1${NC}"
    echo -e "${CYAN}════════════════════════════════════════════════════════${NC}"
    echo ""
}

# Function to check requirements
check_requirements() {
    print_header "Checking Requirements"

    # Check VHS
    if ! command -v vhs &> /dev/null; then
        echo -e "${RED}✗ VHS is not installed${NC}"
        echo "  Install with: brew install vhs"
        exit 1
    else
        echo -e "${GREEN}✓ VHS found:${NC} $(vhs --version)"
    fi

    # Check ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        echo -e "${YELLOW}⚠ ffmpeg not found${NC}"
        echo "  Some video formats may not work"
        echo "  Install with: brew install ffmpeg"
    else
        echo -e "${GREEN}✓ ffmpeg found${NC}"
    fi

    # Check example-monorepo exists
    if [ ! -d "$ROOT_DIR/example-monorepo" ]; then
        echo -e "${RED}✗ example-monorepo not found${NC}"
        echo "  Run setup.sh first"
        exit 1
    else
        echo -e "${GREEN}✓ example-monorepo found${NC}"
    fi

    # Check mock-claude.sh exists
    if [ ! -f "$SCRIPT_DIR/mock-claude.sh" ]; then
        echo -e "${RED}✗ mock-claude.sh not found${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ mock-claude.sh found${NC}"
    fi

    # Check VHS scripts exist
    if [ ! -d "$ROOT_DIR/vhs-scripts" ]; then
        echo -e "${RED}✗ vhs-scripts directory not found${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ vhs-scripts directory found${NC}"
    fi
}

# Function to prepare environment
prepare_environment() {
    print_header "Preparing Environment"

    cd "$ROOT_DIR"

    # Run cleanup unless skipped
    if [ "$SKIP_CLEANUP" = false ]; then
        echo "Running cleanup..."
        if [ -f "$SCRIPT_DIR/cleanup.sh" ]; then
            "$SCRIPT_DIR/cleanup.sh"
            echo -e "${GREEN}✓ Cleanup completed${NC}"
        else
            echo -e "${YELLOW}⚠ cleanup.sh not found, skipping${NC}"
        fi
    else
        echo -e "${YELLOW}Skipping cleanup (--skip-cleanup)${NC}"
    fi

    # Ensure recordings directories exist
    mkdir -p "$ROOT_DIR/recordings/segments"
    mkdir -p "$ROOT_DIR/recordings/social"
    echo -e "${GREEN}✓ Recording directories prepared${NC}"

    # Check claude-monorepo-guard is installed
    if ! command -v claude-monorepo-guard &> /dev/null; then
        echo -e "${YELLOW}⚠ claude-monorepo-guard not installed${NC}"
        echo "  Recordings may fail. Install with:"
        echo "  npm install -g claude-monorepo-guard@2.1.2"
    fi
}

# Function to generate a single recording
generate_recording() {
    local tape_file=$1
    local description=$2

    if [ ! -f "$tape_file" ]; then
        echo -e "${RED}  ✗ Tape file not found: $tape_file${NC}"
        return 1
    fi

    echo -e "${CYAN}Generating:${NC} $description"
    echo "  From: $tape_file"

    # Run VHS
    if vhs "$tape_file" 2>/dev/null; then
        echo -e "${GREEN}  ✓ Success${NC}"
        return 0
    else
        echo -e "${RED}  ✗ Failed${NC}"
        return 1
    fi
}

# Function to generate segment recordings
generate_segments() {
    print_header "Generating Segment Recordings"

    local success_count=0
    local fail_count=0

    # List of segments
    declare -a segments=(
        "01-installation:Installation Demo"
        "02-initialization:Initialization Process"
        "03-branch-protection:Branch Protection"
        "04-root-protection:Root Directory Protection"
        "05-project-list:Project Listing"
    )

    for segment_info in "${segments[@]}"; do
        IFS=':' read -r filename description <<< "$segment_info"
        tape_file="$ROOT_DIR/vhs-scripts/segments/${filename}.tape"

        if generate_recording "$tape_file" "$description"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
        echo ""
    done

    echo -e "${BOLD}Segments complete:${NC} ${GREEN}$success_count succeeded${NC}, ${RED}$fail_count failed${NC}"
}

# Function to generate quick demo
generate_quick() {
    print_header "Generating Quick Demo GIF"

    tape_file="$ROOT_DIR/vhs-scripts/quick-demo.tape"
    if generate_recording "$tape_file" "Quick Demo (30 seconds)"; then
        echo -e "${GREEN}✓ Quick demo generated successfully${NC}"

        # Check file size
        if [ -f "$ROOT_DIR/recordings/quick-demo.gif" ]; then
            size=$(du -h "$ROOT_DIR/recordings/quick-demo.gif" | cut -f1)
            echo "  File size: $size"

            # Warn if too large for GitHub
            size_bytes=$(stat -f%z "$ROOT_DIR/recordings/quick-demo.gif" 2>/dev/null || stat -c%s "$ROOT_DIR/recordings/quick-demo.gif" 2>/dev/null || echo "0")
            if [ "$size_bytes" -gt 10485760 ]; then  # 10MB
                echo -e "${YELLOW}  ⚠ Warning: GIF is larger than 10MB, may not display on GitHub${NC}"
            fi
        fi
    else
        echo -e "${RED}✗ Quick demo generation failed${NC}"
    fi
}

# Function to generate complete demo
generate_complete() {
    print_header "Generating Complete Demo Video"

    tape_file="$ROOT_DIR/vhs-scripts/complete-demo.tape"
    echo -e "${YELLOW}Note: This will take several minutes...${NC}"

    if generate_recording "$tape_file" "Complete Demo (7 minutes)"; then
        echo -e "${GREEN}✓ Complete demo generated successfully${NC}"

        # Check file size
        if [ -f "$ROOT_DIR/recordings/complete-demo.mp4" ]; then
            size=$(du -h "$ROOT_DIR/recordings/complete-demo.mp4" | cut -f1)
            echo "  File size: $size"
        fi
    else
        echo -e "${RED}✗ Complete demo generation failed${NC}"
    fi
}

# Function to list generated files
list_recordings() {
    print_header "Generated Recordings"

    echo "Looking for recordings in: $ROOT_DIR/recordings/"
    echo ""

    if ls "$ROOT_DIR/recordings"/*.{gif,mp4,webm} 2>/dev/null 1>&2; then
        echo -e "${BOLD}Main recordings:${NC}"
        ls -lah "$ROOT_DIR/recordings"/*.{gif,mp4,webm} 2>/dev/null | grep -v "^ls:"
    fi

    echo ""

    if ls "$ROOT_DIR/recordings/segments"/*.gif 2>/dev/null 1>&2; then
        echo -e "${BOLD}Segment recordings:${NC}"
        ls -lah "$ROOT_DIR/recordings/segments"/*.gif 2>/dev/null
    fi
}

# Main execution
main() {
    print_header "VHS Recording Generator"
    echo "Generating demo recordings for claude-monorepo-guard"
    echo ""

    # Check requirements
    check_requirements

    # Prepare environment
    prepare_environment

    # Generate recordings based on options
    if [ "$SEGMENTS_ONLY" = true ]; then
        generate_segments
    elif [ "$QUICK_ONLY" = true ]; then
        generate_quick
    elif [ "$COMPLETE_ONLY" = true ]; then
        generate_complete
    else
        # Generate all
        generate_segments
        echo ""
        generate_quick
        echo ""
        generate_complete
    fi

    # List generated files
    list_recordings

    print_header "Recording Generation Complete"
    echo -e "${GREEN}✓ All requested recordings have been processed${NC}"
    echo ""
    echo "Next steps:"
    echo "  - Review recordings in: $ROOT_DIR/recordings/"
    echo "  - Test GIFs in markdown: ![Demo](recordings/quick-demo.gif)"
    echo "  - Upload MP4s to video hosting for embedding"
    echo ""
}

# Run main function
main "$@"