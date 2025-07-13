import type { NagareConfig } from "jsr:@rick/nagare";

export default {
  project: {
    name: "Rick Cogley's Dotfiles",
    description: "A comprehensive, modular dotfiles repository using GNU Stow",
    repository: "https://github.com/RickCogley/dotfiles",
    homepage: "https://rickcogley.github.io/dotfiles/"
  },

  // Semantic versioning with conventional commits
  release: {
    // Dotfiles typically use minor releases for new features/configs
    // and patch releases for fixes and updates
    defaultBumpType: "patch",
    
    // Custom commit type mappings for dotfiles
    commitTypes: {
      "feat": "minor",     // New configurations or tools
      "config": "minor",   // Configuration changes  
      "docs": "patch",     // Documentation updates
      "fix": "patch",      // Bug fixes in configs
      "chore": "patch",    // Maintenance tasks
      "update": "patch",   // Dependency/tool updates
      "security": "patch", // Security-related changes
      "refactor": "patch", // Restructuring without new features
      "style": "patch"     // Formatting/style changes
    }
  },

  // Update version references in key files
  updateFiles: [
    {
      path: "./deno.json", 
      patterns: {
        // Safe line-anchored pattern for JSON version
        version: /^(\s*)"version":\s*"([^"]+)"/m
      }
    },
    {
      path: "./README.md",
      patterns: {
        // Update any version badges or references
        version: /(\bv?)(\d+\.\d+\.\d+)/g
      }
    }
  ],

  // Generate changelog for dotfiles releases
  changelog: {
    enabled: true,
    path: "./CHANGELOG.md",
    
    // Custom section names for dotfiles
    sections: {
      "feat": "✨ New Configurations",
      "config": "⚙️ Configuration Changes", 
      "fix": "🐛 Fixes",
      "docs": "📚 Documentation",
      "chore": "🔧 Maintenance",
      "update": "⬆️ Updates",
      "security": "🔒 Security",
      "refactor": "♻️ Refactoring",
      "style": "🎨 Style Changes"
    }
  },

  // GitHub releases for dotfiles
  github: {
    enabled: true,
    generateReleaseNotes: true,
    
    // Custom release notes template for dotfiles
    releaseNotesTemplate: `
## What's Changed in v{{ version }}

{{ releaseNotes }}

## Installation

\`\`\`bash
# Clone or update to this version
git clone -b v{{ version }} https://github.com/RickCogley/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Apply configurations using Stow
stow git zsh vim  # or any modules you want
\`\`\`

## Documentation

📚 **[Complete Documentation](https://rickcogley.github.io/dotfiles/)**

**Full Changelog**: https://github.com/RickCogley/dotfiles/compare/{{ previousVersion }}...v{{ version }}
    `.trim()
  },

  // Optional: Add hooks for any dotfiles-specific tasks
  hooks: {
    preRelease: [
      // Could add validation hooks if needed
    ],
    postRelease: [
      // Could trigger documentation rebuilds, etc.
    ]
  }
} as NagareConfig;