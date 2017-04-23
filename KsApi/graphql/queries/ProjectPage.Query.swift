public func projectPageQuery(slug: String) -> Set<Query> {

  return [
    .project(
      slug: slug,
      [
        .id,
        .name
      ]
    )
  ]
}
