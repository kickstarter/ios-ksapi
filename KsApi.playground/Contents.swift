import XCPlayground
import KsApi
import struct ReactiveCocoa.SignalProducer
import enum ReactiveCocoa.FlattenStrategy
import struct Models.Category
import enum Result.NoError

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let service = Service.shared

let categories = service.fetchCategories()
  .flatMap(.Concat) { SignalProducer<Category, ErrorEnvelope>(values: $0) }
  .filter { c in c.isRoot }
  .replayLazily(1)

categories
  .map { c in c.name }
  .startWithNext { c in
    print("Root category ----> \(c)")
}

categories
  .map { c in DiscoveryParams(category: c, sort: .Popular, perPage: 1) }
  .flatMap(.Merge, transform: service.fetchProject)
  .map { p in (p.name, p.category.name) }
  .startWithNext { data in
    print("Project -----> \(data)")
}
