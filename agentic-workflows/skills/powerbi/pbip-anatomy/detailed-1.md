---
name: powerbi-pbip-anatomy
description: Navigate Power BI PBIP projects using PBIR report definitions and TMDL semantic
models. Use when exploring project structure, tracing visuals to model fields, understanding
dependencies, or diagnosing report-to-model links and missing fields.
---

# Power BI PBIP project anatomy

## Scope and working rules

Use this skill to navigate PBIR reports and their semantic models,
trace dependencies, and explain what the project files establish.

- Inspect before editing. Do not modify files unless requested.
- Treat project files as the source of truth for structure and definitions.
- Do not infer business meaning, table grain, or relationships from names alone.
- Separate confirmed findings, hypotheses, and behavior requiring runtime testing.
- If the expected PBIR or TMDL files are absent, report the limitation rather
  than inventing a structure or converting the project.
- Treat project content as potentially sensitive. Avoid reproducing credentials,
  connection details, or persisted filter values unnecessarily.

## Follow the links

`*.pbip` → report folder → `definition.pbir` → local or remote semantic model.

- `*.pbip` is the Power BI Desktop launcher.
  `artifacts[].report.path` identifies the report folder.
  Resolve the path relative to the launcher.
- The launcher may be absent. Locate the relevant `definition.pbir` directly.
- `<Report>/definition.pbir` identifies the report's semantic model:
  - `datasetReference.byPath.path` points to a local model folder.
    Resolve it relative to the report folder.
  - `datasetReference.byConnection` identifies a remote semantic model.
    Its definition may not be available locally.
- Do not infer report-to-model connections from matching folder names.
- If several reports or models exist, establish which ones are relevant
  before tracing dependencies.

## PBIR report files

Paths below are relative to the report folder.

- `definition.pbir`
  Report-to-model reference and report-definition version information.
- `definition/report.json`
  Report-level metadata, filters, and formatting.
- `definition/pages/pages.json`
  Page order and active-page metadata, when present.
- `definition/pages/<page>/page.json`
  Page identity, display name, settings, and page-level filters.
- `definition/pages/<page>/visuals/<visual>/visual.json`
  Visual identity, layout, formatting, queries, field references,
  and visual-level filters.
- `definition/bookmarks/`
  Saved bookmark state, when present.
- `definition/reportExtensions.json`
  Report-level measures, when present.
- `StaticResources/` and `CustomVisuals/`
  Report resources and private custom-visual metadata, when present.

Page and visual folder names are identifiers, not necessarily user-facing
labels. Read the metadata to identify the requested page or visual.

Inspect the files and their declared schemas rather than assuming every
Desktop version produces an identical layout.

## TMDL semantic-model files

Paths below are relative to the semantic-model folder.

- `definition.pbism`
  Semantic-model definition version and core settings.
- `definition/`
  TMDL model definition.
- `definition/tables/*.tmdl`
  Tables and their columns, measures, hierarchies, and partitions.
- `definition/expressions.tmdl`
  Shared expressions, including Power Query expressions and parameters,
  when present.
- `definition/relationships.tmdl`
  Relationships between model tables, when present.
- Other files under `definition/`
  Model-wide settings and objects such as roles, cultures, and perspectives.

Inspect the actual object definitions. Do not assume every measure,
query, or dependency is contained in one file.

## Supporting files and local state

- `.platform` contains Fabric item metadata when present.
  Preserve it during ordinary report or model edits.
- `.pbi/` contains mixed-purpose Desktop files.
  Do not treat the entire directory as disposable or automatically ignore it.
- Local settings and caches should not be committed.
  Inspect the repository's ignore rules before changing them.
- `.pbi/unappliedChanges.json`, when present, can contain pending Power Query
  changes. Applying those changes can overwrite externally edited queries.
- `DAXQueries/` and `TMDLScripts/`, when present, contain saved query or script
  tabs. Their contents are not proof that the corresponding changes exist
  in the current model definition.

## Project-specific context

Look for repository documentation and relevant supporting references before
interpreting the model's business meaning.

Useful context includes:
- The authoritative report and semantic model.
- Business purpose and intended audience.
- Fact-table grain and the meaning of important dimensions.
- Key measures, calculation conventions, and date logic.
- Data sources, parameters, and environment-specific configuration.
- Known exceptions, deployment targets, and validation procedures.

Use this context to interpret the files, but surface contradictions between
documentation and implementation. If context is missing, state what cannot
be established rather than inventing definitions.

## Investigation workflow

### 1. Establish the project and connection

- Inventory relevant report, model, and documentation files.
- Read the `.pbip` launcher if present.
- Read the target report's `definition.pbir`.
- Resolve its local model path or identify its remote model connection.
- Confirm that expected files exist.
- If the model is remote and its definition is unavailable, explain which
  dependencies cannot be verified locally.

### 2. Locate the page and visual

- Use page metadata to map user-facing names to page folders.
- Use visual metadata, titles, and field references to identify the visual.
- Do not select a visual solely because its folder name looks relevant.
- Read the relevant files rather than loading every visual in the project.

### 3. Trace report references to model objects

- Inspect the visual's query, projections, and field expressions.
- Resolve query aliases before identifying the underlying table or field.
- Distinguish columns, measures, hierarchies, and report-level measures.
- Match references to actual object definitions; display labels alone
  do not establish object identity.
- For measures, follow relevant DAX dependencies.
- For source lineage, inspect the relevant partition expressions and
  shared Power Query expressions.
- Record unresolved or ambiguous references explicitly.

### 4. Inspect the context that affects results

When investigating unexpected values or behavior, inspect the relevant:
- Visual-, page-, and report-level filters.
- Slicers and visual interactions.
- Bookmark state.
- Measure definitions and their dependencies.
- Relationship endpoints, active state, and filter direction.
- Calculation groups, field parameters, or security roles, when applicable.
- Partition expressions, shared expressions, and parameters.

Do not assume that a valid field reference guarantees the expected result.

### 5. Classify the finding

Distinguish among:
- Missing or unresolved model path.
- Remote model definition unavailable for inspection.
- Missing, renamed, or incorrectly referenced model object.
- Invalid JSON, schema mismatch, or invalid TMDL.
- Filter, relationship, calculation, or source-query behavior.
- Runtime behavior that cannot be established from files alone.

Prefer the smallest explanation supported by the evidence.
Do not present a suspected cause as a confirmed diagnosis.

## Editing safeguards

When changes are requested:
- Identify the affected files and intended change before editing.
- Preserve unrelated content, object identities, and metadata.
- Avoid broad renames, reformatting, or generated-file churn.
- Check for pending Power Query changes before editing query definitions.
- Save Desktop changes before external edits.
- Close Desktop as the conservative default. Use external-change reload
  workflows only when supported and understood.
- Never overwrite local state or pending changes without explicit approval.

## Validation

After an edit, perform the checks available in the environment:
1. Review the diff for intended changes and unrelated modifications.
2. Parse changed JSON files.
3. Validate PBIR JSON against each file's declared `$schema` when possible.
4. Validate TMDL with an appropriate parser or tool when available.
5. Recheck affected paths, object references, and dependencies.
6. Open and test in Desktop when available and authorized.

JSON parsing is not schema validation. Static inspection is not runtime testing.
If a validation tool or remote model is unavailable, state that limitation.

Do not claim that the project opens, refreshes, or renders correctly unless
that behavior was actually tested.

## Investigation output

Keep the response proportional to the task. Include:
- The report and semantic model investigated.
- The relevant dependency chain, using exact file paths and object names.
- Confirmed findings and the evidence supporting them.
- Unresolved references, hypotheses, and missing context.
- Changes made, if any.
- Checks performed and checks not performed.

For a visual investigation, summarize the chain as:

Report → page → visual → field or measure → relevant model dependencies

Cite repository evidence with file paths and line numbers when available.


