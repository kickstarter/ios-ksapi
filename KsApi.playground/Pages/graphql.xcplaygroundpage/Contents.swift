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

func doSomething <P: ProjectType & IdField> (with project: P) {

}

Query.build(profileQuery)

(fetch(query: profileQuery) as SignalProducer<ProfileQueryResult, ApiError>)
  .startWithResult { result in
    guard let value = result.value else { return }

    dump(result)
    doSomething(with: value.me.backedProjects.first!)
}

"done"
