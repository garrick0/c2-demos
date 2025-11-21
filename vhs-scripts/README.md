# VHS Recording Scripts

This directory contains VHS tape scripts for generating automated terminal recordings of the claude-monorepo-guard demo.

## Prerequisites

```bash
# Install VHS
brew install vhs

# Install dependencies
brew install ffmpeg ttyd
```

## Directory Structure

- `segments/` - Individual feature demonstrations
- `shared/` - Common setup scripts
- `themes/` - Custom theme configurations
- `complete-demo.tape` - Full 7-minute demo
- `quick-demo.tape` - 30-second README version

## Usage

### Generate all recordings
```bash
../scripts/generate-recordings.sh
```

### Generate individual recordings
```bash
# From demo kit root
vhs vhs-scripts/quick-demo.tape
vhs vhs-scripts/segments/01-installation.tape
# etc.
```

### Test a script
```bash
vhs vhs-scripts/quick-demo.tape
open recordings/quick-demo.gif
```

## Output Locations

All recordings are saved to the `recordings/` directory:
- Complete demo: `recordings/complete-demo.mp4`
- Quick demo: `recordings/quick-demo.gif`
- Segments: `recordings/segments/*.gif`

## Customization

### Timing
Edit the `Sleep` commands in `.tape` files to adjust pacing.

### Theme
Modify `Set Theme` in each script or create a custom theme in `themes/`.

### Terminal Size
Adjust `Set Width` and `Set Height` for different display requirements.