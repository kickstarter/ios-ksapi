import PlaygroundSupport
import Foundation
import Argo
import Curry
import Runes
import Prelude
import ReactiveSwift
import Result
import KsApi

func doSomething <
  C: CategoryType
  & IdField
  & NameField
  & CategoryProjectsConnectionField
  & CategorySubcategoriesConnectionField>
  (categories: [C])
  where C._CategoryProjectsConnectionType: TotalCountField,
  C._CategorySubcategoriesConnectionType: CategoryNodesField,
  C._CategorySubcategoriesConnectionType._CategoryType: IdField & NameField
{
  categories
  categories.first?.projects.totalCount
}


PlaygroundPage.current.needsIndefiniteExecution = true

(fetch(query: startupQuery) as SignalProducer<StartUpQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      dump(value)
    case let .failure(error):
      dump(error)
    }
}

(fetch(query: profileQuery()) as SignalProducer<ProfileQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      value.me.backedProjects.nodes
      value.me.backedProjects.pageInfo.endCursor
      dump(value)
    case let .failure(error):
      dump(error)
    }
}

(fetch(query: categoriesQuery) as SignalProducer<CategoriesQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      doSomething(categories: value.rootCategories)
      dump(value)
    case let .failure(error):
      dump(error)
    }
}

let projectQuery = projectPageQuery(slug: "the-jim-henson-exhibition-at-museum-of-the-moving")
(fetch(query: projectQuery) as SignalProducer<ProjectPageQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      dump(value)
    case let .failure(error):
      dump(error)
    }
}

"done"
