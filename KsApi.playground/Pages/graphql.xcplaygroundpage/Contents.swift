import PlaygroundSupport
import Foundation
import Argo
import Curry
import Runes
import Prelude
import ReactiveSwift
import Result
import KsApi

struct ProjectPageView<
  P: ProjectType & IdField & FundingRatioField & RewardsField
  where P._RewardType: DescriptionField & IdField & NameField
  > {
  let value: P
}

PlaygroundPage.current.needsIndefiniteExecution = true

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
//    doSomething(with: value.me.backedProjects.first!)
}

let projectQuery = projectPageQuery(slug: "the-jim-henson-exhibition-at-museum-of-the-moving")
(fetch(query: projectQuery) as SignalProducer<ProjectPageQueryResult, ApiError>)
  .startWithResult { result in
    switch result {
    case let .success(value):
      value.project.category.name
      value.project.fundingRatio
      value.project.location.id
      value.project.pledged.amount
      value.project.percentFunded
      value.project.fundingRatio
      value.project.rewards.first?.name
      doSomething(with: value.project)

      dump(ProjectPageView(value: value.project))
//      dump(value)
    case let .failure(error):
      dump(error)
    }
}

"done"
