import ReactiveSwift
import KsApi
import Result

// Java: Observerable
//       "hot"  ~> Signal
//       "cold" ~> SignalProducer

// Signal
// SignalProducer

let (signal, observer) = Signal<Int, NoError>.pipe()
let property = MutableProperty<Int?>(nil)

observer.send(value: 0)
observer.send(value: 1)
observer.send(value: 2)
property.value = 0
property.value = 1
property.value = 2

signal
  .map { $0 + 1 }
  .filter { $0 % 2 == 0 }
  .observeValues { print($0) }

property.signal
  .skipNil()
  .map { $0 + 1 }
  .filter { $0 % 2 == 0 }
  .observeValues { print("property: \($0)") }

signal.take(last: <#T##Int#>)
signal.take(first: <#T##Int#>)
signal.skip(first: <#T##Int#>)
signal.skip(last: <#T##Int#>)
property.signal.skipNil()
Event

observer.send(value: 1)
observer.send(value: 50)
property.value = 1
property.value = 50





let (signalA, observerA) = Signal<Int, NoError>.pipe()
let (signalB, observerB) = Signal<Int, NoError>.pipe()
let (signalC, observerC) = Signal<Int, NoError>.pipe()

Signal.merge(
  signalA,
  signalB
  )
  .observeValues { print("merge: \($0)") }

Signal.combineLatest(
  signalA,
  signalB,
  signalC
  )
  .observeValues { print("combineLatest: \($0)") }

Signal.zip(signalA, signalB)
  .observeValues { print("zip: \($0)") }

// zip: (2, 5)
// zip: (3, 10)

observerA.send(value: 2)
observerB.send(value: 5)
observerA.send(value: 3)
observerB.send(value: 10)


observerC.send(value: 23)





















































//import XCPlayground
//import KsApi
//import Prelude
//import ReactiveCocoa
//import Result
//
//XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//
//let service = Service.init(
//  serverConfig: ServerConfig.production,
//  //oauthToken: OauthToken.init(token: "uncomment and put in your token!"),
//  language: "en"
//)
//
//let categories = service.fetchCategories()
//  .flatMap(.Concat) { SignalProducer<KsApi.Category, ErrorEnvelope>(values: $0) }
//  .filter { c in c.isRoot }
//  .replayLazily(1)
//
//categories
//  .map { c in c.name }
//  .startWithNext { c in
//    print("Root category ----> \(c)")
//}
//
//// Get the most popular project in each category above.
//categories
//  .map {
//    DiscoveryParams.defaults
//      |> DiscoveryParams.lens.category .~ $0
//      <> DiscoveryParams.lens.sort .~ .Popular
//      <> DiscoveryParams.lens.perPage .~ 1
//  }
//  .flatMap(.Merge, transform: service.fetchProject)
//  .map { p in p.name }
//  .startWithNext { name in
//    print("Project -----> \(name)")
//}
//
//// Get a few recent activities and print out the name of the user that created the activity.
//// This only works if you uncomment `oauthToken` above and put in a valid token.
//service.fetchActivities()
//  .flatMap(.Concat) { SignalProducer<Activity, ErrorEnvelope>(values: $0.activities) }
//  .map { $0.user?.name }
//  .skipNil()
//  .startWithNext { name in
//    print("Activity user's name: \(name)")
//}
