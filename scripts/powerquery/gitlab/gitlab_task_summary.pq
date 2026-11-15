// =====================================================================
// GitLab Task Summary — Power Query (M)
// Pulls issues, blocked-by/blocks dependencies, and (optionally) task
// hierarchy from a self-managed GitLab instance into refreshable
// Excel tables.
//
// SETUP
// 1. In Excel: Data > Get Data > From Other Sources > Blank Query
// 2. Open the Advanced Editor and paste in ONE of the three sections
//    below at a time (Tasks, Dependencies, Hierarchy), naming each
//    query accordingly. They share the same parameters, so define the
//    parameters once (Data > Get Data > Manage Parameters) or just
//    duplicate the top few "let" lines into each query.
// 3. Load each as a separate table into the workbook data model, then
//    relate them by Task ID (a Data Model / Power Pivot relationship,
//    or plain VLOOKUP/XLOOKUP if you want everything on one sheet).
// =====================================================================


// ---------------------------------------------------------------------
// SHARED PARAMETERS — set these once
// ---------------------------------------------------------------------
BaseUrl = "https://replace.value.here",
ProjectPath = "replace-value-here",   // full namespace path, NOT the numeric ID
Token = "YOUR_PERSONAL_ACCESS_TOKEN",           // ideally an Excel Parameter, not literal text
    // FIXME: Do not go this route! Let's try to find a way that doesn't require tokens stored
EncodedPath = Uri.EscapeDataString(ProjectPath),
AuthHeaders = [#"PRIVATE-TOKEN" = Token],


// =====================================================================
// QUERY 1: "Tasks"  —  all issues in the project (REST API)
// =====================================================================
let
    // NOTE: I honestly don't know where this version came from. Commenting out in favor of the
    // below which I grabbed straight from the initial query output
    //
    // Recursively fetch pages until GitLab returns an empty page
    // GetAllIssues =
    //     List.Generate(
    //         () => [Page = 1, Result = Json.Document(Web.Contents(
    //             BaseUrl,
    //             [
    //                 RelativePath = "/api/v4/projects/" & EncodedPath & "/issues",
    //                 Query = [ per_page = "100", page = "1", state = "all", scope = "all" ],
    //                 Headers = AuthHeaders
    //             ]
    //         ))],
    //         each List.Count([Result]) > 0,
    //         each [
    //             Page = [Page] + 1,
    //             Result = Json.Document(Web.Contents(
    //                 BaseUrl,
    //                 [
    //                     RelativePath = "/api/v4/projects/" & EncodedPath & "/issues",
    //                     Query = [ per_page = "100", page = Text.From([Page] + 1), state = "all", scope = "all" ],
    //                     Headers = AuthHeaders
    //                 ]
    //             ))
    //         ],
    //         each [Result]
    //     ),
    //         AllIssuesFlat = List.Combine(GetAllIssues),
    //         IssuesTable = Table.FromList(AllIssuesFlat, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    //         Expanded = Table.ExpandRecordColumn(IssuesTable, "Column1",
    //             {"iid", "title", "state", "issue_type", "labels", "assignee", "due_date", "web_url", "created_at", "updated_at"},
    //             {"Task ID", "Title", "Status", "Issue Type", "Labels", "Assignee", "Due Date", "URL", "Created", "Updated"}
    //         ),
    //         AssigneeName = Table.TransformColumns(Expanded, {"Assignee", each try _[name] otherwise null}),
    //         LabelsText = Table.TransformColumns(AssigneeName, {"Labels", each Text.Combine(List.Transform(_, Text.From), "; ")}),
    //         Sorted = Table.Sort(LabelsText, {{"Task ID", Order.Ascending}}
    //     )


    // Recursively fetch pages until GitLab returns an empty page
    GetAllIssues =
        List.Generate(
            () => [Page = 1, Result = Json.Document(Web.Contents(
                BaseUrl,
                [
                    RelativePath = "/api/v4/projects/" & EncodedPath & "/issues",
                    Query = [ per_page = "100", page = "1", state = "all", scope = "all" ],
                    Headers = AuthHeaders
                ]
            ))],
            each List.Count([Result]) > 0,
            each [
                Page = [Page] + 1,
                Result = Json.Document(Web.Contents(
                    BaseUrl,
                    [
                        RelativePath = "/api/v4/projects/" & EncodedPath & "/issues",
                        Query = [ per_page = "100", page = Text.From([Page] + 1), state = "all", scope = "all" ],
                        Headers = AuthHeaders
                    ]
                ))
            ],
            each [Result]
        ),

    AllIssuesFlat = List.Combine(GetAllIssues),
    IssuesTable = Table.FromList(AllIssuesFlat, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    Expanded = Table.ExpandRecordColumn(IssuesTable, "Column1",
        {"iid", "title", "state", "issue_type", "labels", "assignee", "due_date", "web_url", "created_at", "updated_at"},
        {"Task ID", "Title", "Status", "Issue Type", "Labels", "Assignee", "Due Date", "URL", "Created", "Updated"}
    ),
    AssigneeName = Table.TransformColumns(Expanded, {"Assignee", each try _[name] otherwise null}),
    LabelsText = Table.TransformColumns(AssigneeName, {"Labels", each Text.Combine(List.Transform(_, Text.From), "; ")}),
    Sorted = Table.Sort(LabelsText, {{"Task ID", Order.Ascending}})

in
    Sorted


// =====================================================================
// QUERY 2: "Dependencies"  —  blocked-by / blocks links (REST API)
// Calls GET /issues/:iid/links per issue — fine for hundreds of
// issues, but consider filtering Tasks to "opened" state first if
// your project has thousands of closed issues you don't need linked.
// =====================================================================
let
    // Reuse Query 1's Task ID list (reference it here, or paste GetAllIssues again)
    TaskIds = Tasks[Task ID],   // <-- references the "Tasks" query above by name

    GetLinks = (iid as number) as list =>
        let
            Response = try Json.Document(Web.Contents(
                BaseUrl,
                [
                    RelativePath = "/api/v4/projects/" & EncodedPath & "/issues/" & Text.From(iid) & "/links",
                    Headers = AuthHeaders
                ]
            )) otherwise {}
        in
    if Response is list then Response else {},

    LinksByTask = List.Transform(TaskIds, each [SourceID = _, Links = GetLinks(_)]),
    ToTable = Table.FromRecords(LinksByTask),
    ExpandedLinks = Table.ExpandListColumn(ToTable, "Links"),
    FilteredNulls = Table.SelectRows(ExpandedLinks, each [Links] <> null),
    ExpandLinkFields = Table.ExpandRecordColumn(FilteredNulls, "Links", {"iid", "title", "link_type"}, {"Target ID", "Target Title", "Link Type"}),
    // Keep only the "blocking" direction so each dependency reads naturally as
    // "Source Task is blocked by Target Task"
    BlockedOnly = Table.SelectRows(ExpandLinkFields, each [Link Type] = "is_blocked_by"),
    Renamed = Table.RenameColumns(BlockedOnly, {{"SourceID", "Task ID"}, {"Target ID", "Blocked By Task ID"}, {"Target Title", "Blocked By Title"}})
in
    Renamed


// =====================================================================
// QUERY 3: "Hierarchy"  —  parent/child task structure (GraphQL API)
// REST does not expose this, so this hits GitLab's GraphQL endpoint
// instead. VERIFY field names against your instance's GraphiQL
// explorer first — the Work Items schema has changed across GitLab
// versions and Premium/Ultimate feature flags can affect availability.
//   https://git.guernsey.us/-/graphql-explorer
// =====================================================================
let
    GraphQLQuery = "
        query($fullPath: ID!, $after: String) {
          project(fullPath: $fullPath) {
            workItems(first: 100, after: $after) {
              pageInfo { hasNextPage endCursor }
              nodes {
                id
                iid
                title
                workItemType { name }
                widgets {
                  type
                  ... on WorkItemWidgetHierarchy {
                    parent { iid title }
                  }
                }
              }
            }
          }
        }
    ",

    CallGraphQL = (afterCursor as nullable text) =>
        let
            Body = Json.FromValue([
                query = GraphQLQuery,
                variables = [ fullPath = ProjectPath, after = afterCursor ]
            ]),
            Response = Json.Document(Web.Contents(
                BaseUrl,
                [
                    RelativePath = "/api/graphql",
                    Headers = AuthHeaders & [#"Content-Type" = "application/json"],
                    Content = Body
                ]
            ))
        in
    Response[data][project][workItems],

    // Single page to start — extend with List.Generate + pageInfo.hasNextPage
    // once you've confirmed the field names work against your instance.
    FirstPage = CallGraphQL(null),
    Nodes = FirstPage[nodes],
    NodesTable = Table.FromRecords(Nodes),
    ExpandedType = Table.ExpandRecordColumn(NodesTable, "workItemType", {"name"}, {"Item Type"}),
    ExpandedWidgets = Table.TransformColumns(ExpandedType, {"widgets", each
        let
            HierarchyWidget = List.First(List.Select(_, each [type] = "HIERARCHY"), null)
        in
            if HierarchyWidget = null then null else try HierarchyWidget[parent][iid] otherwise null
    }),
    Renamed = Table.RenameColumns(ExpandedWidgets, {{"iid", "Task ID"}, {"title", "Title"}, {"widgets", "Parent Task ID"}})
in
    Renamed


// ---

// Alternate approach that better hides the secrete credential stuff, relies on the data source
// settings within PQ for the user to input the API key which means it is not stored anywhere within
// the file or query.
// Got here through Perplexity modifying the above code from good ole Claude
// Broken out into four separate queries
//
// I anticipate some of it can be streamlined further by using params for the URL's and paths
BaseUrl = "https://git.guernsey.us",
ProjectPath = "group/subgroup/project",
EncodedPath = "group%2Fsubgroup%2Fproject"
AuthHeaders = ??? (This may be a way to futher streamline the graphql side of things -- I'm not sure yet what all it would require)

let
    GitLabGetJson = (relativePath as text, optional query as nullable record) as any =>
        Json.Document(
            Web.Contents(
                BaseUrl,
                [
                    RelativePath = relativePath,
                    Query = if query = null then [] else query,
                    ApiKeyName = "private_token"
                ]
            )
        )
in
    GitLabGetJson

// ---

let
    GetIssuesPage = (page as number) as list =>
        let
            Response = GitLabGetJson(
                "/api/v4/projects/" & EncodedPath & "/issues",
                [
                    per_page = "100",
                    page = Text.From(page),
                    state = "all",
                    scope = "all"
                ]
            )
        in
    if Response is list then Response else {},

    Pages =
        List.Generate(
            () => [Page = 1, Result = GetIssuesPage(1)],
            each List.Count([Result]) > 0,
            each [Page = [Page] + 1, Result = GetIssuesPage([Page] + 1)],
            each [Result]
        ),

    AllIssuesFlat = List.Combine(Pages),
    IssuesTable = Table.FromList(AllIssuesFlat, Splitter.SplitByNothing(), null, null, ExtraValues.Error),

    Expanded = Table.ExpandRecordColumn(
        IssuesTable,
        "Column1",
        {"iid", "title", "state", "issue_type", "labels", "assignee", "due_date", "web_url", "created_at", "updated_at"},
        {"Task ID", "Title", "Status", "Issue Type", "Labels", "Assignee", "Due Date", "URL", "Created", "Updated"}
    ),

    AssigneeName = Table.TransformColumns(
        Expanded,
        {{"Assignee", each try _[name] otherwise null, type nullable text}}
    ),

    LabelsText = Table.TransformColumns(
        AssigneeName,
        {{"Labels", each try Text.Combine(List.Transform(_, Text.From), "; ") otherwise null, type nullable text}}
    ),

    Sorted = Table.Sort(LabelsText, {{"Task ID", Order.Ascending}})
in
    Sorted

// ---

let
    TaskIds = Tasks[Task ID],

    GetLinks = (iid as number) as list =>
        let
            Response = try GitLabGetJson(
                "/api/v4/projects/" & EncodedPath & "/issues/" & Text.From(iid) & "/links"
            ) otherwise {}
        in
    if Response is list then Response else {},

    LinksByTask = List.Transform(TaskIds, each [SourceID = _, Links = GetLinks(_)]),
    ToTable = Table.FromRecords(LinksByTask),
    ExpandedLinks = Table.ExpandListColumn(ToTable, "Links"),
    FilteredNulls = Table.SelectRows(ExpandedLinks, each [Links] <> null),

    ExpandLinkFields = Table.ExpandRecordColumn(
        FilteredNulls,
        "Links",
        {"iid", "title", "link_type"},
        {"Target ID", "Target Title", "Link Type"}
    ),

    BlockedOnly = Table.SelectRows(ExpandLinkFields, each [Link Type] = "is_blocked_by"),

    Renamed = Table.RenameColumns(
        BlockedOnly,
        {{"SourceID", "Task ID"}, {"Target ID", "Blocked By Task ID"}, {"Target Title", "Blocked By Title"}}
    )
in
    Renamed

// ---

let
    GraphQLQuery = "
        query($fullPath: ID!, $after: String) {
          project(fullPath: $fullPath) {
            workItems(first: 100, after: $after) {
              pageInfo { hasNextPage endCursor }
              nodes {
                id
                iid
                title
                workItemType { name }
                widgets {
                  type
                  ... on WorkItemWidgetHierarchy {
                    parent { iid title }
                  }
                }
              }
            }
          }
        }
    ",

    CallGraphQL = (afterCursor as nullable text) =>
        let
            Body = Json.FromValue([
                query = GraphQLQuery,
                variables = [ fullPath = ProjectPath, after = afterCursor ]
            ]),
            Response = Json.Document(
                Web.Contents(
                    BaseUrl,
                    [
                        RelativePath = "/api/graphql",
                        Headers = AuthHeaders & [#"Content-Type" = "application/json"],
                        Content = Body
                    ]
                )
            )
        in
    Response[data][project][workItems],

    FirstPage = CallGraphQL(null),
    Nodes = FirstPage[nodes],
    NodesTable = Table.FromRecords(Nodes),

    ExpandedType = Table.ExpandRecordColumn(
        NodesTable,
        "workItemType",
        {"name"},
        {"Item Type"}
    ),

    ParentTaskId = Table.AddColumn(
        ExpandedType,
        "Parent Task ID",
        each
            let
                widgets = try [widgets] otherwise null,
                hierarchyWidget =
                    if widgets = null then
                        null
                    else
                        List.First(List.Select(widgets, each [type] = "HIERARCHY"), null)
            in
                if hierarchyWidget = null then null else try hierarchyWidget[parent][iid] otherwise null,
        type nullable text
    ),

    Renamed = Table.RenameColumns(
        ParentTaskId,
        {{"iid", "Task ID"}, {"title", "Title"}}
    )
in
    Renamed
