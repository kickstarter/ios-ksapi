public let startupQuery: Set<Query> = [
  .rootCategories(
    [
      .id,
      .name,
      .subcategories(
        [
          .id,
          .name
        ]
      ),
      .projects(state: .LIVE, [.totalCount], .nodes([]))
    ]
  ),
  .supportedCountries(
    [
      .code,
      .name
    ]
  )
]
