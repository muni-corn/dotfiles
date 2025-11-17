# Musicaloft development guidelines

This document provides some general guidelines for AI coding agents working on
projects for Musicaloft.

## context7

Always use context7. You should use it to search for up-to-date documentation
and examples on libraries used within the project.

## Project structure and architecture

### General principles

- **Modularity.** Break code into small, focused modules with single
  responsibilities.
- **Layering.** Separate concerns (presentation, business logic, data access).
- **Consistency.** Follow existing patterns in the codebase.
- **Discoverability.** Use clear, descriptive names for files and directories.

### File organization

- **One primary export per file.** Each file should have a clear, primary
  purpose.
- **Colocate related code.** Keep related types, functions, and tests together.
- **Avoid deep nesting.** Maximum 3-4 levels of directory depth.

## Code style and formatting

- **Readability first.** Write code that is easy to understand and maintain
- **Small file size.** Keep files small (less than 500 lines) wherever possible.

### Naming conventions

- **Variables and functions.** Use descriptive names that clearly indicate
  purpose.
- **Classes and types.** `PascalCase` for type definitions.
- **Constants.** `UPPER_SNAKE_CASE` for top-level constants that don't change.
- **Files.** Use consistent naming convention established in the project
  (kebab-case, snake_case, camelCase, etc). Otherwise:
  - For Rust, default to `snake_case.rs` for file names and directories.
  - For TypeScript, default to `kebab-case.ts` for file names and directories.

### Code organization

- **Group related code.** Keep related types, functions, and constants together
- **Separate concerns.** Organize code by functionality, not by technical layer
- **Export public APIs clearly.** Make it easy to understand what is part of the
  public interface

### Code structure

#### Rust

```rust
// imports first
use std::collections::HashMap;
use serde::{Deserialize, Serialize};
use crate::error::AppError;

// then constants
const DEFAULT_TIMEOUT: Duration = Duration::from_secs(5);

// type definitions
#[derive(Debug, Clone)]
pub struct User {
    pub id: Uuid,
    pub name: String,
}

// main implementation
impl UserService {
    // public methods first
    pub async fn create_user(&self, user: NewUser) -> Result<User, AppError> {
        // implementation ...
    }

    // private methods after
    fn validate_input(&self, data: &NewUser) -> bool {
        // implementation ...
    }
}
```

#### TypeScript

```typescript
// imports first
import { Request, Response } from 'express';
import { UserService } from '@services/user';
import { validateUser } from './utils';

// then constants
const DEFAULT_TIMEOUT = 5000;

// interface/type definitions
interface User {
  id: string;
  name: string;
}

// main implementation
export class UserController {
  // public methods first
  public async createUser(req: Request, res: Response): Promise<void> {
    // implementation
  }

  // private methods after
  private validateInput(data: unknown): boolean {
    // implementation
  }
}
```

## Comments and documentation

You should delegate the `doc` agent for writing documentation after you write
code. Be specific when requesting what you want it to document.

You should NEVER generate Markdown files unprompted. Simply explain changes you
make to the user-- no matter how large-- UNLESS the user specifically asks you
to generate documentation for the changes.

**Keep comments current.** Always update comments if you change code.

### Documentation style overview

#### Line comments

- **Use all lowercase** for inline comments explaining implementation details.
- **Be concise.** Comments should explain *why* more than *what*.
- **Spell out "and".** Do not use the ampersand symbol "&" as a conjunction;
  always write out "and" in documentation, comments, and Markdown files.
- **Use sentence case** for headings and titles as demonstrated throughout this
  document.

#### Documentation comments

- **Use sentence case** for documentation comments.
- **Document public APIs** for all public functions, classes, and modules.
- **Include examples.** Show usage when complexity warrants it.
- **Document parameters and return values.**

#### TODO comments

- **Include issue numbers** when applicable.
- **Be specific** about what needs to be done.
- **Review regularly.** Don't let TODOs accumulate.

```rust
// TODO: optimize this algorithm from O(n²) to O(n log n) - issue #456.
// current implementation works for small datasets but needs improvement
// for production use with large volumes.
```

## Git commits

If you are writing code, the changes you are making should be committed
regularly. You can call the `commit` agent to take care of commits for you. It
should be able to adhere to our own conventional commit specification.

## Testing

If the project has a testing suite, follow these guidelines. If not, you should
only encourage implementing a test suite. NEVER build a testing suite
unprompted.

### Testing philosophy

- **Test behavior, not implementation.** Test *what* the code does, not how.
- **Write tests first.** Prefer test-driven development (TDD) when appropriate.
- **Keep tests fast.** Fast tests encourage frequent running.
- **Make tests reliable.** Flaky tests are worse than no tests.
- **Test edge cases.** Include boundary conditions and error cases.

### Test structure

#### TypeScript (Vitest)

```typescript
// Group related tests with describe blocks
describe('UserService', () => {
  let service: UserService;

  // Setup before each test
  beforeEach(() => {
    service = new UserService();
  });

  // Clear description of what's being tested
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      const user = await service.createUser(validUserData);
      expect(user).toMatchObject({
        id: expect.any(String),
        name: validUserData.name,
      });
    });

    it('should throw error with invalid email', async () => {
      await expect(service.createUser(invalidEmailData))
        .rejects.toThrow('Invalid email format');
    });
  });
});
```

#### Rust

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn creates_user_with_valid_data() {
        let service = UserService::new();
        let user = service.create_user(valid_user_data()).unwrap();
        
        assert_eq!(user.name, "Test User");
        assert!(!user.id.is_nil());
    }

    #[test]
    fn returns_error_with_invalid_email() {
        let service = UserService::new();
        let result = service.create_user(invalid_email_data());
        
        assert!(result.is_err());
        matches!(result.unwrap_err(), Error::InvalidEmail(_));
    }
}
```

### Test coverage guidelines

If test coverage tools are available:

- **Minimum 85% coverage** for critical paths.
- **100% coverage** for utility functions and pure functions.
- **Test error paths.** Don't just test happy paths.
- **Integration tests.** Test component interactions.
- **E2E tests.** Test critical user flows.

### Mocking

#### TypeScript

When mocking with `vitest`, remember that **you cannot mock functions within
modules that you are testing.** You cannot use `spyOn` to mock sibling
functions. Instead, when testing any given module, ensure you only mock
functions imported into the module.

```typescript
import { vi } from 'vitest';

// use `vi.mock` for module mocking
vi.mock('./database');

// use factories for test data
const createMockUser = (overrides = {}) => ({
  id: '123',
  name: 'Test User',
  email: 'test@example.com',
  ...overrides,
});
```

#### Rust

```rust
// use traits for testability
#[cfg(test)]
use mockall::automock;

#[cfg_attr(test, automock)]
pub trait EmailService {
    fn send_email(&self, to: &str, subject: &str, body: &str) -> Result<()>;
}

// use test fixtures
#[fixture]
fn test_user() -> User {
    User {
        id: Uuid::new_v4(),
        name: "Test User".to_string(),
    }
}
```

## Error handling

### Error handling philosophy

- **Be explicit.** Don't hide errors, handle them appropriately
- **Provide context.** Include relevant information in error messages
- **Fail fast.** Detect and report errors early
- **Graceful degradation.** Handle errors without crashing
- **Log appropriately.** Log errors with appropriate levels

### TypeScript error handling

Discriminated unions are useful for result types. The `neverthrow` library is
useful for this:

```typescript
import { Result } from 'neverthrow';
```

Custom error classes:

```typescript
import { ErrorCode } from './error-codes.ts';

export class AppError extends Error {
  public readonly code: ErrorCode;
  public readonly statusCode: number;

  constructor(message: string, code: string, statusCode: number) {
    super(message);
    this.name = 'AppError';
    this.code = code;
    this.statusCode = statusCode;
  }
}
```

// error handling in async functions:

```typescript
export async function fetchUser(id: string): Promise<User> {
  try {
    const response = await api.get(`/users/${id}`);
    if (!response.ok) {
      throw new AppError(
        `Failed to fetch user: ${response.statusText}`,
        'USER_FETCH_ERROR',
        response.status
      );
    }

    return response.json();
  } catch (error) {
    if (error instanceof AppError) {
      throw error;
    }

    // wrap unexpected errors
    throw new AppError(
      'An unexpected error occurred',
      'UNEXPECTED_ERROR',
      500
    );
  }
}
```

### Rust error handling

```rust
// use `thiserror` for error types
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("Database error: {0}")]
    Database(#[from] sqlx::Error),
    
    #[error("User not found: {0}")]
    UserNotFound(String),
    
    #[error("Invalid input: {0}")]
    InvalidInput(String),
    
    #[error("Authentication failed")]
    AuthenticationFailed,
}
```

You may create a `Result` type alias for convenience:

```rust
pub type AppResult<T> = std::result::Result<T, AppError>;
```

Error handling with context:

```rust
pub async fn fetch_user(&self, id: Uuid) -> AppResult<User> {
    sqlx::query_as!(User, "SELECT * FROM users WHERE id = $1", id)
        .fetch_optional(&self.pool)
        .await
        .map_err(AppError::Database)?
        .ok_or_else(|| AppError::UserNotFound(id.to_string()))
}
```

Use `anyhow` for application-level errors:

```rust
use anyhow::{Context, Result};

pub fn process_data(file_path: &str) -> Result<Data> {
    let content = std::fs::read_to_string(file_path)
        .context("Failed to read data file")?;
    
    serde_json::from_str(&content)
        .context("Failed to parse JSON data")
}
```

### Error messages

- **Stylize error messages** in all lowercase.
- **Use friendly, lighthearted language.** Try not to use technical jargon.
- **Be clear and concise.** Use "user wasn't found" instead of "an error
  occurred".
- **Include context.** "couldn't connect to 'users_db' database at
  localhost:5432"
- **Suggest solutions.** "does the file exist and have read permissions?"

## Security best practices

### General security

- **Never commit secrets.** Use environment variables or secret management.
- **Validate all inputs.** Sanitize and validate user input.
- **Use parameterized queries.** Prevent query injection.
- **Implement rate limiting.** Protect against abuse.

### Rust security

Input validation:

```rust
use validator::{Validate, ValidationError};

#[derive(Debug, Validate)]
pub struct NewUser {
    #[validate(email)]
    pub email: String,
    
    #[validate(length(min = 1, max = 100))]
    pub name: String,
}
```

Secure password hashing:

```rust
use argon2::{Argon2, PasswordHasher, password_hash::SaltString};

pub fn hash_password(password: &str) -> Result<String> {
    let salt = SaltString::generate(&mut OsRng);
    let argon2 = Argon2::default();
    
    argon2.hash_password(password.as_bytes(), &salt)
        .map(|hash| hash.to_string())
        .map_err(|e| AppError::PasswordHash(e.to_string()))
}
```

Using environment variables for secrets:

```rust
use std::env;

pub fn get_api_key() -> Result<String> {
    env::var("API_KEY")
        .map_err(|_| AppError::Config("API_KEY not set".to_string()))
}
```

### TypeScript security

Input validation:

```typescript
import { z } from 'zod';

const userSchema = z.object({
  email: z.string().email(),
  name: z.string().min(1).max(100),
  age: z.number().int().min(0).max(150),
});
```

Secure password hashing:

```typescript
import bcrypt from 'bcrypt';

const hashPassword = async (password: string): Promise<string> => {
  const saltRounds = 12;
  return bcrypt.hash(password, saltRounds);
};
```

Using environment variables for secrets:

```typescript
const apiKey = process.env.API_KEY;
if (!apiKey) {
  throw new Error('API_KEY environment variable is required');
}
```

### Dependency security

- **Audit dependencies.** Run `npm audit` or `cargo audit` regularly
- **Pin versions.** Use exact versions in production
- **Review dependencies.** Minimize dependencies, review before adding
- **Use lock files.** Commit package-lock.json and Cargo.lock

## Performance considerations

NEVER implement premature optimizations, including caching, unless specified.

## Dependency management

### Adding dependencies

NEVER edit dependency lists manually. Always use commands to add the latest
version of a dependency to a project:

#### TypeScript

```bash
npm install --save package-name
# or
bun add package-name
# or
pnpm add package-name
# or
yarn add package-name

# for development dependencies
npm install --save-dev package-name
```

#### Rust

```bash
# always use cargo add
cargo add crate-name

# for development dependencies
cargo add --dev crate-name

# for build dependencies
cargo add --build crate-name
```

### Dependency selection criteria

- **Actively maintained.** Recent commits, responsive maintainers
- **Popular.** Sufficient usage and community support
- **Well-documented.** Good documentation and examples
- **Lightweight.** Minimal transitive dependencies
- **Secure.** No known vulnerabilities

## PR and review process

### Before creating a PR

Ensure:

- [ ] code follows style guidelines
- [ ] tests pass and coverage is maintained
- [ ] code is formatted
- [ ] documentation is updated
- [ ] commit history is clean and follows conventions
- [ ] no sensitive data or secrets committed
- [ ] performance impact considered

### PR description template

```markdown
## Summary

Brief description of the changes and why they're needed.

## Changes

- List specific changes made
- Include before/after examples if applicable

## Testing

- How were these changes tested?
- What test cases were added/modified?

## Breaking changes (if any)

- List any breaking changes
- Describe migration path if applicable

## Related issues

Closes #123

Related to #456
```

### Review guidelines

As an author:

- keep PRs small and focused
- respond to feedback promptly and respectfully
- explain your reasoning throughly when disagreeing with suggestions
- make requested changes in separate commits for clarity

As a reviewer:

- be constructive and specific in feedback
- explain the reasoning behind suggestions
- approve when satisfied, don't just leave comments
- test the changes locally when appropriate

### Review checklist

Ensure:

- [ ] code is readable and well-structured
- [ ] error handling is appropriate
- [ ] tests cover new functionality
- [ ] no performance regressions
- [ ] security considerations addressed
- [ ] documentation is clear and accurate

## Technology-specific guidelines

### Rust-specific patterns

#### Ownership and borrowing

```rust
// choose appropriate ownership model
fn process_data(data: String) -> String {
    // takes ownership - caller can no longer use original
    data.to_uppercase()
}

fn process_data_ref(data: &str) -> String {
    // borrows immutably - caller retains ownership
    data.to_uppercase()
}

fn modify_data(data: &mut String) {
    // borrows mutably for in-place modification. don't do this if you can help
    // it.
    data.push_str(" modified");
}
```

### TypeScript-specific patterns

#### Type safety best practices

Don't use the `any` type. Use proper types or `unknown`.

```typescript
// bad
function processData(data: any): any {
  return data.map(item => item.value);
}

// good
interface DataItem {
  value: string;
}

function processData(data: DataItem[]): string[] {
  return data.map(item => item.value);
}
```

Use `unknown` for truly unknown types that need validation.

```typescript
function parseJSON(json: string): unknown {
  return JSON.parse(json);
}
```

#### Async pattern recommendations

Wherever possible, use `async`/`await` instead of callbacks for better
readability:

```typescript
// Good
async function fetchUser(id: string): Promise<User> {
  const response = await api.get(`/users/${id}`);
  return response.json();
}
```

Handle errors with proper type checking:

```typescript
try {
  const user = await fetchUser(id);
} catch (error) {
  if (error instanceof AppError) {
    // handle known error type
  } else {
    // handle unexpected error
  }
}
```

## When in doubt

1. Follow existing patterns in the codebase
1. Ask for clarification from the user
1. Prioritize clarity and maintainability over clever solutions
1. Write tests for your code
1. Document complex logic and public APIs

Remember: **the goal is working, readable, maintainable software.** Use these
guidelines as a tool to achieve that goal, not as rigid rules that prevent
progress.
