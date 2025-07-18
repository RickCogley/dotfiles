---
allowed-tools: Read
description: Show OWASP Top 10 security checklist
---

# OWASP Top 10 Security Checklist

Loading the OWASP Top 10 verification checklist from global memory...

@~/.claude/CLAUDE.md

## Quick Reference - OWASP Top 10

### A01 - Broken Access Control
- ✓ Validate all authorization checks
- ✓ Implement principle of least privilege
- ✓ Check for direct object references

### A02 - Cryptographic Failures  
- ✓ Use strong encryption (AES-GCM-256, PBKDF2-SHA512)
- ✓ Manage secrets via environment variables
- ✓ Validate SSL/TLS implementations

### A03 - Injection
- ✓ Use parameterized queries
- ✓ Validate and sanitize ALL inputs
- ✓ Implement proper output encoding

### A04 - Insecure Design
- ✓ Review architecture for security flaws
- ✓ Implement secure design patterns
- ✓ Consider threat modeling

### A05 - Security Misconfiguration
- ✓ Check default configurations
- ✓ Ensure proper error handling
- ✓ Use secure defaults

### A06 - Vulnerable Components
- ✓ Audit dependencies
- ✓ Keep libraries updated
- ✓ Pin dependency versions

### A07 - Authentication Failures
- ✓ Implement proper authentication
- ✓ Use strong mechanisms
- ✓ Implement rate limiting

### A08 - Software/Data Integrity Failures
- ✓ Validate data integrity
- ✓ Use secure update mechanisms
- ✓ Verify checksums/signatures

### A09 - Logging/Monitoring Failures
- ✓ Log security events
- ✓ Monitor for unauthorized changes
- ✓ Never log sensitive data

### A10 - Server-Side Request Forgery (SSRF)
- ✓ Validate external requests
- ✓ Implement URL validation
- ✓ Use allowlists for resources

$ARGUMENTS