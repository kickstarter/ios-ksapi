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
      .projects(state: .LIVE, [.totalCount], [])
    ]
  ),
  .supportedCountries(
    [
      .code,
      .name
    ]
  )
]
