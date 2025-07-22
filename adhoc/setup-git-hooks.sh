#!/bin/bash
# Git Hooks Setup Script
# Installs modular git hooks and configuration files for various project types
# Usage: ./setup-git-hooks.sh [--auto] [--type=TYPE] [--configs] [--force] [--update]
#
# Examples:
#   ./setup-git-hooks.sh                    # Interactive setup
#   ./setup-git-hooks.sh --auto --configs   # Auto-install hooks + configs
#   ./setup-git-hooks.sh --update           # Update all files to latest versions
#   ./setup-git-hooks.sh --force --configs  # Overwrite existing configs

set -e

# Configuration
DOTFILES_REPO="$HOME/.dotfiles"
ADHOC_DIR="$DOTFILES_REPO/adhoc"
GITHUB_RAW_BASE="https://raw.githubusercontent.com/rickcogley/dotfiles/main/adhoc"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Flags
AUTO_MODE=false
PROJECT_TYPE=""
INSTALL_CONFIGS=false
FORCE_OVERWRITE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --auto)
            AUTO_MODE=true
            shift
            ;;
        --type=*)
            PROJECT_TYPE="${1#*=}"
            shift
            ;;
        --configs)
            INSTALL_CONFIGS=true
            shift
            ;;
        --force)
            FORCE_OVERWRITE=true
            shift
            ;;
        --update|--refresh)
            FORCE_OVERWRITE=true
            AUTO_MODE=true
            INSTALL_CONFIGS=true
            shift
            ;;
        -h|--help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --auto           Non-interactive mode (for cron/scripts)"
            echo "  --type=TYPE      Project type (deno, node, rust, python)"
            echo "  --configs        Install config files (.prettierrc, etc.)"
            echo "  --force          Overwrite existing files without prompting"
            echo "  --update         Update mode: force overwrite all files (same as --auto --configs --force)"
            echo "  --refresh        Alias for --update"
            echo "  -h, --help       Show this help"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Logging functions
log() {
    echo -e "${GREEN}✅${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

error() {
    echo -e "${RED}❌${NC} $1"
    exit 1
}

info() {
    echo -e "${BLUE}ℹ️${NC} $1"
}

header() {
    echo -e "${CYAN}🚀 $1${NC}"
}

# Check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        error "Not in a git repository. Please run this from a git project."
    fi
}

# Detect project type from files
detect_project_type() {
    if [[ -f "deno.json" || -f "deno.jsonc" ]]; then
        echo "deno"
    elif [[ -f "package.json" ]]; then
        echo "node"
    elif [[ -f "Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "pyproject.toml" || -f "setup.py" ]]; then
        echo "python"
    elif [[ -f "go.mod" ]]; then
        echo "go"
    else
        echo "unknown"
    fi
}

# Download file from GitHub or copy from local with conflict handling
get_file() {
    local src_path="$1"
    local dest_path="$2"
    local description="$3"
    local should_install=true

    # Check if destination file already exists
    if [[ -f "$dest_path" ]]; then
        if [[ "$FORCE_OVERWRITE" == true ]]; then
            warn "Overwriting existing $description (--force specified)"
        elif [[ "$AUTO_MODE" == true ]]; then
            warn "Skipping $description - file exists (use --force to overwrite)"
            return 0
        else
            echo
            warn "File already exists: $dest_path"
            echo "Current file size: $(wc -c < "$dest_path" 2>/dev/null || echo "unknown") bytes"
            echo "Last modified: $(date -r "$dest_path" 2>/dev/null || echo "unknown")"
            echo
            echo "Options:"
            echo "  1) Overwrite (replace with new version)"
            echo "  2) Backup and overwrite (save current as .backup)"
            echo "  3) Skip (keep current file)"
            echo "  4) Show diff (compare files)"
            echo
            read -p "Choose (1-4) [3]: " choice

            case $choice in
                1)
                    info "Overwriting existing $description"
                    ;;
                2)
                    cp "$dest_path" "$dest_path.backup"
                    log "Backed up existing file to $dest_path.backup"
                    ;;
                3|"")
                    info "Skipping $description - keeping existing file"
                    return 0
                    ;;
                4)
                    # Show diff if possible
                    if [[ -f "$ADHOC_DIR/$src_path" ]]; then
                        echo "Comparing current file with new version:"
                        diff "$dest_path" "$ADHOC_DIR/$src_path" || true
                    else
                        # Download to temp file for comparison
                        temp_file=$(mktemp)
                        if curl -fsSL "$GITHUB_RAW_BASE/$src_path" -o "$temp_file" 2>/dev/null; then
                            echo "Comparing current file with new version:"
                            diff "$dest_path" "$temp_file" || true
                        else
                            error "Failed to download file for comparison"
                        fi
                        rm -f "$temp_file"
                    fi
                    echo
                    read -p "After seeing diff, overwrite? [y/N]: " overwrite
                    case $overwrite in
                        [Yy]*)
                            info "Overwriting after diff review"
                            ;;
                        *)
                            info "Keeping existing file"
                            return 0
                            ;;
                    esac
                    ;;
                *)
                    error "Invalid choice"
                    ;;
            esac
        fi
    fi

    # Proceed with installation
    if [[ -f "$ADHOC_DIR/$src_path" ]]; then
        # Local dotfiles repo exists
        cp "$ADHOC_DIR/$src_path" "$dest_path"
        log "Installed $description from local dotfiles"
    else
        # Download from GitHub
        if curl -fsSL "$GITHUB_RAW_BASE/$src_path" -o "$dest_path"; then
            log "Downloaded $description from GitHub"
        else
            error "Failed to download $description"
        fi
    fi
}

# Install modular git hooks system
install_git_hook() {
    local project_type="$1"

    mkdir -p .githooks/hooks.d .githooks/lib

    # Copy the orchestrator pre-commit hook
    get_file "git/hooks/pre-commit-orchestrator" ".githooks/pre-commit" "pre-commit orchestrator"

    # Copy shared library
    get_file "git/hooks/lib/common.sh" ".githooks/lib/common.sh" "common functions library"

    # Copy individual hook scripts
    get_file "git/hooks/10-format-code" ".githooks/hooks.d/10-format-code" "code formatting hook"
    get_file "git/hooks/20-lint-markdown" ".githooks/hooks.d/20-lint-markdown" "markdown linting hook"
    get_file "git/hooks/30-run-tests" ".githooks/hooks.d/30-run-tests" "test runner hook"
    get_file "git/hooks/40-security-check" ".githooks/hooks.d/40-security-check" "security check hook"

    # Make everything executable
    chmod +x .githooks/pre-commit
    chmod +x .githooks/hooks.d/10-format-code
    chmod +x .githooks/hooks.d/20-lint-markdown

    # Optional hooks start disabled
    chmod -x .githooks/hooks.d/30-run-tests
    chmod -x .githooks/hooks.d/40-security-check

    # Configure git to use the hooks directory
    git config core.hooksPath .githooks
    log "Installed modular git hooks system for $project_type project"

    # Show what was created
    echo
    info "Created hook structure:"
    echo "  📁 .githooks/"
    echo "  ├── 🎭 pre-commit (orchestrator)"
    echo "  ├── 📁 hooks.d/"
    for hook in .githooks/hooks.d/*; do
        if [ -f "$hook" ]; then
            hook_name=$(basename "$hook")
            if [ -x "$hook" ]; then
                echo "  │   ├── ✅ $hook_name (enabled)"
            else
                echo "  │   ├── ⏸️  $hook_name (disabled)"
            fi
        fi
    done
    echo "  └── 📁 lib/"
    echo "      └── 📚 common.sh (shared functions)"
}

# Install configuration files
install_config_files() {
    # Install .prettierrc
    get_file "configs/.prettierrc" ".prettierrc" "Prettier configuration"

    # Install .markdownlint-cli2.jsonc
    get_file "configs/.markdownlint-cli2.jsonc" ".markdownlint-cli2.jsonc" "markdownlint configuration"

    log "Configuration files installed"
}

# Interactive mode
interactive_setup() {
    header "Project Setup Wizard"
    echo

    # Detect project type
    DETECTED_TYPE=$(detect_project_type)
    if [[ "$DETECTED_TYPE" != "unknown" ]]; then
        info "Detected project type: $DETECTED_TYPE"
        PROJECT_TYPE="$DETECTED_TYPE"
    else
        warn "Could not detect project type"
        echo "Available types:"
        echo "  1) Deno/TypeScript"
        echo "  2) Node.js"
        echo "  3) Rust"
        echo "  4) Python"
        echo "  5) Go"
        echo "  6) Other/Generic"
        echo
        read -p "Choose project type (1-6): " choice

        case $choice in
            1) PROJECT_TYPE="deno" ;;
            2) PROJECT_TYPE="node" ;;
            3) PROJECT_TYPE="rust" ;;
            4) PROJECT_TYPE="python" ;;
            5) PROJECT_TYPE="go" ;;
            6) PROJECT_TYPE="generic" ;;
            *) error "Invalid choice" ;;
        esac
    fi

    echo
    info "Install git hooks? (Modular system with formatting, linting, optional tests)"
    read -p "Install git hooks? [Y/n]: " install_hook
    case $install_hook in
        [Nn]*)
            warn "Skipping git hook installation"
            ;;
        *)
            install_git_hook "$PROJECT_TYPE"
            ;;
    esac

    echo
    info "Install configuration files? (.prettierrc, .markdownlint-cli2.jsonc)"
    echo "  • Provides consistent formatting rules"
    echo "  • Can be customized per project"
    read -p "Install config files? [Y/n]: " install_configs
    case $install_configs in
        [Nn]*)
            warn "Skipping configuration files"
            ;;
        *)
            install_config_files
            ;;
    esac
}

# Auto mode (non-interactive)
auto_setup() {
    if [[ -z "$PROJECT_TYPE" ]]; then
        PROJECT_TYPE=$(detect_project_type)
        [[ "$PROJECT_TYPE" == "unknown" ]] && PROJECT_TYPE="generic"
    fi

    if [[ "$FORCE_OVERWRITE" == true ]]; then
        header "Updating/installing for $PROJECT_TYPE project (force mode)"
    else
        header "Auto-installing for $PROJECT_TYPE project"
        info "Existing files will be skipped (use --force to overwrite)"
    fi

    install_git_hook "$PROJECT_TYPE"

    if [[ "$INSTALL_CONFIGS" == true ]]; then
        install_config_files
    fi
}

# Main execution
main() {
    check_git_repo

    # Check if we have interactive stdin (not piped)
    if [[ "$AUTO_MODE" == true ]] || [[ ! -t 0 ]]; then
        # Auto mode or piped input - run non-interactively
        if [[ ! -t 0 ]] && [[ "$AUTO_MODE" != true ]]; then
            warn "No interactive terminal detected (piped input)"
            info "Running in auto mode - use --auto flag to suppress this warning"
            AUTO_MODE=true
            INSTALL_CONFIGS=true  # Default to installing configs when piped
        fi
        auto_setup
    else
        interactive_setup
    fi

    echo
    header "Setup Complete! 🎉"
    echo
    info "Current status:"
    [[ -f ".githooks/pre-commit" ]] && echo "  ✅ Git hooks system (.githooks/)" || echo "  ❌ Git hooks not installed"
    [[ -d ".githooks/hooks.d" ]] && echo "    ├── $(ls .githooks/hooks.d/ | wc -l | tr -d ' ') individual hooks in hooks.d/"
    [[ -f ".prettierrc" ]] && echo "  ✅ Prettier config (.prettierrc)" || echo "  ➖ Prettier config not installed"
    [[ -f ".markdownlint-cli2.jsonc" ]] && echo "  ✅ Markdownlint config (.markdownlint-cli2.jsonc)" || echo "  ➖ Markdownlint config not installed"

    # Show backup files if any were created
    if ls *.backup 2>/dev/null; then
        echo
        warn "Backup files created:"
        ls -la *.backup 2>/dev/null | sed 's/^/    /'
    fi

    echo
    info "Next steps:"
    echo "  • Test the hooks: make a commit and see formatting in action"
    echo "  • Enable optional hooks: chmod +x .githooks/hooks.d/30-run-tests"
    echo "  • Disable specific hooks: chmod -x .githooks/hooks.d/HOOK_NAME"
    echo "  • Add custom hooks: create executable scripts in .githooks/hooks.d/"
    echo "  • Customize configs: edit .prettierrc and .markdownlint-cli2.jsonc as needed"
    echo "  • Update anytime: re-run this script to get latest versions"
    [[ "$FORCE_OVERWRITE" != true ]] && echo "  • Force updates: use --force flag to overwrite without prompting"
    echo "  • Share with team: commit these files so everyone gets the same setup"
}

# Run main function
main "$@"
