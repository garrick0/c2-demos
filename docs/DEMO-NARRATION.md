# Claude Monorepo Guard - Demo Video Script

**Duration:** ~7 minutes
**Style:** Clear, professional, developer-focused

---

## Scene 1: Introduction (30 seconds)

**Visual:** Terminal with clean prompt, VS Code in background showing monorepo structure

**Narration:**
"If you've ever used Claude Code in a monorepo, you know the pain. It processes too many files, gets confused about context, and can make changes across unrelated projects. Today, I'll show you claude-monorepo-guard - a simple tool that solves these problems in under a minute."

**Actions:**
- Show terminal
- `ls -la` to show monorepo structure

---

## Scene 2: The Problem (45 seconds)

**Visual:** Navigate through monorepo, show multiple projects

**Narration:**
"Here's a typical monorepo with multiple apps and packages. When you run Claude Code from the root, it tries to index everything - wasting tokens and causing confusion. Even worse, it might make changes to protected branches or spread fixes across unrelated projects."

**Actions:**
```bash
tree -L 2 apps packages
cat pnpm-workspace.yaml
```

**Emphasize:**
- Multiple projects = context confusion
- Root directory = too much scope
- Main branch = risky changes

---

## Scene 3: Installation (45 seconds)

**Visual:** Install the package

**Narration:**
"Let's fix this. First, we install claude-monorepo-guard globally. It's a lightweight tool that works with any monorepo type - Nx, Turborepo, Lerna, pnpm workspaces - it auto-detects them all."

**Actions:**
```bash
# Install globally
npm install -g claude-monorepo-guard

# Verify installation
claude-monorepo-guard --version

# Check current status
claude-monorepo-guard status
```

**Note:** Point out "Not initialized" warning

---

## Scene 4: Configuration (1 minute)

**Visual:** Run init command, answer prompts

**Narration:**
"Now let's initialize. The tool asks a few simple questions. I'll say YES to blocking the root - this prevents the context confusion. The setup creates two files: a configuration file and a Claude hook."

**Actions:**
```bash
# Initialize
claude-monorepo-guard init

# Show it detected pnpm workspace automatically
# Answer: YES to block root
# Answer: NO to warn on top-level
# Press Enter for default message
```

**Show created files:**
```bash
cat .claudemonorepo
cat .claude/settings.json
```

**Emphasize:**
- Auto-detection worked
- Configuration is shareable via Git
- Hook integrates seamlessly

---

## Scene 5: Branch Protection Demo (1 minute)

**Visual:** Try to use Claude on main branch

**Narration:**
"Here's the first protection - branch safety. We're on the main branch. Watch what happens when I try to run Claude Code."

**Actions:**
```bash
# Show current branch
git branch --show-current

# Try Claude Code
claude
```

**Show the block message**

**Narration:**
"Perfect! It blocks me from working directly on main and tells me exactly how to create a feature branch. Let me switch branches."

```bash
git checkout -b feature/demo
```

---

## Scene 6: Root Protection Demo (1.5 minutes)

**Visual:** Try Claude from root, then navigate to project

**Narration:**
"Now we're on a feature branch, but we're still in the monorepo root. Let's try Claude Code again."

**Actions:**
```bash
# Confirm location
pwd

# Try Claude Code
claude
```

**Show the block message with project list**

**Narration:**
"Excellent! It blocks the root but shows me exactly where I can work. Let's navigate to the web app."

```bash
# Navigate to project
cd apps/web

# Now it works!
claude
```

**Narration:**
"And there we go - Claude Code launches perfectly when we're in a specific project. No more context confusion, no more wasted tokens."

---

## Scene 7: Additional Features (1 minute)

**Visual:** Show list command and uncommitted changes warning

**Narration:**
"The tool includes other helpful features. You can list all projects anytime, and it warns you about uncommitted changes."

**Actions:**
```bash
# Go back to root
cd ../..

# List projects
claude-monorepo-guard list

# Create uncommitted change
echo "test" > test.txt

# See warning (on feature branch, in a project)
cd apps/web
claude  # Shows warning but continues
```

---

## Scene 8: Team Benefits (45 seconds)

**Visual:** Show .claudemonorepo in Git

**Narration:**
"The best part? Your entire team gets the same protection. The configuration lives in your Git repository, so when teammates pull your changes, they automatically get the same guardrails. No more 'it works on my machine' problems."

**Actions:**
```bash
# Show it's tracked in Git
git add .claudemonorepo .claude/settings.json
git status
```

---

## Scene 9: Summary (30 seconds)

**Visual:** Show status command with all protections active

**Narration:**
"That's claude-monorepo-guard. In under a minute, we've added protection from monorepo confusion, branch accidents, and token waste. It's open source, works with any monorepo, and requires zero configuration changes to your projects."

**Actions:**
```bash
claude-monorepo-guard status
```

**Final message on screen:**
```
✅ Auto-detects monorepos
✅ Protects branches
✅ Prevents root confusion
✅ Saves tokens
✅ Team shareable
✅ Zero config

npm install -g claude-monorepo-guard

github.com/garrick0/claude-guard
```

---

## Recording Tips

1. **Terminal Setup:**
   - Clear terminal before starting: `clear`
   - Use a clean prompt: `export PS1="$ "`
   - Increase font size to 16-18pt
   - Use a high contrast theme

2. **Pacing:**
   - Pause 1-2 seconds after each command
   - Let output display fully before continuing
   - Speak clearly, not too fast

3. **Emphasis:**
   - Use mouse to highlight important output
   - Pause on error/success messages
   - Let block messages display for 3-4 seconds

4. **Editing:**
   - Record in segments if needed
   - Can speed up installation parts
   - Add text overlays for key points
   - Include background music (optional)

## Alternative Versions

### Short Version (2 minutes)
- Skip the problem explanation
- Jump straight to install and init
- Show just root protection
- End with status command

### Long Version (10 minutes)
- Include custom configuration options
- Show CI/CD trigger adapters
- Demonstrate uninstall/reinstall
- Show multiple monorepo types

## Call to Action

End screen should include:
- GitHub repository link
- npm package link
- Star the repo CTA
- Link to documentation