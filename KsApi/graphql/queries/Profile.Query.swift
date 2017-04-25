public func profileQuery(endCursor: String? = nil) -> Set<Query> {
  let args = endCursor.map(QueryArg.after).map { Set.init(arrayLiteral: $0) } ?? []
  return [
    .me(
      [
        .backedProjects(
          args: args,
          pageInfo: [
            .endCursor,
            .hasNextPage
          ],
          nodes: [
            .deadlineAt,
            .id,
            .fundingRatio,
            .imageUrl(blur: false, width: 300),
            .name,
            .state
          ]
        ),
        .id,
        .name,
        .imageUrl(width: 300),
        .location(
          [
            .id,
            .name
          ]
        )
      ]
    )
  ]
}
