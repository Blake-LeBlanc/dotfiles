---
name: powerbi-pbip-anatomy
description: explain how files in a power bi pbip project connect. use when navigating a pbip folder, tracing visuals to model fields, or diagnosing a broken report-to-model link.
---

# Power BI PBIP project anatomy

## 1. Understand the project structure

A Power BI project consists of separate report and semantic model artifacts.

Typical structure:

```text
Project/
├── Project.pbip
├── Project.Report/
│   ├── definition.pbir
│   ├── definition/
│   │   ├── report.json
│   │   ├── version.json
│   │   ├── pages/
│   │   └── bookmarks/
│   ├── StaticResources/
│   ├── CustomVisuals/
│   └── .pbi/
└── Project.SemanticModel/
    ├── definition.pbism
    └── definition/
        ├── database.tmdl
        ├── model.tmdl
        ├── relationships.tmdl
        ├── expressions.tmdl
        ├── tables/
        ├── roles/
        ├── cultures/
        └── perspectives/
```

Actual contents vary by Power BI Desktop version, project configuration, and enabled features.

### Follow the links

`*.pbip` → `*.Report/definition.pbir` → local `*.SemanticModel/` or remote semantic model.

- **`*.pbip`** is the Power BI Desktop launcher. Its `artifacts[].report.path` identifies the report folder.
- **`*.Report/definition.pbir`** links the report to its semantic model.
  - `datasetReference.byPath.path` points to a local semantic model folder.
  - `datasetReference.byConnection` identifies a published semantic model.
  - A report using `byConnection` may not have a local semantic model.
- **`*.SemanticModel/definition.pbism`** contains semantic model format settings.
- **`*.Report/definition/`** contains the granular PBIR report definition.
- **`*.Report/report.json`** may be present in older PBIR-Legacy projects instead of the granular report definition.

The `.pbip` file is not necessarily the complete project inventory. Discover all report and semantic model folders before assuming their relationships.

## 2. Report anatomy (PBIR)

Within `*.Report/definition/`:

- `report.json` — report-level configuration.
- `version.json` — report definition version.
- `pages/pages.json` — page listing and ordering.
- `pages/<page>/page.json` — individual page configuration.
- `pages/<page>/visuals/<visual>/visual.json` — visual configuration, query definitions, and field references.
- `bookmarks/` — bookmark definitions and collections.

Each visual has its own JSON definition.

When investigating a visual, examine:

1. Visual type and configuration.
2. Position, size, and layout.
3. Visual query and projections.
4. Referenced tables, columns, measures, and aggregations.
5. Filters and sorting.
6. Conditional formatting and formatting expressions.
7. Interactions with other visuals where relevant.

Do not assume that visual folder names are meaningful. Use the identifiers and metadata inside the JSON files.

### Tracing visual fields

Visual queries can reference model objects through different structures.

Common references include:

- Table entities.
- Column properties.
- Measures.
- Aggregations.
- Hierarchies.
- Field parameters.

Trace each reference to its corresponding semantic model definition.

Do not rely exclusively on display names. Distinguish between internal object names, display names, and identifiers.

A field parameter may dynamically select a measure or column. In these cases, inspect the field parameter definition and the measures or columns it references.

## 3. Semantic model anatomy (TMDL)

Within `*.SemanticModel/definition/`:

- `database.tmdl` — database metadata.
- `model.tmdl` — model-level configuration.
- `relationships.tmdl` — relationships between tables.
- `expressions.tmdl` — shared Power Query expressions and parameters.
- `tables/*.tmdl` — table definitions, including columns, measures, hierarchies, partitions, and other table metadata.
- `roles/` — row-level security definitions.
- `cultures/` — linguistic metadata and translations.
- `perspectives/` — perspective definitions.

Not every project contains every file or folder.

### DAX measures

Measures are defined within table TMDL files.

When investigating a measure, identify:

- Its table.
- Its internal name and display folder, if applicable.
- Its DAX expression.
- Its format string.
- Its description and annotations, if present.
- Other measures it references.

Follow measure dependencies recursively when investigating calculations.

Pay particular attention to:
- `CALCULATE` and filter context.
- `FILTER`, `ALL`, `ALLSELECTED`, and related functions.
- `USERELATIONSHIP` and relationship manipulation.
- `SELECTEDVALUE` and disconnected selector tables.
- Calculation groups.
- Field parameters.
- Dynamic format strings.

Do not assume a measure's result can be understood from its expression alone. Consider the model relationships and filter context.

### Relationships

Inspect `relationships.tmdl` to understand:

- From and to tables and columns.
- Cardinality.
- Cross-filter direction.
- Active versus inactive relationships.
- Referential integrity settings.

When tracing a visual or measure, consider how filters propagate through the relationship network.

### Power Query

Inspect `expressions.tmdl` and table partitions to understand the data preparation layer.

Trace:

- Shared queries and parameters.
- Table partition source expressions.
- Query references and dependencies.
- Data source definitions.
- M transformations.

Follow referenced queries until reaching their underlying data sources.

Distinguish between Power Query transformations and DAX calculations. They operate at different stages of the data lifecycle.

## 4. Investigation workflow

When asked to understand or investigate a Power BI project, follow this workflow.

### Step 1: Inventory the project

- Identify the project root.
- Enumerate all report and semantic model folders.
- Identify PBIR versus PBIR-Legacy report definitions.
- Identify TMDL versus alternative semantic model formats.
- Identify local versus remote semantic model connections.

Do not assume a standard folder structure.

### Step 2: Establish report-to-model relationships

- Read the `.pbip` file if present.
- Read each report's `definition.pbir`.
- Resolve local model paths relative to the report folder.
- Identify remote connections.
- Determine which reports use which semantic models.

### Step 3: Understand the report

- Read `pages/pages.json` to establish page order.
- Inspect individual `page.json` files.
- Enumerate visuals on each page.
- Inspect relevant `visual.json` files.
- Identify visual types, fields, measures, filters, and sorting.

When asked about a particular visual, trace its references rather than reading every visual indiscriminately.

### Step 4: Trace model dependencies

For each relevant visual:

1. Identify its referenced model fields.
2. Locate their definitions in the TMDL files.
3. Identify associated measures and their DAX expressions.
4. Follow dependent measures.
5. Inspect relevant relationships.
6. Check field parameters and calculation groups where applicable.
7. Inspect Power Query definitions if the question involves data sourcing or transformations.

### Step 5: Report findings

Explain the relevant chain of dependencies.

For example:

```text
Report Page
  └── Visual
      └── Model Measure
          ├── Dependent Measure
          ├── Related Tables
          └── Filter Context
              └── Power Query Source
```

Be specific about file paths and object names so findings can be independently verified.

## 5. General investigation guidelines

- Inspect the files that actually exist. Project layouts and schemas vary by Desktop version.
- Use the JSON schema declarations in PBIR files when interpreting unfamiliar structures.
- Treat identifiers and internal names as more reliable than folder names or display labels.
- Do not assume similarly named objects are interchangeable.
- Distinguish between model objects that exist and objects actually referenced by a report.
- Do not assume a visual's current appearance can be determined from its JSON definition alone. Runtime filters, slicers, bookmarks, interactions, and user selections may affect the result.
- Distinguish between confirmed findings and inferred behavior.
- When information is missing, identify the missing artifact rather than inventing a dependency.
- Prefer targeted inspection over indiscriminately reading every file.
- Preserve existing formatting and conventions when proposing code changes.
- Do not modify project files unless explicitly requested.
- Before external modifications, understand the affected artifacts and their dependencies.
- Close Power BI Desktop before externally editing project files.

## 6. Additional resources

Microsoft documentation:

- Power BI Desktop projects: https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-overview
- Report folder and PBIR format: https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-report
- Semantic model folder: https://learn.microsoft.com/en-us/power-bi/developer/projects/projects-dataset
- PBIR JSON schemas: https://github.com/microsoft/powerbi-desktop-samples/tree/main/item-schemas

