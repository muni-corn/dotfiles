# Musicaloft development agent guidelines

## Tools

- Always use context7 for up-to-date library documentation and examples.
- Use exa web search for comprehensive research

## Project structure

- **Modularity:** Small, focused modules with single responsibilities
- **Layering:** Separate presentation, business logic, and data access
- **Consistency:** Follow existing codebase patterns
- **File organization:** One primary export per file, colocate related code, max
  3-4 directory levels
- **File size:** Keep under 500 lines

## Naming conventions

- Variables/functions: descriptive names indicating purpose
- Types/classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Files: Follow project convention, or:
  - Rust: `snake_case.rs`
  - JavaScript, TypeScript, Markdown: `kebab-case.ts`

## Code structure

Order: imports → constants → types → implementation (public methods first,
private after)

```rust
use std::collections::HashMap;
use crate::error::AppError;

const DEFAULT_TIMEOUT: Duration = Duration::from_secs(5);

pub struct User {
  pub id: Uuid,
  pub name: String
}

impl UserService {
    pub async fn create_user(&self, user: NewUser) -> Result<User, AppError> {
      // ...
    }

    fn validate_input(&self, data: &NewUser) -> bool {
      // ...
    }
}
```

## Comments and documentation

- Delegate to `@doc` agent for documentation
- NEVER generate Markdown files unprompted

### Comment style

- **Inline comments:** all lowercase, explain _why_ not _what_
- **Doc comments:** MUST use sentence case (capitalize first word, end with
  period). Document public APIs with params, returns, examples
- **TODOs:** include issue numbers, be specific
- Spell out "and" (never use "&")
- Use sentence case for headings

**CRITICAL:** All doc comments must start with a capital letter and be written
in sentence case. This is non-negotiable.

```typescript
// convert ounces to grams for consistent units (good: explains why)
const grams = oz * GRAMS_PER_OUNCE;
```

````rust
/// Calculates total price with tax.
///
/// # Example
/// ```
/// let total = calculate_total_with_tax(1000, 0.08);
/// ```
pub fn calculate_total_with_tax(amount: u64, tax_rate: f64) -> u64 { /* ... */ }
````

Keep comments current with code changes.

## Git commits

IF AND ONLY IF you are prompted to create Git commits to the codebase, you MUST
follow the following guidelines.

ALWAYS delegate to the `commit` agent for commits.

If you are tasked with adding changes to the Git index yourself, **DO NOT**
batch multiple unrelated changes into one commit. If there are 5 changes, make 5
commits.

**NEVER** AMEND COMMITS.

If a pre-commit hook fails, the commit will be rejected and must be retried
after issues are fixed.

Formatter hooks (like `treefmt`) may format files and then reject the commit if
changes were made. If this happens, re-add the formatted portions of the changed
files, and then attempt the commit again.

### Commit format

```
type(scope)!: description under 72 characters

[optional body: explain what and why]

[optional footer: BREAKING CHANGE, issue refs]
```

### Commit types

| Type       | Use for                                  |
| ---------- | ---------------------------------------- |
| `build`    | Build process changes                    |
| `chore`    | Non-code changes (dependencies)          |
| `ci`       | CI/CD changes                            |
| `docs`     | Documentation/comments only              |
| `dx`       | Developer experience (tooling, config)   |
| `feat`     | New user-facing features (MINOR version) |
| `fix`      | Bug fixes (PATCH version)                |
| `perf`     | Performance improvements                 |
| `refactor` | Code changes without feature/fix         |
| `style`    | Formatting only (not CSS)                |
| `test`     | Test changes                             |

### Scope rules

- Single word, no file extensions
- One file: use filename (e.g., `Menu` for `src/ui/Menu.tsx`)
- Multiple files: use common ancestor directory
- Omit if common ancestor is `src` or top-level
- Warn if staged files are unrelated

### Breaking changes

Add `!` after scope and `BREAKING CHANGE:` footer. Ask user for confirmation
first.

### Examples

```
build: enable `mold` linker for faster build times
```

```
feat(animal): add ability to pet animals

Now our animals can receive love!
```

```
refactor!: remove deprecated functions for v1.0 release

BREAKING CHANGE: Removes previously deprecated functions.
```

### Commit guidelines

- Atomic: one logical change per commit
- Small: prefer 10 small commits over 1 large
- Testable: leave codebase in working state
- Never add co-author footers

## Testing

Only encourage test suites if none exist. Never build one unprompted.

### Philosophy

- Test behavior, not implementation
- Prefer TDD when appropriate
- Keep tests fast, reliable, deterministic
- Test edge cases and error paths
- Follow AAA pattern (Arrange, Act, Assert)

### Coverage targets

- 85%+ for critical paths
- 100% for utilities and pure functions
- Include integration and E2E for critical flows

### Mocking (vitest)

Cannot mock functions within the module being tested. Only mock external
dependencies.

## Error handling

### Principles

- Be explicit, provide context
- Fail fast, degrade gracefully
- Log appropriately

### Error messages

- Lowercase, friendly language
- Clear and concise ("user wasn't found" not "an error occurred")
- Include context ("couldn't connect to 'users_db' at localhost:5432")
- Suggest solutions ("does the file exist and have read permissions?")

### Patterns

- TypeScript: Use `neverthrow` for Result types, custom `AppError` classes,
  `zod` for validation
- Rust: Use `thiserror` for error types, `anyhow` for application errors,
  `validator` crate

## Security

- Never commit secrets (use env vars or secret management)
- Validate and sanitize all inputs
- Use parameterized queries
- Pin versions, use lock files

## Performance

Never implement premature optimizations unless specified.

## Dependencies

Never edit dependency lists manually. Use:

```bash
# TypeScript
npm install [--save-dev] package-name
# or: bun add, pnpm add, yarn add

# Rust
cargo add [--dev|--build] crate-name
```

Selection criteria:

- Actively maintained
- Popular
- Well-documented
- Lightweight
- Secure

## Language-specific notes

### Rust

Use the modern module file structure: a module named `foo` should be declared in
`foo.rs` alongside its submodule directory `foo/`

```
src/
  main.rs
  foo.rs        ← module declaration and top-level items
  foo/
    bar.rs      ← submodule
    baz.rs      ← submodule
```

### TypeScript

- Never use `any`; use proper types or `unknown`
- Use `async`/`await` over callbacks

## Nix development environments

When working in a repository that contains a `flake.nix`, use `nix develop` to
run commands within the development environment:

```bash
nix develop --command <command> <args>
```

If the flake uses `devenv` (i.e., `devenv.nix` or `devenv.yaml` is present, or
`devenv` appears as a flake input), add `--no-pure-eval`:

```bash
nix develop --no-pure-eval --command <command> <args>
```

This ensures commands run with the correct tools, environment variables, and
shell hooks defined by the flake. You can also use this to test changes made to
the flake's development environment itself.

## When in doubt

1. Follow existing codebase patterns
2. Ask for clarification
3. Prioritize clarity over cleverness
4. Write tests
5. Document complex logic
