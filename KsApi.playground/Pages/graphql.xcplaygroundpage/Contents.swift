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

(fetch(query: profileQuery) as SignalProducer<ProfileQueryResult, ApiError>)
  .startWithResult { result in
    
    dump(result)
    (result.value?.me.backedProjects.first).doIfSome(configureWith(project:))
}

func configureWith <P: ProjectType & NameField & ImageUrlField> (project: P) {
  project.imageUrl
  project.name
}

"done"

