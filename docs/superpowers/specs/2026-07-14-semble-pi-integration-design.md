# Semble Integration for Pi — Design

## Goal

Add a personal Pi extension that exposes `semble_rs` as specialized code-exploration tools and a build-output digest tool. Pi should prefer these tools over built-in search tools while retaining the built-ins as fallbacks.

This integration is local-only and assumes `semble_rs` is available on `PATH`. It will not modify Pi core, install or manage the binary, support remote Git URLs, or interact with Pi session compaction.

## Location and Structure

The implementation lives in the user's actual Pi extension directory:

```text
~/.config/pi/agent/extensions/semble/
├── index.ts
├── adapter.ts
├── adapter.test.ts
└── SKILL.md
```

- `index.ts` registers tools, executes processes, truncates output, handles failures, and contributes the colocated skill through `resources_discover`.
- `adapter.ts` contains dependency-free argument builders, path normalization helpers, JSON/JSONL parsers, concise formatters, and digest pipeline construction.
- `adapter.test.ts` contains minimal separate tests using `node:test` and `node:assert/strict`.
- `SKILL.md` documents the exploration and digest workflows.

## Tools

The extension registers six active tools.

### `semble_search`

Semantic and lexical code search.

Parameters:

- `query` — required search query.
- `path` — optional local root, default `.`; relative and absolute paths are allowed.
- `mode` — optional `compact` or `outline`, default `compact`.
- `limit` — optional integer from 1 through 25, default 10.
- `includeTextFiles` — optional boolean, default false.

The tool invokes `semble_rs search` without a shell. Compact and outline output contain scores and `file:start-end` locations, not complete chunks. Empty output becomes `No results found.` A focused source comment marks where a future `json --strip` full-chunk mode could be added; it is not implemented now.

### `semble_find_related`

Finds code related to a prior `file:line` result.

Parameters:

- `file` — required file path.
- `line` — required 1-indexed line number.
- `path` — optional local root, default `.`.
- `limit` — optional integer from 1 through 25, default 10.
- `includeTextFiles` — optional boolean, default false.

The tool requests upstream JSON, parses it, and emits one score plus `file:start-end` location per result. It never forwards complete chunk bodies.

### `semble_deps`

Shows dependencies for a file.

Parameters:

- `file` — required file path, normalized relative to the selected root when possible.
- `path` — optional local root, default `.`.
- `tree` — optional boolean, default false.
- `maxDepth` — optional positive integer, used only with `tree`.

Flat mode is the default and returns symbols, direct imports, and direct users. Tree mode returns transitive imports. The tool does not expose `impact` or Graphviz output.

### `semble_tree`

Prints a gitignore-aware repository map.

Parameters:

- `path` — optional local root, default `.`.
- `symbols` — optional boolean, default true.
- `maxDepth` — optional positive integer.
- `directoriesOnly` — optional boolean, default false.
- `languages` — optional array of language names.
- `includeTextFiles` — optional boolean, default false.

Remote Git URLs are rejected. Symbols are included by default.

### `semble_find_pattern`

Runs structural search through `semble_rs find-pattern`; `ast-grep` is assumed to be installed.

Parameters:

- `pattern` — required ast-grep pattern.
- `path` — optional local root, default `.`.
- `language` — optional ast-grep language name.

The tool invokes upstream `--compact`, parses its JSONL records, and emits normalized `file:start-end` locations only. Complete matching code and metavariable output are intentionally omitted. A focused source comment marks the formatter as the future extension point for code output.

### `semble_digest`

Runs a build, test, install, lint, type-check, or CI command and sends its combined stdout/stderr through `semble_rs digest`.

Parameters:

- `command` — required shell command.
- `format` — optional canonical value: `auto`, `cargo`, `pnpm`, `tsc`, `pytest`, `ci`, `go`, `gradle`, `ruff`, `mypy`, or `compiler`; default `auto`.
- `timeout` — optional positive timeout in seconds.

The generated shell program has this shape:

```sh
set -o pipefail
(
  <command>
) 2>&1 | semble_rs digest --format <format>
```

It executes through Pi's local Bash implementation so cancellation, process-tree termination, timeout handling, streaming updates, output truncation, and nonzero-exit failures match the built-in Bash tool. A failed producer command yields a failed tool result containing the digested output. Raw undigested logs are not retained.

## Path and Execution Rules

- Every local root defaults to `.` relative to Pi's current working directory.
- Relative and absolute local paths are accepted.
- A leading `@` is stripped from path parameters, matching Pi's built-in tools.
- URL-like roots are rejected before execution.
- Non-digest tools invoke `semble_rs` directly with an argument array, never shell interpolation.
- There is no startup version check or binary lookup cache. A missing executable produces a clear tool error when called.

## Agent Guidance

Each tool has a concise description. Always-loaded prompt guidance establishes these rules:

1. Prefer Semble tools for repository mapping, code search, related-code discovery, dependency inspection, and structural search.
2. Use built-in `grep`, `find`, and `ls` only as fallbacks when Semble cannot answer the query.
3. Follow location-producing tools with Pi's `read` tool for only the selected ranges.
4. Use `semble_digest` instead of ordinary Bash for noisy build, test, install, lint, type-check, and CI commands.
5. Do not use Semble digest for conversation or session compaction.

The colocated `SKILL.md` provides the fuller decision tree and examples. It remains model-invocable and available as `/skill:semble`. The extension registers it with Pi's `resources_discover` event, so the skill is present exactly when the extension is loaded.

## Output and Error Handling

- Search-like output uses head truncation because highest-ranked and earliest results matter.
- Digest delegates to Pi's Bash tool, which uses tail truncation because final errors matter.
- Process output is limited to Pi's standard 2,000-line or 50 KB context boundary.
- If a non-digest processed result exceeds the limit, the full processed result is written to a temporary file and the returned text identifies that file.
- Empty search, related, or pattern results return an explicit no-results message.
- Invalid JSON or JSONL from `semble_rs` fails the tool with a concise parsing error rather than forwarding malformed data.
- Nonzero process exits fail the tool and preserve useful stdout/stderr in the error text.
- No handler catches and disguises cancellation or timeout as success.

## Testing

`adapter.test.ts` remains separate from production registration code and covers only deterministic behavior:

- argument construction for all non-digest commands;
- defaults, optional flags, and result limits;
- leading-`@` normalization and remote-URL rejection;
- `find-related` JSON normalization;
- `find-pattern` JSONL normalization;
- empty-result formatting;
- digest pipeline construction and format placement.

Verification also includes:

1. `node --test adapter.test.ts`;
2. loading the extension through Pi to catch registration or import errors;
3. smoke calls against a tiny temporary fixture for search, find-related, deps, tree, and find-pattern;
4. successful and failing digest commands to confirm compressed output and failure propagation.

No model-driven end-to-end test is required.

## Explicit Non-Goals

- Pi session compaction, `/compact`, or conversation summarization.
- Pi core modifications.
- `semble_rs impact`, `plan`, `encode`, or `savings` tools.
- Automatic interception or replacement of Pi's built-in tools.
- Extension-side index caching.
- Remote Git URL cloning.
- Binary installation, updates, downloads, or platform management.
- Public packaging or publication.
