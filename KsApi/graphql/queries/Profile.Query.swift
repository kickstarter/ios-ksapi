public let profileQuery: Set<Query> = [
  .me(
    [
      .backedProjects(
        [
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
