import PlaygroundSupport
import Foundation
import Argo
import Curry
import Runes
import Prelude
import ReactiveSwift
import Result
import KsApi

PlaygroundPage.current.needsIndefiniteExecution = true

func doSomething <P: ProjectType & IdField & FundingRatioField> (with project: P) {
}

func doSomething <C: CategoryType & IdField & NameField & ProjectsField & SubcategoriesField> (with cs: [C])
  where C._CategoryType: IdField & NameField, C._ProjectsType: TotalCountField {
}


(fetch(query: startupQuery) as SignalProducer<StartUpQueryResult, ApiError>)
  .startWithResult { result in
    guard let value = result.value else {
      print(result.error!)
      return
    }

    dump(value)
    doSomething(with: value.rootCategories)
    value.rootCategories.first?.projects.totalCount
}

(fetch(query: profileQuery) as SignalProducer<ProfileQueryResult, ApiError>)
  .startWithResult { result in
    guard let value = result.value else {
      print(result.error!)
      return
    }

    dump(value)
    doSomething(with: value.me.backedProjects.first!)
}

let projectQuery = projectPageQuery(slug: "the-jim-henson-exhibition-at-museum-of-the-moving")
(fetch(query: projectQuery) as SignalProducer<ProjectPageQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      value.project.category.name
      dump(value)
    case let .failure(error):
      dump(error)
    }
}

"done"
