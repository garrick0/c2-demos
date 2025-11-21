# VHS Recording Plan for Claude Monorepo Guard Demo

## Overview

This plan outlines how to use [VHS](https://github.com/charmbracelet/vhs) by Charm to create automated, reproducible terminal recordings of the claude-monorepo-guard demo.

## What is VHS?

VHS is a tool that generates terminal recordings (GIFs, MP4s, WebM) from a simple script file. It automates typing, captures output, and produces consistent recordings.

**Benefits for this demo:**
- ✅ Fully reproducible recordings
- ✅ No manual typing errors
- ✅ Consistent timing and pacing
- ✅ Easy to re-record when package updates
- ✅ Multiple output formats (GIF, MP4, WebM)
- ✅ Version controlled scripts

## Installation

```bash
# macOS
brew install vhs

# Or using go
go install github.com/charmbracelet/vhs@latest
```

**Dependencies:**
- ffmpeg (for video encoding)
- ttyd (for terminal emulation)

```bash
brew install ffmpeg ttyd
```

## Proposed Recording Structure

### Option A: Single Complete Demo (7 minutes)
**File:** `vhs-scripts/complete-demo.tape`
- Full walkthrough following DEMO-NARRATION.md
- Output: `recordings/complete-demo.mp4`
- Best for: Website hero video, YouTube

### Option B: Segmented Demos (Recommended)
Create separate recordings for each feature:

1. **`vhs-scripts/01-installation.tape`** (~45 seconds)
   - Install package
   - Verify installation
   - Check status
   - Output: `recordings/01-installation.gif`

2. **`vhs-scripts/02-initialization.tape`** (~60 seconds)
   - Run init command
   - Show interactive prompts
   - Display created files
   - Output: `recordings/02-initialization.gif`

3. **`vhs-scripts/03-branch-protection.tape`** (~60 seconds)
   - Show current branch (main)
   - Attempt Claude Code
   - Show block message
   - Switch to feature branch
   - Output: `recordings/03-branch-protection.gif`

4. **`vhs-scripts/04-root-protection.tape`** (~90 seconds)
   - Attempt Claude from root
   - Show block with project list
   - Navigate to project
   - Launch Claude successfully
   - Output: `recordings/04-root-protection.gif`

5. **`vhs-scripts/05-project-list.tape`** (~30 seconds)
   - Show list command
   - Display all projects
   - Output: `recordings/05-project-list.gif`

### Option C: Quick Demo Loop (2 minutes)
**File:** `vhs-scripts/quick-demo.tape`
- Condensed version for README
- Shows key features quickly
- Output: `recordings/quick-demo.gif`

## VHS Script Structure

### Basic Template

```tape
# VHS Script Template
# Output configuration
Output recordings/output-name.gif
Set Theme "Catppuccin Mocha"
Set FontSize 18
Set Width 1200
Set Height 800
Set TypingSpeed 50ms
Set PlaybackSpeed 1.0

# Setup
Type "cd example-monorepo"
Enter
Sleep 500ms

# Demo commands
Type "claude-monorepo-guard status"
Enter
Sleep 2s

# Cleanup
Type "clear"
Enter
```

## Proposed VHS Scripts

### Script 1: Complete Demo
**File:** `vhs-scripts/complete-demo.tape`

**Sections:**
1. Introduction (show structure)
2. Installation
3. Initialization
4. Branch protection demo
5. Root protection demo
6. Project listing
7. Status summary

**Estimated Length:** 7-8 minutes
**Output Format:** MP4 (better for long videos)

### Script 2-6: Feature Segments
Individual `.tape` files for each feature demo.

**Benefits:**
- Easier to update individual sections
- Can be embedded in different docs
- Smaller file sizes for GIFs
- Modular approach

### Script 7: README Hero
**File:** `vhs-scripts/readme-hero.tape`

**Contents:**
- 30-second quick demo
- Shows init → block → navigate → success
- Perfect for GitHub README

**Output Format:** GIF (for easy embedding)

## Timing and Pacing Strategy

### Typing Speeds
- **Commands:** 50ms per character (natural typing)
- **Long commands:** 30ms (slightly faster for readability)
- **Comments:** 40ms

### Pause Durations
- **After Enter:** 1-2s (let command process)
- **After output:** 2-3s (let viewer read)
- **After important messages:** 3-4s (emphasis)
- **Between sections:** 1s (transition)

### Playback Speed
- **Default:** 1.0x (real-time)
- **Installation:** 1.5x (can speed up npm install)
- **Reading output:** 0.8x (slow down for block messages)

## Visual Configuration

### Theme
**Recommended:** Catppuccin Mocha or Nord
- High contrast
- Professional appearance
- Easy to read

### Font
**Recommended:** JetBrains Mono or Fira Code
- Monospace
- Clear at various sizes
- Good number/letter distinction

### Terminal Size
- **Width:** 1200px (fits most screens)
- **Height:** 800px (standard aspect ratio)
- **Font Size:** 18pt (readable in videos)

## Pre-recording Setup Requirements

### 1. Environment Preparation
```bash
# Clean state
./scripts/cleanup.sh

# Verify environment
./scripts/verify.sh

# Ensure correct version installed
npm list -g claude-monorepo-guard | grep 2.1.2
```

### 2. Git State
```bash
# On main branch initially for branch demo
git checkout main

# Clean working tree
git status  # Should be clean
```

### 3. Mock Claude CLI (if needed)
Since VHS can't actually run interactive Claude Code, we may need:
- Mock script that simulates Claude startup
- Or skip the actual `claude` command execution
- Or record the block message separately

**Decision needed:** How to handle interactive Claude Code in automated recording?

## Output Files Organization

```
recordings/
├── complete-demo.mp4           # Full 7-minute demo
├── quick-demo.gif             # 30-second README version
├── segments/
│   ├── 01-installation.gif
│   ├── 02-initialization.gif
│   ├── 03-branch-protection.gif
│   ├── 04-root-protection.gif
│   └── 05-project-list.gif
└── social/
    ├── twitter-demo.gif       # Optimized for Twitter (< 5MB)
    └── linkedin-demo.mp4      # Optimized for LinkedIn
```

## VHS Scripts Directory Structure

```
vhs-scripts/
├── README.md                  # How to use the scripts
├── complete-demo.tape         # Full demo
├── quick-demo.tape           # Short version
├── segments/
│   ├── 01-installation.tape
│   ├── 02-initialization.tape
│   ├── 03-branch-protection.tape
│   ├── 04-root-protection.tape
│   └── 05-project-list.tape
├── shared/
│   └── setup.tape            # Common setup commands
└── themes/
    └── demo-theme.json       # Custom theme if needed
```

## Recording Workflow

### Step 1: Write VHS Scripts
Create `.tape` files for each recording segment.

### Step 2: Test Individual Scripts
```bash
# Test a single script
vhs vhs-scripts/segments/01-installation.tape

# Preview output
open recordings/segments/01-installation.gif
```

### Step 3: Iterate and Refine
- Adjust timing
- Fix typos
- Optimize pauses
- Test on different screens

### Step 4: Generate Final Recordings
```bash
# Generate all recordings
./scripts/generate-recordings.sh

# Or individually
vhs vhs-scripts/complete-demo.tape
vhs vhs-scripts/quick-demo.tape
# etc.
```

### Step 5: Optimize Output
```bash
# Optimize GIFs (if needed)
gifsicle -O3 --colors 256 recordings/quick-demo.gif -o recordings/quick-demo-optimized.gif

# Compress MP4s (if needed)
ffmpeg -i recordings/complete-demo.mp4 -vcodec h264 -acodec aac recordings/complete-demo-compressed.mp4
```

## Automation Script

### `scripts/generate-recordings.sh`
**Purpose:** Generate all VHS recordings in one command

**Features:**
- Verify environment is clean
- Run cleanup before recording
- Execute all .tape files
- Report success/failure
- Estimate total time

**Usage:**
```bash
./scripts/generate-recordings.sh
# Or for specific recordings:
./scripts/generate-recordings.sh --segments-only
./scripts/generate-recordings.sh --quick-only
```

## Handling Interactive Commands

### Challenge: Claude Code Interactive Prompt
The `claude` command launches an interactive session that VHS can't fully automate.

### Solutions:

**Option 1: Mock Script**
Create `scripts/mock-claude.sh` that simulates the blocking behavior:
```bash
#!/bin/bash
# Shows the block message but doesn't actually launch Claude
cat .claude/block-message.txt
exit 1
```

**Option 2: Screenshot Insertion**
- Record everything except Claude launch
- Insert screenshot of block message
- Requires video editing

**Option 3: Manual Hybrid**
- Record most with VHS
- Manually record Claude interaction
- Combine in editing

**Recommendation:** Option 1 (mock script) for full automation

## Git Integration

### Committing VHS Scripts
```bash
git add vhs-scripts/
git add scripts/generate-recordings.sh
git commit -m "feat: add VHS recording scripts"
```

### .gitignore Considerations
```
# Don't commit large binary recordings
recordings/*.mp4
recordings/*.webm

# Do commit example GIFs (if small enough)
!recordings/quick-demo.gif
!recordings/segments/*.gif
```

## CI/CD Integration (Optional)

### Automated Recording on Release
Could add GitHub Actions workflow:
- Trigger on version tag
- Run setup
- Install dependencies
- Generate recordings
- Upload as release assets

**File:** `.github/workflows/generate-recordings.yml`

## Quality Checklist

Before finalizing recordings:

- [ ] All commands execute correctly
- [ ] Output is readable at target size
- [ ] Timing feels natural (not too fast/slow)
- [ ] Important messages have adequate pause time
- [ ] Color scheme is professional
- [ ] File sizes are reasonable (< 10MB for GIFs)
- [ ] Works on both light/dark backgrounds
- [ ] Tested on different screen sizes

## Distribution Strategy

### Where to Use Recordings

**Complete Demo (MP4):**
- YouTube
- Website landing page
- Conference presentations
- LinkedIn posts

**Quick Demo (GIF):**
- GitHub README
- npm package page
- Twitter/X posts
- Documentation intro

**Segment GIFs:**
- Feature-specific documentation
- Blog posts
- Tutorial sections
- Social media snippets

## Alternative Formats

### In addition to VHS, consider:

**ASCII Cinema (.cast files):**
- Smaller file sizes
- Embeddable in web pages
- VHS can export to this format

**Command:**
```tape
Output recordings/demo.cast
# ... rest of script
```

## Estimated Timeline

**Phase 1: Setup (30 minutes)**
- Install VHS and dependencies
- Create directory structure
- Test basic recording

**Phase 2: Script Writing (2-3 hours)**
- Write all .tape files
- Test each segment
- Refine timing

**Phase 3: Mock Setup (1 hour)**
- Create mock Claude script
- Test integration
- Handle edge cases

**Phase 4: Generation & Optimization (1 hour)**
- Generate all recordings
- Optimize file sizes
- Quality check

**Total:** 4.5-5.5 hours for complete setup

## Next Steps

1. **Install VHS and dependencies**
2. **Create `vhs-scripts/` directory structure**
3. **Write first test script** (`vhs-scripts/test.tape`)
4. **Generate test recording**
5. **Review and decide on approach** (single vs. segments)
6. **Create mock scripts if needed**
7. **Write all .tape files**
8. **Create generation automation script**
9. **Generate final recordings**
10. **Document usage in README**

## Open Questions to Resolve

1. **Single long video vs. multiple segments?**
   - Recommendation: Both (complete + segments)

2. **GIF vs. MP4 for README?**
   - Recommendation: GIF for quick demo (GitHub displays inline)

3. **How to handle Claude interactive session?**
   - Recommendation: Mock script approach

4. **Should recordings be in Git or Git LFS?**
   - Recommendation: Small GIFs in Git, large files in releases

5. **Need narration/subtitles in VHS?**
   - VHS doesn't support audio
   - Could add text overlays using Type command
   - For voice, would need separate video editing

## Success Metrics

A successful VHS recording setup will:
- ✅ Generate reproducible recordings automatically
- ✅ Take < 5 minutes to regenerate all recordings
- ✅ Produce files < 5MB for GIFs, < 50MB for MP4s
- ✅ Require minimal manual intervention
- ✅ Be maintainable by team members
- ✅ Update easily when package changes

---

**Document Location:** `/Users/samuelgleeson/dev/c2/claude-monorepo-guard-demo-kit/docs/VHS-RECORDING-PLAN.md`
**Created:** 2025-11-21
**Status:** Planning phase - not yet implemented
**Next Action:** Review plan and decide on approach before implementation
