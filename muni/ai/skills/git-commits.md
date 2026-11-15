---
name: Git commit message guidelines
description:
  Creates git commit messages that follow the Musicaloft guidelines for commit messages. Use when
  planning a commit recipe or just creating git commits.
---

# Musicaloft commit message guidelines

We follow an extension of the Conventional Commit specification when writing commit messages. Always
follow these guidelines when committing code.

## Introduction

- Commits must be as small, as granular, and as atomic as possible.
- Ensure every commit contains only ONE logical change.
- Break changes down into small commits that can each be tested individually.
- NEVER commit a big feature or bug fix in just one commit.
- NEVER add co-author footers.

**NEVER** AMEND COMMITS.

If a pre-commit hook fails, the commit will be rejected and must be retried after issues are fixed.

Formatter hooks (like `treefmt`) may format files and then reject the commit if changes were made.
If this happens, re-add the formatted portions of the changed files, and then attempt the commit
again.

## General format

```
type(scope)!: description under 72 characters

[optional body: explain what and why]

[optional footer: BREAKING CHANGE, issue refs]
```

## Scope rules

Scopes MUST:

1. be a single identifier
2. NEVER contain file extensions

Determining the correct scope depends on how many files are being committed.

- **One file:** use base file name (e.g. `Menu` for `src/ui/Menu.tsx`)
- **Multiple files:** use common ancestor directory (e.g. `ui` for `src/ui/Menu.tsx` and
  `src/ui/Button.tsx`)
- If the only common ancestor directory is `src`, omit the scope entirely.

## Breaking changes

If you are committing a breaking change, you MUST:

1. add `!` after the type and scope (e.g. `feat(api)!: ...`)
2. add a `BREAKING CHANGE:` footer describing the breaking changes and WHY they are breaking
   changes.

## Examples

```gitcommit
build: enable `mold` linker for faster build times
```

```gitcommit
feat(animal): add ability to pet animals

Now our animals can receive love!
```

```gitcommit
refactor!: remove deprecated functions for v1.0 release

BREAKING CHANGE: Removes previously deprecated functions. Dependents who upgrade to this version will be unable to use deprecated functions.
```

## Commit types

This is a detailed reference for every commit type we use. Each entry includes a brief summary,
examples of when to use a type, and example messages for a type.

The types are listed alphabetically.

### `build`: Build process or dependencies

`build` is for changes that impact the build process or production dependencies, including the tools
and configuration required to deploy or run the application.

#### When to use

- Updating build scripts (Cargo, Webpack, Rollup, etc.)
- Changing or upgrading dependencies that affect production code
- Modifying how the application is bundled or deployed
- Adjusting Docker or Kubernetes configurations

#### Examples

- `build: enable mold linker for faster build times`
- `build: upgrade webpack to version 5`
- `build(deps): update chrono to v0.4.45`

### `chore`: Maintenance and routine tasks

`chore` is for administrative or supportive tasks that do not impact production code.

#### When to use

- Miscellaneous tasks or project administration that doesn't fit other types
- Updating `.gitignore`, adjusting package scripts, or other project settings
- Renaming or moving files/folders without changing actual code logic
- Adjusting or creating scripts that help with local/manual testing or make development easier
- Updating development-only dependencies (e.g. `eslint`, `vitest`)

#### Examples

- `chore: update .gitignore to exclude .idea files`
- `chore: reorganize folder structure for better clarity`
- `chore(deps): update eslint to v8.14.0`

### `ci`: Continuous integration

`ci` is for changes to CI/CD configurations or workflows.

#### When to use

- Changing CI/CD configuration files or scripts
- Updating workflows for GitHub Actions, GitLab CI, Jenkins, etc.
- Adding new CI steps (e.g. code coverage, automated security scans)

#### Examples

- `ci: add code quality checks in GitHub Actions`
- `ci: configure Jenkins pipeline for integration tests`
- `ci: add security scan step in GitLab pipeline`

### `docs`: Documentation

`docs` is for changes to documentation, comments, or API descriptions only.

#### When to use

- Making changes to documentation files (e.g. `README.md`, `CHANGELOG.md`)
- Adding or updating inline code comments, docstrings, or usage guides
- Writing API documentation
- Updating setup instructions

#### Examples

- `docs: update README to include installation steps`
- `docs: add comments to public methods`
- `docs: document API usage examples for new endpoints`

### `feat`: New feature or functionality

`feat` is for adding new user-facing features or functionality. This type bumps the MINOR version
(unless it introduces a breaking change, which bumps MAJOR) and appears in user-facing changelogs.

#### When to use

- Adding a brand-new feature
- Implementing new functionality that wasn't there before
- Introducing a new behavior
- Adding a new configuration option or parameter to an existing system

#### Examples

- `feat(animal): add ability to pet animals`
- `feat(ui): add dark mode to the user interface`
- `feat(api): add support for pagination in user endpoint`

### `fix`: Bug fix

`fix` is for addressing actual bugs that cause incorrect behavior in production code. This type
bumps the PATCH version and appears in user-facing changelogs.

#### When to use

- Correcting unintentional or erroneous behavior
- Fixing a known bug
- Correcting invalid or malfunctioning visual styles (e.g. fixing incorrect color values)
- Resolving crashes or runtime errors

#### Examples

- `fix: correct CSS color for button background`
- `fix: null pointer handling`
- `fix(frontend): remove flickering effect on page refresh`

### `perf`: Performance improvement

`perf` is for changes that bring measurable performance improvements.

#### When to use

- Optimizing existing code for speed or memory usage
- Reducing overhead in database queries or API calls
- Improving rendering or load times
- Adding caching mechanisms to frequently accessed data

#### Examples

- `perf: reduce number of redundant API calls`
- `perf(ui): improve table rendering performance`
- `perf: add caching for user session data`

### `refactor`: Code refactoring without changing behavior

`refactor` is for structural improvements to the code without changing its behavior. Unlike `style`,
`refactor` focuses on enhancing the internal structure, logic, or organization of the code without
altering its external behavior.

#### When to use

- Restructuring or reorganizing code for clarity, maintainability, or scalability
- Extracting common logic into utility functions
- Splitting large modules into smaller, more focused ones
- Making a code section fail-safe without changing functionality
- Simplifying complex conditions or loops
- Renaming variables or methods for readability and clarity

#### Examples

- `refactor: extract utility functions for data validation`
- `refactor(ui): separate styling logic from component logic`
- `refactor: simplify nested loops`
- `refactor: rename variable temp to temperature`

### `revert`: Reverting a previous commit

`revert` is for rolling back a previous commit.

#### When to use

- Undoing or rolling back a previous commit when necessary
- Typically references the commit hash that is being reverted in the commit message body (e.g. "This
  reverts commit 05f3b535e0628e0cb9852f920bd246f3e1384668.")

#### Examples

- `revert: "feat: add social login feature"`
- `revert: "fix: correct CSS color for button background"`

### `style`: Code formatting only

`style` is for formatting changes to code that do not affect its behavior. Note that this type is
for code formatting only, and NEVER for CSS changes. The key difference from `refactor` is that
`style` changes are purely superficial and do not affect the structure, semantics, or functionality
of the code.

#### When to use

- Formatting the codebase (e.g. via `treefmt`, `rustfmt`, `oxfmt`)
- Adjusting whitespace, indentation, line breaks, or punctuation
- Making pure code formatting changes that do **not** affect behavior

#### Examples

- `style: reformat code with rustfmt rules`
- `style: change indentation from 2 to 4 spaces`
- `style: fix formatting inconsistencies across multiple files`

### `test`: Tests and test-related changes

`test` is for adding, modifying, fixing, or improving tests.

#### When to use

- Adding or updating unit, integration, or end-to-end tests
- Refactoring test code or changing test data
- Fixing broken test scripts
- Adding quality assurance scripts
- Covering edge cases in existing tests

#### Examples

- `test: add integration tests for checkout process`
- `test(auth): improve token validation tests`
- `test: cover edge cases for user registration validation`
