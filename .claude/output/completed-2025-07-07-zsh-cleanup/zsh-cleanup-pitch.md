# Pitch: Zsh Configuration Cleanup

## Problem

Your current zsh setup uses z4h (Zsh for Humans) which appears to be no longer actively maintained. This creates risk for future compatibility and missing out on improvements in the zsh ecosystem. The current configuration is also quite heavy with many custom functions mixed into a single large .zshrc file.

## Appetite

Small batch - 1-2 hours of focused work to migrate and test.

## Solution

We're proposing two shaped solutions:

### Option 1: Migrate to zsh-snap (Recommended)
- **Why**: Actively maintained, very lightweight, fast startup times
- **Key benefit**: Easy migration path from z4h with similar features
- **Approach**: Install zsh-snap, migrate plugins, preserve your custom functions

### Option 2: Minimal Standard Zsh
- **Why**: No dependencies, maximum control, never goes out of maintenance
- **Key benefit**: Bulletproof simplicity
- **Approach**: Hand-rolled config with git submodules for any plugins

Both options will:
- Preserve all your custom functions (hugo deploys, aliases, etc.)
- Maintain your current workflow
- Improve startup performance
- Be well-documented for future maintenance

## Rabbit Holes

**Not doing**:
- Rewriting your custom functions (they work fine)
- Changing your prompt theme (can keep Powerlevel10k if desired)
- Modifying your PATH setup
- Touching your git/GPG configurations

## No-gos

- Breaking existing workflows
- Losing any current functionality
- Complex migration requiring multiple sessions

## Nice-to-haves

If time permits:
- Organize functions into separate files by category
- Add comments to complex functions
- Create a simple update mechanism