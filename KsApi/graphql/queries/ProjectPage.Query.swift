public func projectPageQuery(slug: String) -> Set<Query> {

  return [
    .project(
      slug: slug,
      [
        .canceledAt,
        .category(
          [
            .id,
            .name
          ]
        ),
        .deadlineAt,
        .description,
        .fundingRatio,
        .goal(
          [
            .amount,
            .currency
          ]
        ),
        .id,
        .imageUrl(blur: false, width: 500),
        .isProjectWeLove,
        .location(
          [
            .id,
            .name
          ]
        ),
        .name,
        .percentFunded,
        .pledged(
          [
            .amount,
            .currency
          ]
        ),
        .rewards(
          [
            .id,
            .description,
            .name,
          ]
        ),
        .slug,
        .state,
        .updates(
          [
            .totalCount
          ]
        ),
        .url
      ]
    )
  ]
}

//{
//  project(slug: "the-jim-henson-exhibition-at-museum-of-the-moving") {
//    backers {
//      totalCount
//    }
//    canceledAt
//    category {
//      id
//      name
//    }
//    deadlineAt
//    description
//    fundingRatio
//    goal {
//      amount
//      currency
//    }
//    id
//    imageUrl(width:500)
//    isProjectWeLove
//    location {
//      id
//      name
//    }
//    name
//    percentFunded
//    pledged {
//      amount
//      currency
//    }
//    rewards {
//      nodes {
//        id
//        name
//        description
//      }
//    }
//    slug
//    state
//    updates {
//      totalCount
//    }
//    url
//  }
//}
//
