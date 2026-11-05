---
name: powerbi-pbip-anatomy
description: explain how files in a power bi pbip project connect. use when navigating a pbip folder, tracing visuals to model fields, or diagnosing a broken report-to-model link.
---

# power bi pbip project anatomy
## follow the links

`*.pbip` → `*.report/definition.pbir` → local `*.semanticmodel/` or a remote semantic model.

- **`*.pbip`** is the power bi desktop launcher. its `artifacts[].report.path` identifies the report folder.
- **`*.report/definition.pbir`** links the report to its model. `datasetreference.bypath.path` points to a local model folder; `byconnection` points to a published model. a report using `byconnection` may have no local model folder.
- **`*.report/definition/`** is the granular pbir report. `pages/pages.json` orders pages; each page has `page.json` and `visuals/<visual>/visual.json`. visual files contain layout and references to model fields. older pbir-legacy reports use a root-level `report.json` instead.
- **`*.semanticmodel/definition.pbism`** records model format settings. in tmdl models, `definition/` contains:
  - `tables/*.tmdl` — tables, columns, measures, and partitions
  - `expressions.tmdl` — shared power query queries and parameters
  - `relationships.tmdl` — relationships between tables
- **other files:** `.platform` contains fabric item metadata when present. `staticresources/` and `customvisuals/` hold report assets. `.pbi/` contains desktop support files; do not commit local settings or caches.

## when investigating a project

1. read the `.pbip` file to locate the report.
2. read `definition.pbir` to find its local or remote model.
3. trace field references in a `visual.json` to the model’s tables, columns, and measures. names must match.
4. if something is broken, check the model path or connection, field names, and file validity.

inspect the files that actually exist: layouts and schemas vary by power bi desktop version. close desktop before editing project files externally.

