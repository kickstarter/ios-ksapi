import ReactiveSwift
import KsApi
import Result
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// Java: Observerable
//       "hot"  ~> Signal
//       "cold" ~> SignalProducer

// Signal
// SignalProducer


// ------------------- signals and properties ---------------------

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
//  .observeValues { print($0) }

property.signal
  .skipNil()
  .map { $0 + 1 }
  .filter { $0 % 2 == 0 }
//  .observeValues { print("property: \($0)") }
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
//  .observeValues { print("merge: \($0)") }

Signal.combineLatest(
  signalA,
  signalB,
  signalC
  )
//  .observeValues { print("combineLatest: \($0)") }

Signal.zip(signalA, signalB)
//  .observeValues { print("zip: \($0)") }

// zip: (2, 5)
// zip: (3, 10)


let m: Signal<Event<Int, NoError>, NoError> = signalA
  .materialize()

//m.observe { print($0) }

observerA.send(value: 2)
observerB.send(value: 5)
observerA.send(value: 3)
observerB.send(value: 10)


observerC.send(value: 23)

observerA.sendCompleted()



// ------------------- producers ---------------------


property
  .signal
  .skipNil()
  .map { $0 + 1 }
//  .observeValues { print("property.signal: \($0)") }

property
  .producer
  .skipNil()
  .map { $0 + 1 }
//  .startWithValues { print("property.producer: \($0)") }


property.value = 4
property.value = 10
property.value = 20


SignalProducer<Int, NoError>([1, 2, 3, 4, 5])
//  .start { print("event: \($0)") }


// ------------------- flatmap ---------------------


signal
  .switchMap { x in
//  .flatMap { x in
    SignalProducer([1])
      .delay(1, on: QueueScheduler.main)
      .map { $0 + x }
  }
//  .observeValues { print("flatMap: \($0)") }
  .observeValues { print("switchMap: \($0)") }

observer.send(value: 100)
observer.send(value: 200)
observer.send(value: 300)
observer.send(value: 400)
observer.send(value: 500)
observer.send(value: 600)
observer.send(value: 700)
observer.send(value: 800)



// 



//signal.flatMap { producer }     => signal

//producer.flatMap { signal }     => producer
//producer.flatMap { producer }   => producer
//signal.flatMap { signal }       => signal






































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
