# Rick Cogley's Dotfiles

A comprehensive, modular dotfiles repository using GNU Stow for symlink management, 
designed for macOS development environments with security and maintainability in mind.

## Quick Start

```bash
# Clone the repository
cd $HOME
git clone https://github.com/RickCogley/dotfiles.git .dotfiles
cd .dotfiles

# Apply configurations
stow git zsh vim npm direnv

# Set up your private configuration
cp ~/.gitconfig.local.template ~/.gitconfig.local
$EDITOR ~/.gitconfig.local  # Add your GPG key and other secrets
```

## What's Included

- **Git**: Comprehensive git configuration with secure secret management
- **Zsh**: Modern shell setup with Znap plugin manager and Starship prompt
- **Vim**: Editor configuration and plugins
- **npm**: `~/.npmrc` with no secrets; the GitHub Packages token comes from `NODE_AUTH_TOKEN` (keys)
- **direnv**: `~/.envrc` for everything under `~`; reads tokens from `~/.ssh/tokens` at load time, holds none
- **Security**: GPG signing, SSH key management, and secret handling patterns
- **Documentation**: Complete guides following industry standards

## Key Features

- 🔒 **Security-first design** - Secrets never committed to the repository
- 🧩 **Modular structure** - Apply only the configurations you need
- 📖 **Comprehensive documentation** - Tutorials, guides, and references
- 🔄 **Cross-machine compatibility** - Consistent setup across multiple systems
- 🛡️ **Split configuration** - Public configs in repo, private configs local-only

## Documentation

**📚 [Full Documentation](https://rickcogley.github.io/dotfiles/)**

### Quick Links

- **🎓 [Getting Started Tutorial](docs/tutorials/getting-started.md)** - Step-by-step setup guide
- **🏗️ [Architecture Overview](docs/explanations/architecture.md)** - How it all works
- **🔐 [Security Guide](docs/explanations/security.md)** - Keeping your secrets safe
- **⚙️ [Configuration Reference](docs/reference/)** - Detailed configuration docs

### Browse by Type

- **[Tutorials](docs/tutorials/)** - Learning-oriented guides for beginners
- **[How-to Guides](docs/how-to/)** - Task-oriented solutions for specific problems  
- **[Reference](docs/reference/)** - Technical specifications and configuration details
- **[Explanations](docs/explanations/)** - Conceptual discussions and design decisions

## Why This Approach?

After trying various dotfile management methods, GNU Stow emerged as the ideal solution:
- **Simple and reliable** - Just creates standard symlinks
- **No dependencies** - Works anywhere git and stow are available
- **Transparent** - Easy to understand and debug
- **Flexible** - Apply configurations selectively

For systems without git/stow, rsync provides a reliable fallback option.

## Philosophy

These dotfiles prioritize:
- **Security** over convenience
- **Simplicity** over features  
- **Documentation** over assumptions
- **Modularity** over monolithic configs

## Contributing

This is a personal configuration repository, but the documentation and patterns 
may be useful for others building their own dotfile systems. Feel free to:
- Use any patterns or documentation for your own setup
- Submit issues for documentation improvements
- Share feedback on the architecture approach

## License

This repository is shared under the MIT License. See [LICENSE](LICENSE) for details.

---

**📖 For complete setup instructions and detailed documentation, visit [rickcogley.github.io/dotfiles](https://rickcogley.github.io/dotfiles/)**