#!/bin/sh
# Common functions for git hooks

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "    ${BLUE}ℹ️${NC} $1"
}

log_success() {
    echo -e "    ${GREEN}✅${NC} $1"
}

log_warn() {
    echo -e "    ${YELLOW}⚠️${NC} $1"
}

log_error() {
    echo -e "    ${RED}❌${NC} $1"
}

# Check if files were modified by git
files_modified() {
    local pattern="$1"
    if [ -n "$(git diff --name-only $pattern 2>/dev/null)" ]; then
        return 0  # Files were modified
    else
        return 1  # No files modified
    fi
}

# Stage modified files
stage_changes() {
    if files_modified; then
        git add -u
        log_success "Changes staged"
        return 0
    else
        log_info "No files were modified"
        return 1
    fi
}

# Detect project type
detect_project_type() {
    if [ -f "deno.json" ] || [ -f "deno.jsonc" ]; then
        echo "deno"
    elif [ -f "package.json" ]; then
        echo "node"
    elif [ -f "Cargo.toml" ]; then
        echo "rust"
    elif [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
        echo "python"
    elif [ -f "go.mod" ]; then
        echo "go"
    else
        echo "unknown"
    fi
}
