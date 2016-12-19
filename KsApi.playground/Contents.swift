import XCPlayground
import KsApi
import Prelude
import ReactiveCocoa
import Result

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let service = Service.init(
  serverConfig: ServerConfig.production,
  //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
  language: "en"
)

let categories = service.fetchCategories()
  .flatMap(.Concat) { SignalProducer<KsApi.Category, ErrorEnvelope>(values: $0) }
  .filter { c in c.isRoot }
  .replayLazily(1)

categories
  .map { c in c.name }
  .startWithNext { c in
    print("Root category ----> \(c)")
}

// Get the most popular project in each category above.
categories
  .map {
    DiscoveryParams.defaults
      |> DiscoveryParams.lens.category .~ $0
      <> DiscoveryParams.lens.sort .~ .Popular
      <> DiscoveryParams.lens.perPage .~ 1
  }
  .flatMap(.Merge, transform: service.fetchProject)
  .map { p in p.name }
  .startWithNext { name in
    print("Project -----> \(name)")
}

// Get a few recent activities and print out the name of the user that created the activity.
// This only works if you uncomment `oauthToken` above and put in a valid token.
service.fetchActivities()
  .flatMap(.Concat) { SignalProducer<Activity, ErrorEnvelope>(values: $0.activities) }
  .map { $0.user?.name }
  .skipNil()
  .startWithNext { name in
    print("Activity user's name: \(name)")
}
