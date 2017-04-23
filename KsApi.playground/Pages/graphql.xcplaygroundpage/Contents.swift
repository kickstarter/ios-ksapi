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

Query.build(profileQuery)

//(fetch(query: profileQuery) as SignalProducer<ProfileQueryResult, ApiError>)
//  .startWithResult { result in
//
//    dump(result)
//}

func doSomething(project: ProjectType & IdField & NameField) {

}

(fetch(query: projectPageQuery(slug: "inventory-the-consumptive-3")) as SignalProducer<ProjectPageQueryResult, ApiError>)
  .startWithResult { result in
    
    dump(result)
}

"done"

