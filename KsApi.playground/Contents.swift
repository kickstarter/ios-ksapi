import XCPlayground
import KsApi
import ReactiveCocoa
import Alamofire

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let service = Service.shared

let categories = service.fetchCategories()
  .sort()
  .uncollect()
  .filter { c in c.isRoot }
  .replayLazily(1)

categories
  .map { c in c.name }
  .startWithNext { c in
    print("Root category ----> \(c)")
}

categories
  .map { c in DiscoveryParams(category: c, sort: .Popular, perPage: 1) }
  .mergeMap(service.fetchProject)
  .map { p in (p.name, p.category.name) }
  .startWithNext { data in
    print("Project -----> \(data)")
}
