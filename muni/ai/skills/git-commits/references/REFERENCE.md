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

## Commit types

We use these types for commits:

| Type       | Use for                                        |
| ---------- | ---------------------------------------------- |
| `build`    | Build process changes                          |
| `chore`    | Non-code changes (dependencies)                |
| `ci`       | CI/CD changes                                  |
| `docs`     | Documentation/comments only                    |
| `feat`     | New user-facing features (bumps MINOR version) |
| `fix`      | Bug fixes (bumps PATCH version)                |
| `perf`     | Performance improvements                       |
| `refactor` | Code changes without feature/fix               |
| `style`    | Formatting only (not CSS)                      |
| `test`     | Changes or additions to testing suites         |

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
