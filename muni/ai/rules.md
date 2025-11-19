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

## Documentation style

### Line comments

- **Use all lowercase** for inline comments explaining implementation details.
- **Be concise.** Comments should explain *why* more than *what*.

```typescript
// (good: explains the reasoning)
// convert ounces to grams for consistent units
const grams = oz * GRAMS_PER_OUNCE;

// (bad: states the obvious)
// multiply oz by GRAMS_PER_OUNCE to get grams
const grams = oz * GRAMS_PER_OUNCE;
```

- **Spell out "and".** Do not use the ampersand symbol "&" as a conjunction;
  always write out "and" in documentation, comments, and Markdown files.
- **Use sentence case** for headings and titles as demonstrated throughout this
  document.

### Documentation comments

- **Use sentence case** for documentation comments.
- **Document public APIs** for all public functions, classes, and modules.
- **Include examples.** Show usage when complexity warrants it.
- **Document parameters and return values.**

````rust
/// Calculates the total price with tax for a given amount.
///
/// # Returns
///
/// The total amount in cents including tax.
///
/// # Example
///
/// ```
/// let total = calculate_total_with_tax(1000, 0.08);
/// assert_eq!(total, 1080);
/// ```
pub fn calculate_total_with_tax(
    /// The pre-tax amount in cents.
    amount: u64,

    /// The tax rate as a decimal (e.g., 0.08 for 8%).
    tax_rate: f64,
) -> u64 {
    let tax = (amount as f64 * tax_rate).round() as u64;
    amount + tax
}
````

### Module documentation

````typescript
/**
 * User authentication and authorization module.
 *
 * This module provides functionality for:
 * - User registration and login
 * - Password hashing and verification
 * - JWT token generation and validation
 * - Role-based access control
 *
 * @module auth
 * @example
 * ```typescript
 * import { AuthService } from './auth';
 *
 * const auth = new AuthService();
 * const token = await auth.login('user@example.com', 'password');
 * ```
 */
````

````rust
//! # User authentication and authorization
//!
//! This module provides functionality for:
//!
//! - User registration and login
//! - Password hashing and verification
//! - JWT token generation and validation
//! - Role-based access control
//!
//! ```rust
//! use auth::AuthService;
//!
//! let auth = AuthService()::new();
//! let token = auth.login('user@example.com', 'password').await;
//! ```
````

### Examples

```typescript
/** The amount of grams in an imperial ounce. */
export const GRAMS_PER_OUNCE = 28.34952;

/**
 * An interface containing information about some kind of fruit.
 */
export interface Fruit {
  /** What the fruit is called. */
  name: string;

  /** The caloric content of the fruit, in kcal. */
  calories: number;

  /** The weight of the fruit, in grams. */
  weight: number;
}

/**
 * Creates a Fruit from the specified information.
 */
export const newFruit = (name: string, kcal: number, oz: number): Fruit => {
  // convert ounces to grams
  const grams = oz * GRAMS_PER_OUNCE;

  return {
    // ensure the name is all lowercase
    name: name.toLowerCase(),

    // round calories to the nearest integer
    calories: Math.round(kcal),

    // the weight we store should be in grams
    weight: grams,
  };
};
```

```rust
// A constant to convert pounds to ounces.
pub const OUNCES_PER_POUND: f32 = 16.0;

/// An enum for the different species of animals we can track.
pub enum Species {
  /// Bark bark bark!
  Dog,

  /// Meow meow mow.
  Cat,

  /// Unicorns are magical! Neigh! <3
  Unicorn,
}

/// A struct describing some animal.
pub struct Animal {
  /// The species of the animal.
  pub species: Species,

  /// A cute name for our animal.
  pub name: AnimalKind,

  /// The weight of the animal, in ounces.
  pub weight: u32,
}

impl Animal {
  /// Creates a new Animal record, using pounds as the provided weight.
  pub fn new_from_lbs(species: Species, name: String, lbs: f32) -> Self {
    // ensure the name is capitalized
    let name = capitalize_name(name);

    // convert pounds to ounces
    let weight = (lbs * OUNCES_PER_POUND).round() as u32;

    Self {
      species,
      name,
      weight,
    }
  }
}

/// Capitalizes the first letter of the given string.
fn capitalize_name(name: String) -> String {
  // use the titlecase library to make this easier
  // we import the trait so we can use call `titlecase()` on `name`
  use titlecase::Titlecase;

  // converts a string like "some silly name" into "Some Silly Name"
  titlecase(name)
}
```

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
regularly. The `commit` agent can take care of commits.

## Git commit conventions

### Structure

```
type(scope)!: description under 72 characters

[optional body: explain what and why, not how]

[optional footer: reference issues, breaking changes]
```

### Commit types

These are the following commit types we use:

- `build`: for commits that change the build process.
- `chore`: for commits that don't modify the actual code, such as adding
  dependencies.
- `ci`: for commits that affect continuous integration or continuous deployment
  (CI/CD).
- `docs`: for commits that affect documents (like Markdown files) or change only
  comments within the codebase.
- `dx`: for commits that improve or otherwise modify developer experience (DX).
  `dx` commits may add tools (such as language servers or CLI packages), or
  adjust configuration files to improve linting or code formatting.
- `feat`: for commits that add a new feature to the code relevant to end users.
  `feat` commits will increment the MINOR version number in semantic versioning.
  If a commit doesn't affect an end user's experience, a `build`, `ci`, or `dx`
  commit type might be more appropriate.
- `fix`: for commits that fix bugs or errors in the code. `fix` commits will
  increment the PATCH version number in semantic versioning.
- `perf`: for commits that modify the code and improve its performance or
  optimize its logic.
- `refactor`: for commits that modify the code, but don't add a feature or fix a
  bug.
- `style`: for commits that strictly modify code style or formatting, like
  adding/removing whitespace, newlines, braces, parentheses, or semicolons.
  `style` commits are NOT relevant to CSS or SCSS changes. CSS or SCSS changes
  are likely better suited with a `feat` or `fix` commit type.
- `test`: for commits that add or modify automated tests.

### Scopes

Some conventional commit messages should also specify a scope. Scopes should
ideally be only a single word, relate to the files modified for the commit, and
should NOT include file extensions.

The scope should be named after the file (if only one file was modified), or a
common ancestor of multiple files modified. If the common ancestor is `src` or
some other top-level directory, OMIT the scope the entirely.

#### Examples

- If the user has staged one file named `src/ui/Menu.tsx`, the scope becomes
  `Menu`. You should match the case convention of the files. DO NOT include the
  file extension.
- If the user has staged two files named `src/ui/Header.tsx` and
  `src/ui/Footer.tsx`, the scope becomes `ui`. The `ui` directory is the common
  ancestor of all files to be committed.
- If the user has staged four files-- `src/api/accounts.rs`, `src/api/users.rs`,
  `src/utils/math.rs`, and `src/db/user.rs`-- the scope is omitted. The only
  common ancestor is the `src` directory, which is not a valid scope.
- If the user has staged two files named `.gitignore` and `src/ui/Hero.tsx`, you
  should probably warn the user to unstage one of the files. It seems that they
  are not related. If the user confirms that they should be committed together,
  do not add a scope. The files do not share a common ancestor.

### Descriptions

The description of your commit messages should be descriptive and specific, but
should be concise and never exceed 72 characters. Ensure the phrasing is in
imperative form.

### Message body

You may add a body to your commit messages to describe the changes made in more
detail.

If the changes you're about to commit introduce a breaking change, STOP. You
MUST ask the user for confirmation before continuing, and MUST provide a summary
of the changes about to be committed and why they need to be committed. If the
user approves the changes, when you commit the changes, you MUST add an
exclamation mark (!) after the type and scope (e.g. `feat(api)!: ...`), and add
a `BREAKING CHANGE:` footer to the commit message body explaining the breaking
change. Such commits will increment the MAJOR version number in semantic
versioning.

### Other requirements

**NEVER** add co-author footers to your commit messages.

### Examples

Here are some arbitrary examples based on a developer's changes on hypothetical
codebases:

- They enabled the `mold` linker inside a Nix flake for a Rust project:

  ```
  build: enable `mold` linker for faster build times
  ```

- They modified `.gitignore` to exclude some generated files:

  ```
  chore: add `.pre-commit-config.yaml` to `.gitignore`

  `.pre-commit-config.yaml` is automically generated by `git-hooks` in
  `flake.nix`, and is a symlink that will not persist on other
  developers' systems.
  ```

- They modified a CI configuration file to automatically test code changes when
  they are pushed to a remote GitHub repository:

  ```
  ci: add `npm test` job to `push` hook for GitHub Actions
  ```

- They added comments to document various structs and functions in a file named
  `src/animal/canine.rs`:

  ```
  docs(canine): add doc comments for various structs and functions

  Adds documentation for:
  - `Dog` struct
  - `Wolf` struct
  - `generate_random_canine` function
  - `Dog::bark` method
  ```

- They modified a `tsconfig.json` file to add stricter linting rules:

  ```
  dx(tsconfig): enable `strictNullChecks` and `noImplicitAny`

  Enables tsconfig flags that enforce better type safety and linting.
  ```

- They added some code to `src/animal/feline.rs`, `src/animal/canine.rs`, and
  `src/animal/bird.rs` that adds a petting feature:

  ```
  feat(animal): add ability to pet animals

  Now our animals can receive love!
  ```

- They fixed a bug in `src/fruit/apple.rs` where calling `bite()` on an `Apple`
  struct would cause it to rot:

  ```
  fix(apple): don't rot immediately after biting

  Fixes a bug where `Apple`s would rot too soon after biting.
  ```

- They optimized some code in `src/db/user-stats.ts` where you changed a
  sequential `for` loop of queries into a collection of `Promise`s:

  ```
  perf(user-stats): improve processing time with concurrent `Promise.all` execution

  Replaces slow sequential query execution in a `for` loop by
  collecting all queries into a `Promise[]` first and then executing them
  concurrently with `Promise.all`.
  ```

- They modified some code to remove `undefined` and `null` from type union
  annotations in TypeScript files `src/bigVehicles/plane.ts` and
  `src/bigVehicles/train.ts`:

  ```
  refactor(bigVehicles): improve type annotations for `plane.ts` and `train.ts`

  Replaces `string | null` with `string` and `number | undefined` with
  `number` to improve type safety and strictness.
  ```

- They ran `biome format --write` to format code across the entire codebase:

  ```
  style: format all code with `biome`
  ```

- They fixed some unit tests that had broken with the last refactor with a
  `src/api/accounts.ts` module:

  ```
  test: fix automated tests for `accounts` module

  Fixes unit tests that were failing after consolidating `accounts` API functions
  ```

- They remove functions that were deprecated after being renamed to other
  functions.

  ```
  refactor!: remove deprecated functions for v1.0 release

  BREAKING CHANGE: This change removes functions that were previously
  deprecated and does not maintain backwards compatibility.
  ```

### Commit size guidelines

- **Atomic commits.** Each commit should do one thing and can easily be
  reverted.
- **Small commits.** Prefer 10 small commits over one large commit.
- **Testable.** Each commit should preferably leave the codebase in a working
  state.
- **Reviewable.** Changes should be easy to review.

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
