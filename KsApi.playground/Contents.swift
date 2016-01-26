import XCPlayground
import KsApi
import ReactiveCocoa
import ReactiveExtensions
import Alamofire

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let service = Service.shared

let categories = service.fetchCategories()
  .sort()
  .uncollect()
  .filter { c in c.isRoot }
  .startAndShare()

categories
  .map { c in c.name }
  .startWithNext { c in
    print(c)
}

categories
  .map { c in DiscoveryParams(category: c, sort: .Popular, perPage: 1) }
  .mergeMap(service.fetchProject)
  .map { p in (p.name, p.category.name) }
  .startWithNext { data in
    print(data)
}
