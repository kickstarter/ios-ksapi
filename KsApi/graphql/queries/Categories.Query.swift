public let categoriesQuery: Set<Query> = [
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
  )
]
