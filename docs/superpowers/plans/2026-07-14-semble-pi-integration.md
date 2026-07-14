# Semble Pi Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add six reliable `semble_rs` tools and a colocated workflow skill to the user's `~/.config/pi/agent/extensions/` directory.

**Architecture:** Keep Pi registration and process execution in `index.ts`; keep command construction and output parsing in a dependency-free `adapter.ts`. Exercise adapter behavior with a separate Node test file, then smoke-test the loaded extension and real binary against a temporary fixture.

**Tech Stack:** TypeScript, Pi Extension API, TypeBox, Node 26 `node:test`, `semble_rs` 0.9.1, `ast-grep`.

---

## File Structure

- Create `~/.config/pi/agent/extensions/semble/adapter.ts`: pure path validation, CLI argument builders, JSON/JSONL formatters, and digest pipeline builder.
- Create `~/.config/pi/agent/extensions/semble/adapter.test.ts`: minimal deterministic tests separate from extension registration.
- Create `~/.config/pi/agent/extensions/semble/index.ts`: six tool registrations, execution, truncation, errors, and resource discovery.
- Create `~/.config/pi/agent/extensions/semble/SKILL.md`: agent workflow and examples.

### Task 1: Argument Builders and Digest Pipeline

**Files:**
- Create: `~/.config/pi/agent/extensions/semble/adapter.test.ts`
- Create: `~/.config/pi/agent/extensions/semble/adapter.ts`

- [ ] **Step 1: Write failing argument-builder tests**

Create tests that assert:

```typescript
assert.deepEqual(buildSearchArgs({ query: "auth" }), [
  "search", "auth", ".", "--top-k", "10", "--compact",
]);
assert.deepEqual(buildFindRelatedArgs({ file: "@src/auth.ts", line: 12 }), [
  "find-related", "src/auth.ts", "12", ".", "--top-k", "10", "--json",
]);
assert.deepEqual(buildDepsArgs({ file: "/repo/src/auth.ts", path: "/repo", tree: true, maxDepth: 3 }, "/work"), [
  "deps", "src/auth.ts", "/repo", "--tree", "--max-depth", "3",
]);
assert.deepEqual(buildTreeArgs({}), ["tree", ".", "--symbols"]);
assert.deepEqual(buildFindPatternArgs({ pattern: "fn $NAME($$$)", language: "rust" }), [
  "find-pattern", "fn $NAME($$$)", ".", "--compact", "--lang", "rust",
]);
assert.equal(buildDigestPipeline("cargo test", "cargo"),
  "set -o pipefail\n(\ncargo test\n) 2>&1 | semble_rs digest --format cargo");
assert.throws(() => buildTreeArgs({ path: "https://github.com/a/b" }), /local paths/);
```

- [ ] **Step 2: Run tests and verify failure**

Run:

```bash
cd ~/.config/pi/agent/extensions/semble
node --test adapter.test.ts
```

Expected: failure because `adapter.ts` or its exports do not exist.

- [ ] **Step 3: Implement minimal builders**

Implement these exports in `adapter.ts`:

```typescript
export type SearchMode = "compact" | "outline";
export type DigestFormat = "auto" | "cargo" | "pnpm" | "tsc" | "pytest" | "ci" | "go" | "gradle" | "ruff" | "mypy" | "compiler";
export function normalizeLocalPath(path?: string): string;
export function buildSearchArgs(input: SearchInput): string[];
export function buildFindRelatedArgs(input: FindRelatedInput): string[];
export function buildDepsArgs(input: DepsInput, cwd?: string): string[];
export function buildTreeArgs(input: TreeInput): string[];
export function buildFindPatternArgs(input: FindPatternInput): string[];
export function buildDigestPipeline(command: string, format?: DigestFormat): string;
```

Rules:

- Strip one leading `@` from paths.
- Default roots to `.`.
- Reject `scheme://...` and `git@host:path` roots.
- Use defaults `limit=10`, `mode=compact`, `symbols=true`, `format=auto`.
- Convert an absolute dependency file inside an absolute root to a root-relative path.
- Append only selected flags and never interpolate non-digest values through a shell.

- [ ] **Step 4: Run tests and verify pass**

Run `node --test adapter.test.ts`.

Expected: all argument-builder tests pass.

### Task 2: Location-Only Result Formatters

**Files:**
- Modify: `~/.config/pi/agent/extensions/semble/adapter.test.ts`
- Modify: `~/.config/pi/agent/extensions/semble/adapter.ts`

- [ ] **Step 1: Add failing parser tests**

Add tests for:

```typescript
assert.equal(formatSearchOutput(""), "No results found.");
assert.equal(formatFindRelatedJson(JSON.stringify([{ score: 0.25, chunk: {
  file_path: "src/auth.ts", start_line: 10, end_line: 20, content: "secret body"
}}])), "0.2500\tsrc/auth.ts:10-20");
assert.equal(formatFindRelatedJson("[]"), "No related code found.");
assert.equal(formatFindPatternJsonl(JSON.stringify({
  file: "/repo/src/auth.ts",
  range: { start: { line: 9, column: 0 }, end: { line: 19, column: 1 } },
  text: "complete body",
}), "/repo", "/work"), "src/auth.ts:10-20");
assert.equal(formatFindPatternJsonl("", ".", "/work"), "No structural matches found.");
assert.throws(() => formatFindRelatedJson("not json"), /parse find-related JSON/);
```

- [ ] **Step 2: Run tests and verify failure**

Run `node --test adapter.test.ts`.

Expected: formatter exports are missing.

- [ ] **Step 3: Implement minimal formatters**

Implement:

```typescript
export function formatSearchOutput(output: string): string;
export function formatFindRelatedJson(output: string): string;
export function formatFindPatternJsonl(output: string, root: string, cwd: string): string;
```

`formatFindRelatedJson` validates an array of objects with numeric `score` and chunk location fields, formats scores to four decimals, and omits `content`. `formatFindPatternJsonl` parses each nonempty JSONL record, converts zero-indexed ast-grep lines to one-indexed inclusive locations, relativizes absolute files inside the selected root, and omits `text` and metavariables. Malformed records throw concise parsing errors.

Add narrow source comments at search and pattern formatters noting where full chunk/code modes could be added later; do not implement those modes.

- [ ] **Step 4: Run tests and verify pass**

Run `node --test adapter.test.ts`.

Expected: all adapter tests pass.

### Task 3: Register and Execute the Six Tools

**Files:**
- Create: `~/.config/pi/agent/extensions/semble/index.ts`

- [ ] **Step 1: Implement shared direct execution**

Add a helper that calls:

```typescript
const result = await pi.exec("semble_rs", args, { cwd: ctx.cwd, signal });
```

On nonzero exit, throw an error containing available stdout/stderr and the exit code. On cancellation, throw a cancellation error. Return stdout for parser-based tools. Treat nonempty stderr from `find-pattern` as an error because upstream currently ignores ast-grep's child exit status.

- [ ] **Step 2: Implement processed-output truncation**

Use Pi's `truncateHead`, `DEFAULT_MAX_LINES`, `DEFAULT_MAX_BYTES`, and `formatSize`. If processed output exceeds either limit, write that processed output to a unique temporary file and append a notice with its path. Do not save raw digest input.

- [ ] **Step 3: Register search-like tools**

Register TypeBox schemas and execution for:

```text
semble_search
semble_find_related
semble_deps
semble_tree
semble_find_pattern
```

Use `StringEnum` for `mode`. Constrain limits to 1–25 and line/depth values to positive integers. Add concise `promptSnippet` strings. Put cross-tool preference guidance on `semble_search`, explicitly naming Semble tools and built-in fallbacks.

- [ ] **Step 4: Register digest tool**

Register `semble_digest` with `command`, canonical `format`, and optional positive `timeout`. Build the pipeline with `buildDigestPipeline`, then delegate execution to:

```typescript
const bash = createBashToolDefinition(ctx.cwd);
return bash.execute(toolCallId, { command: pipeline, timeout }, signal, onUpdate, ctx);
```

This preserves Pi's built-in cancellation, timeout, process-tree, output-tail, and nonzero-exit behavior. Add prompt guidance to use this tool for noisy build/test/install/lint/type-check/CI commands and never for Pi session compaction.

- [ ] **Step 5: Register the colocated skill**

Resolve `SKILL.md` relative to `import.meta.url` and return it from `resources_discover.skillPaths`.

- [ ] **Step 6: Load-smoke the extension**

Run:

```bash
pi --no-extensions -e ~/.config/pi/agent/extensions/semble/index.ts --list-models >/tmp/pi-semble-models.txt
```

Expected: exit 0 with no import, schema, or registration errors.

### Task 4: Add the Semble Skill

**Files:**
- Create: `~/.config/pi/agent/extensions/semble/SKILL.md`

- [ ] **Step 1: Write the skill**

Use valid frontmatter:

```yaml
---
name: semble
description: Search and map local codebases with semble_rs, find related code and dependencies, run ast-grep structural searches, and digest noisy build/test/CI output. Use for repository exploration and build verification.
---
```

Document these rules concisely:

- Prefer `semble_tree`, `semble_search`, `semble_find_related`, `semble_deps`, and `semble_find_pattern` before built-in `ls`, `find`, or `grep`.
- Use built-ins only when Semble fails or an exact fallback is needed.
- Read only selected result ranges with Pi's `read`.
- Use compact search by default and outline for broad structural scans.
- Enable text files only for documentation/configuration tasks.
- Use `semble_digest` for build/test/install/lint/type-check/CI commands.
- Never use digest for conversation/session compaction.

- [ ] **Step 2: Reload-smoke skill discovery**

Start Pi with only this extension and inspect startup output or command discovery to confirm `semble` is loaded without validation warnings.

### Task 5: Real-Binary Smoke Verification

**Files:**
- Use a temporary fixture only.

- [ ] **Step 1: Create a tiny fixture**

Create a temporary TypeScript project containing two files where one imports and calls a function from the other, plus a function suitable for ast-grep.

- [ ] **Step 2: Exercise direct adapter commands**

Run the exact argument arrays produced for tree, search, find-related, deps, and find-pattern against the fixture. Confirm:

- tree contains files and symbols;
- search returns compact locations;
- related output parses to locations without bodies;
- deps reports the import relationship;
- pattern output parses to locations without bodies.

- [ ] **Step 3: Verify successful digest**

Execute the constructed pipeline with synthetic cargo-like progress. Confirm compile progress is removed and the final status remains.

- [ ] **Step 4: Verify failed digest**

Execute a command that prints cargo-like failure output and exits nonzero through the constructed pipeline. Confirm `pipefail` preserves the nonzero status and the digest retains the failure.

- [ ] **Step 5: Run final checks**

Run:

```bash
cd ~/.config/pi/agent/extensions/semble
node --test adapter.test.ts
pi --no-extensions -e ./index.ts --list-models >/tmp/pi-semble-models.txt
```

Expected: tests pass and Pi exits 0.

Review `git diff --check` for tracked documentation. Extension files remain in the user's intentionally ignored extensions directory; do not modify `.gitignore` or force-add them.
