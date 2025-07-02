# Global Claude Code Configuration

This file provides universal guidance for Claude Code across all repositories and projects.

## Security & Compliance Standards (Universal)

### OWASP Top 10 Verification Required

**CRITICAL**: Before suggesting or implementing ANY code changes, verify against current OWASP Top 10:

#### A01 - Broken Access Control
- Validate all authorization checks in applications, APIs, and CLI tools
- Implement principle of least privilege for all system access
- Check for direct object references and ensure proper access controls
- Validate file system permissions and API endpoint access

#### A02 - Cryptographic Failures
- Use strong, up-to-date encryption algorithms (AES-GCM-256, PBKDF2-SHA512)
- Properly manage secrets, API keys, and credentials via environment variables
- Validate SSL/TLS implementations for all external communications
- Never hardcode cryptographic keys or sensitive data

#### A03 - Injection
- Use parameterized queries/operations for all database and system interactions
- Validate and sanitize ALL user inputs (CLI args, API requests, config files)
- Implement proper output encoding for template processing and responses
- Avoid dynamic code execution (eval, Function constructor)

#### A04 - Insecure Design
- Review architecture for security flaws before implementation
- Implement secure design patterns (fail-fast, defense in depth)
- Consider threat modeling implications for all new features
- Design with security as a primary concern, not an afterthought

#### A05 - Security Misconfiguration
- Check default configurations for security implications
- Ensure proper error handling (no sensitive data exposure in logs/responses)
- Validate security headers and settings for web applications
- Use secure defaults in all configuration options

#### A06 - Vulnerable Components
- Audit all dependencies for known vulnerabilities
- Keep libraries and frameworks updated (use dependabot, security advisories)
- Document component security status in dependency updates
- Pin dependency versions and review before updates

#### A07 - Authentication Failures
- Implement proper authentication handling for APIs and services
- Use strong authentication mechanisms (tokens, certificates)
- Protect against unauthorized operations with proper session management
- Implement rate limiting to prevent brute force attacks

#### A08 - Software/Data Integrity Failures
- Validate data integrity in all processing operations
- Use secure update mechanisms for file modifications
- Implement proper CI/CD security for deployment pipelines
- Verify checksums and signatures where applicable

#### A09 - Logging/Monitoring Failures
- Log security-relevant events in all operations
- Implement proper monitoring for unauthorized changes
- Ensure logs NEVER contain sensitive data (tokens, passwords, keys)
- Create audit trails for critical operations

#### A10 - Server-Side Request Forgery (SSRF)
- Validate ALL external requests and API calls
- Implement proper URL validation and allowlists
- Use allowlists for external resources and dependencies
- Sanitize user-provided URLs and external references

### ISO 27001 Compliance Notes
- Document all security decisions in commit messages
- Maintain audit trail for all critical operations
- Ensure security reviews for all modifications involving sensitive data
- Flag any potential compliance issues immediately

### Security Review Process
When reviewing or suggesting code changes:

1. **Security First**: Always perform OWASP Top 10 assessment before any other suggestions
2. **Flag Issues**: Explicitly call out any potential OWASP violations
3. **Suggest Mitigations**: Provide specific remediation steps for identified risks
4. **Document Decisions**: Include security rationale in comments and commit messages
5. **Compliance Check**: Note any ISO 27001 implications

### Required Security Checks
For every code change, verify:
- Input validation and sanitization (especially user-provided data)
- Authentication and authorization (API access, file permissions)
- Secure data handling (encryption, secure storage)
- Error handling (no information disclosure)
- Dependency security status (vulnerability scanning)
- Logging of security events (without sensitive data exposure)

## Programming Paradigm Standards

### Preferred Approach: Pragmatic Hybrid Programming

Based on language capabilities and project requirements:

#### TypeScript/JavaScript Projects
- **Object-Oriented Design** for structure and state management:
  - Classes for complex stateful components (Logger, Manager classes)
  - Encapsulation for sensitive data and operations
  - Singleton pattern for global services (telemetry, configuration)
  - Static utility classes for common operations
- **Functional Programming** for critical operations:
  - Pure functions for cryptographic operations
  - Immutable data structures using `as const` and `readonly`
  - Higher-order functions for composition and reusability
  - No side effects in security-critical functions

#### Other Languages
- **Go**: Struct-based design with functional interfaces, pure functions for business logic
- **Python**: Class-based architecture with functional utilities, dataclasses for immutability
- **Rust**: Struct/enum design with functional patterns, ownership for memory safety
- **Java**: Object-oriented with functional interfaces (streams, lambdas)
- **C#**: Object-oriented with LINQ functional patterns

#### HTML/CSS
- **Declarative Approach**: Use idiomatic, semantic HTML5 and modern CSS
- **Accessibility First**: ARIA attributes, semantic elements, proper heading hierarchy
- **Modern CSS**: Grid, Flexbox, custom properties, logical properties
- **Progressive Enhancement**: Core functionality works without JavaScript

### Code Organization Principles
1. **Separation of Concerns**: Clear boundaries between modules/classes
2. **Single Responsibility**: Each class/function has one primary purpose
3. **Dependency Injection**: Pass dependencies rather than creating them internally
4. **Fail-Fast Validation**: Early validation with descriptive errors
5. **Type Safety**: Leverage type systems for compile-time error prevention

## Language-Specific Preflight Checks

### Before ANY Commit - Run Preflight Validation

#### Deno Projects
```bash
deno fmt                    # Format code
deno check **/*.ts         # Type check all TypeScript files
deno lint                  # Run linter
deno test                  # Run all tests
```

#### Node.js/npm Projects
```bash
npm run format            # Format code (prettier, etc.)
npm run lint              # ESLint/TSLint
npm run type-check        # TypeScript compilation check
npm test                  # Run test suite
npm audit                 # Security vulnerability check
```

#### Python Projects
```bash
black .                   # Code formatting
mypy .                    # Type checking
flake8                    # Linting
pytest                    # Run tests
safety check              # Security vulnerability scanning
```

#### Go Projects
```bash
go fmt ./...              # Format code
go vet ./...              # Static analysis
golint ./...              # Style linting (if available)
go test ./...             # Run tests
govulncheck ./...         # Security vulnerability check
```

#### Rust Projects
```bash
cargo fmt                 # Format code
cargo clippy              # Linting
cargo test                # Run tests
cargo audit               # Security vulnerability check
```

#### Java Projects
```bash
./gradlew spotlessApply   # Format code (or equivalent)
./gradlew checkstyleMain  # Style checking
./gradlew test            # Run tests
./gradlew dependencyCheckAnalyze  # Security scanning
```

#### C# Projects
```bash
dotnet format             # Format code
dotnet build              # Compile and check
dotnet test               # Run tests
```

## Commit Message Standards

### Conventional Commits with Security Annotations

Use conventional commits format with InfoSec comments when changes have security implications:

**Format**: "InfoSec: [brief description of security impact/consideration]"

#### Examples:

**Security-Relevant Changes** (require InfoSec comment):
```
feat: add input validation to API endpoints

InfoSec: Prevents injection attacks and validates request size limits
```

```
fix: update authentication token handling

InfoSec: Improves credential security and reduces token exposure risk
```

```
chore: update dependencies to latest versions

InfoSec: Patches known security vulnerabilities in lodash and express
```

**Non-Security Changes** (no InfoSec comment needed):
```
docs: update README installation steps
```

```
refactor: simplify logging utility functions

InfoSec: No security impact - code organization only
```

### When to Include InfoSec Comments:
- Input validation or sanitization changes
- Authentication/authorization modifications
- Cryptographic operations or key handling
- Error handling that might affect information disclosure
- Dependency updates (especially security patches)
- Rate limiting or DoS protection
- Security headers or CORS policy changes
- Logging changes that might affect audit trails

## Development Workflow Standards

### Critical Development Notes

1. **Security Testing**: When adding features, create corresponding security tests alongside functional tests
2. **Input Validation**: Always validate inputs at system boundaries with proper error handling
3. **Error Handling**: Provide actionable error messages without exposing sensitive information
4. **State Management**: Validate system state early and log security-relevant events
5. **Pre-flight Checks**: ALWAYS run language-appropriate preflight checks before staging commits
6. **Attribution**: Never add "Generated with Claude Code" or "Co-Authored-By: Claude" to commit messages or PRs
7. **Documentation Updates**: Update documentation when functionality is added or security posture changes
8. **Merge Hygiene**: Ensure both branches are pulled and up-to-date before merging
9. **Security Documentation**: Document all security-related decisions and rationale for compliance
10. **Dependency Management**: Regular security audits of dependencies and prompt updates for vulnerabilities

### Code Style Requirements (Adaptable per Language)

#### TypeScript/JavaScript
- **Formatting**: 2 spaces, double quotes, semicolons required, 100 char line width
- **Naming**: kebab-case files, PascalCase classes, camelCase variables/functions
- **TypeScript**: Strict mode enabled, no implicit any, comprehensive interfaces

#### Python
- **Formatting**: Black formatting, 88 char line width
- **Naming**: snake_case for variables/functions, PascalCase for classes
- **Type Hints**: Use type hints for all public functions and class methods

#### Go
- **Formatting**: gofmt standard formatting
- **Naming**: Go conventions (camelCase private, PascalCase public)
- **Documentation**: Godoc comments for all exported functions

#### General Principles
- **Comments**: Avoid unless necessary for complex business logic or security considerations
- **Consistency**: Follow language-specific idioms and conventions
- **Readability**: Code should be self-documenting through clear naming

## Repository-Specific Overrides

This global configuration provides defaults that can be overridden by local `CLAUDE.md` files in individual repositories. Local configurations take precedence for:
- Project-specific architecture patterns
- Custom build/test commands
- Domain-specific security requirements
- Framework-specific coding standards

However, OWASP Top 10 verification and InfoSec commit standards should be maintained across all projects for security compliance.

## Project Setup Best Practices

### Git Hooks for Code Quality

**Always set up pre-commit hooks** in projects with formatting/linting requirements to prevent CI failures:

1. Create `.githooks/pre-commit` file:
```bash
#!/bin/sh
# Pre-commit hook to ensure code quality before committing

echo "🎨 Running pre-commit checks..."

# For Deno projects
if [ -f "deno.json" ] || [ -f "deno.jsonc" ]; then
  echo "Running deno fmt..."
  deno fmt
  git add -u
fi

# For Node.js projects
if [ -f "package.json" ]; then
  if [ -f "package-lock.json" ]; then
    echo "Running npm run format (if available)..."
    npm run format --if-present && git add -u
  elif [ -f "yarn.lock" ]; then
    echo "Running yarn format (if available)..."
    yarn format --if-present && git add -u
  fi
fi

# For Python projects
if [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
  echo "Running black formatter..."
  black . && git add -u
fi

# For Rust projects
if [ -f "Cargo.toml" ]; then
  echo "Running cargo fmt..."
  cargo fmt && git add -u
fi

echo "✅ Pre-commit checks complete"
```

2. Make it executable:
```bash
chmod +x .githooks/pre-commit
```

3. Configure git to use the hooks:
```bash
git config core.hooksPath .githooks
```

4. Add setup instructions to project documentation (README.md or CLAUDE.md):
```markdown
## Initial Setup

Enable git hooks for automatic code formatting:
\`\`\`bash
git config core.hooksPath .githooks
\`\`\`
```

This approach:
- Prevents formatting-related CI failures
- Ensures consistent code style
- Reduces review friction
- Saves developer time

## CI/CD Best Practices

### Release Verification
1. **Multi-Stage Verification**: A release is only considered successful when:
   - All tests pass locally
   - CI/CD workflows succeed (GitHub Actions, GitLab CI, etc.)
   - Package is published to registry (npm, JSR, PyPI, etc.)
   - Always verify the final publication before considering a release complete

2. **Automated Release Flags**: When tools support it, use non-interactive flags:
   - `--yes`, `-y`, `--skip-confirmation` for automated workflows
   - Document these flags in project-specific CLAUDE.md files
   - Essential for CI/CD pipelines and automated releases

### TypeScript/JavaScript Specific Guidelines
1. **Type Safety Enforcement**: NEVER use `any` type in TypeScript projects
   - Modern projects enforce `no-explicit-any` lint rules
   - Always import and use proper types: `import { EnumType, InterfaceType } from "./types"`
   - Use proper type assertions: `value as SpecificType` not `value as any`
   - This prevents CI failures and ensures type safety

2. **Test Environment Considerations**: Some tests may need different behavior in CI:
   ```typescript
   // Skip tests that require specific environment setup
   Deno.test({
     ignore: Deno.env.get("CI") === "true",
     name: "Test requiring local filesystem"
   }, async (t) => { /* test code */ });
   ```
   - Common for tests requiring: git repositories, filesystem operations, network access
   - Document these patterns in test files

### Security Alert Management
1. **False Positive Suppressions**: When security scanners flag false positives:
   - Add appropriate suppression comments with justification
   - Common tools: DevSkim, CodeQL, Semgrep, SonarQube
   - Format: `// DevSkim: ignore DS123456 - This is test data, not a real secret`
   - Document why the suppression is justified

2. **Common False Positives**:
   - Test data that looks like secrets (SHA hashes, example tokens)
   - Intentional security test patterns (ReDoS tests, injection tests)
   - Example configurations with standard URLs (HTTPS examples)
   - Template patterns that need flexible matching (missing anchors by design)