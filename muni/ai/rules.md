# Musicaloft development guidelines

## context7

Always use context7 for up-to-date library documentation and examples.

## Project structure

- **Modularity:** Small, focused modules with single responsibilities
- **Layering:** Separate presentation, business logic, and data access
- **Consistency:** Follow existing codebase patterns
- **File organization:** One primary export per file, colocate related code, max 3-4 directory levels
- **File size:** Keep under 500 lines

## Naming conventions

- Variables/functions: descriptive names indicating purpose
- Types/classes: `PascalCase`
- Constants: `UPPER_SNAKE_CASE`
- Files: Follow project convention, or `snake_case.rs` (Rust), `kebab-case.ts` (TypeScript)

## Code structure

Order: imports → constants → types → implementation (public methods first, private after)

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

- Delegate to `doc` agent for documentation
- NEVER generate Markdown files unprompted

### Comment style

- **Inline comments:** all lowercase, explain *why* not *what*
- **Doc comments:** sentence case, document public APIs with params, returns, examples
- **TODOs:** include issue numbers, be specific
- Spell out "and" (never use "&")
- Use sentence case for headings

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

Delegate to `commit` agent for commits. Commit regularly.

### Commit format

```
type(scope)!: description under 72 characters

[optional body: explain what and why]

[optional footer: BREAKING CHANGE, issue refs]
```

### Commit types

| Type | Use for |
|------|---------|
| `build` | Build process changes |
| `chore` | Non-code changes (dependencies) |
| `ci` | CI/CD changes |
| `docs` | Documentation/comments only |
| `dx` | Developer experience (tooling, config) |
| `feat` | New user-facing features (MINOR version) |
| `fix` | Bug fixes (PATCH version) |
| `perf` | Performance improvements |
| `refactor` | Code changes without feature/fix |
| `style` | Formatting only (not CSS) |
| `test` | Test changes |

### Scope rules

- Single word, no file extensions
- One file: use filename (e.g., `Menu` for `src/ui/Menu.tsx`)
- Multiple files: use common ancestor directory
- Omit if common ancestor is `src` or top-level
- Warn if staged files are unrelated

### Breaking changes

Add `!` after scope and `BREAKING CHANGE:` footer. Ask user for confirmation first.

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

Cannot mock functions within the module being tested. Only mock external dependencies.

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

- TypeScript: Use `neverthrow` for Result types, custom `AppError` classes, `zod` for validation
- Rust: Use `thiserror` for error types, `anyhow` for application errors, `validator` crate

## Security

- Never commit secrets (use env vars or secret management)
- Validate and sanitize all inputs
- Use parameterized queries
- Implement rate limiting
- Use `argon2`/`bcrypt` for passwords
- Audit dependencies regularly (`npm audit`, `cargo audit`)
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

Selection criteria: actively maintained, popular, well-documented, lightweight, secure.

## Language-specific notes

### Rust

- Choose appropriate ownership: `String` (takes ownership), `&str` (borrows), `&mut String` (mutable borrow)
- Prefer borrowing over ownership transfer when possible

### TypeScript

- Never use `any`; use proper types or `unknown`
- Use `async`/`await` over callbacks

## When in doubt

1. Follow existing codebase patterns
2. Ask for clarification
3. Prioritize clarity over cleverness
4. Write tests
5. Document complex logic
