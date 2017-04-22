import PlaygroundSupport
import Foundation
import Argo
import Curry
import Runes
import Prelude

PlaygroundPage.current.needsIndefiniteExecution = true

protocol QueryObject: CustomStringConvertible, Hashable {}

extension QueryObject {
  var hashValue: Int {
    return description.hashValue
  }
}

func == <Q: QueryObject>(lhs: Q, rhs: Q) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

private func join<Q: QueryObject>(_ nodes: Set<Q>, _ separator: String = " ") -> String {
  return nodes.map { $0.description }.sorted().joined(separator: separator)
}

enum EdgesContainerArguments {
  case after(String)
  case before(String)
  case first(Int)
  case last(Int)
}

enum EdgesContainerBody<Q: QueryObject> {
  case pageInfo(Set<PageInfo>)
  case edges(Set<Edges<Q>>)
}

enum PageInfo: String {
  case endCursor
  case hasNextPage
  case hasPreviousPage
  case startCursor
}

enum Edges<Q: QueryObject> {
  case node(Set<Q>)
}



enum Query {
  case me(Set<User>)
  case project(slug: String, Set<Project>)
  case rootCategories(Set<Category>)
  
  enum User {
    case id
    case location(Set<Location>)
    case name
  }
  
  enum Category {
    case id
    case name
  }
  
  enum Location {
    case id
    case name
  }
  
  enum Project {
    case category(Set<Category>)
    case creator(Set<User>)
    case id
    case location(Set<Location>)
    case name
  }
  
  static func build(_ queries: Set<Query>) -> String {
    return "{ \(join(queries)) }"
  }
}

extension EdgesContainerArguments: QueryObject {
  var description: String {
    switch self {
    case let .after(cursor):
      return "after: \"\(cursor)\""
    case let .before(cursor):
      return "before: \"\(cursor)\""
    case let .first(count):
      return "first: \(count)"
    case let .last(count):
      return "last: \(count)"
    }
  }
}

extension EdgesContainerBody: QueryObject {
  var description: String {
    switch self {
    case let .edges(edges):
      return "edges { \(join(edges)) }"
    case let .pageInfo(pageInfo):
      return "pageInfo { \(join(pageInfo)) }"
    }
  }
}

extension Edges: QueryObject {
  var description: String {
    switch self {
    case let .node(project):
      return "node { \(join(project)) }"
    }
  }
}

extension PageInfo: QueryObject {
  var description: String {
    return rawValue
  }
}

extension Query: QueryObject {
  var description: String {
    switch self {
    case let .me(fields):
      return "me { \(join(fields, ", ")) }"
    case let .project(slug, fields):
      return "project(slug: \"\(slug)\") { \(join(fields, ", ")) }"
    case let .rootCategories(fields):
      return "rootCategories { \(join(fields, ", ")) }"
    }
  }
}

extension Query.User: QueryObject {
  var description: String {
    switch self {
    case .id:   return "id"
    case let .location(fields):
      return "location { \(join(fields, ", ")) }"
    case .name: return "name"
    }
  }
}

extension Query.Category: QueryObject {
  var description: String {
    switch self {
    case .id:   return "id"
    case .name: return "name"
    }
  }
}

extension Query.Project: QueryObject {
  var description: String {
    switch self {
    case let .category(fields):
      return "category { \(join(fields, ", ")) }"
    case let .creator(fields):
      return "creator { \(join(fields, ", ")) }"
    case .id:
      return "id"
    case let .location(fields):
      return "location { \(join(fields, ", ")) }"
    case .name:
      return "name"
    }
  }
}

extension Query.Location: QueryObject {
  var description: String {
    switch self {
    case .id:   return "id"
    case .name: return "name"
    }
  }
}


let query = Query.build(
  [
    .rootCategories(
      [
        .id,
        .name
      ]
    ),
    .project(
      slug: "jamietanner/inventory-the-consumptive-3",
      [
        .category(
          [
            .id,
            .name
          ]
        ),
        .creator(
          [
            .id,
            .name,
            .location(
              [
                .id,
                .name
              ]
            )
          ]
        ),
        .id,
        .location(
          [
            .id,
            .name
          ]
        ),
        .name
      ]
    )
  ]
)

protocol IdField {
  var id: String { get }
}
protocol NameField {
  var name: String { get }
}
protocol CategoryField {
  associatedtype _CategoryType: CategoryType
  var category: _CategoryType { get }
}
protocol CreatorField {
  associatedtype _UserType: UserType
  var creator: _UserType { get }
}
protocol LocationField {
  associatedtype _LocationType: LocationType
  var location: _LocationType { get }
}

protocol CategoryType {}
protocol ProjectType {}
protocol UserType {}
protocol LocationType {}

struct StartUpQueryResult: Decodable {
  private(set) var data: Data
  
  static let template = StartUpQueryResult(data: .template)
  
  enum lens {
    static let data = Lens<StartUpQueryResult, Data>(
      view: { $0.data },
      set: { var new = $1; new.data = $0; return new }
    )
  }
  
  static func decode(_ json: JSON) -> Decoded<StartUpQueryResult> {
    return pure(curry(StartUpQueryResult.init))
      <*> json <| "data"
  }
  
  struct Data: Decodable {
    private(set) var project: Project
    private(set) var rootCategories: [Category]
    
    static let template = Data(project: .template, rootCategories: [.template])
    
    enum lens {
      static let project = Lens<Data, Project>(
        view: { $0.project },
        set: { var new = $1; new.project = $0; return new }
      )
      static let rootCategories = Lens<Data, [Category]>(
        view: { $0.rootCategories },
        set: { var new = $1; new.rootCategories = $0; return new }
      )
    }
    
    static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data> {
      return pure(curry(Data.init))
        <*> json <| "project"
        <*> json <|| "rootCategories"
    }
    
    struct Category: CategoryType, IdField, NameField, Decodable {
      private(set) var id: String
      private(set) var name: String
      
      static let template = Category(id: "", name: "")
      
      enum lens {
        static let id = Lens<Category, String>(
          view: { $0.id },
          set: { var new = $1; new.id = $0; return new }
        )
        static let name = Lens<Category, String>(
          view: { $0.name },
          set: { var new = $1; new.name = $0; return new }
        )
      }
      
      static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data.Category> {
        return pure(curry(Category.init))
          <*> json <| "id"
          <*> json <| "name"
      }
    }
    
    struct Project: ProjectType, CategoryField, CreatorField, IdField, NameField, Decodable {
      private(set) var category: Category
      private(set) var creator: User
      private(set) var id: String
      private(set) var name: String
      
      static let template = Project(category: .template, creator: .template, id: "", name: "")
      
      enum lens {
        static let category = Lens<Project, Category>(
          view: { $0.category },
          set: { var new = $1; new.category = $0; return new }
        )
        static let creator = Lens<Project, User>(
          view: { $0.creator },
          set: { var new = $1; new.creator = $0; return new }
        )
        static let id = Lens<Project, String>(
          view: { $0.id },
          set: { var new = $1; new.id = $0; return new }
        )
        static let name = Lens<Project, String>(
          view: { $0.name },
          set: { var new = $1; new.name = $0; return new }
        )
      }
      
      static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data.Project> {
        return pure(curry(Project.init))
          <*> json <| "category"
          <*> json <| "creator"
          <*> json <| "id"
          <*> json <| "name"
      }
      
      struct Category: CategoryType, IdField, NameField, Decodable {
        private(set) var id: String
        private(set) var name: String
        
        static let template = Category(id: "", name: "")
        
        enum lens {
          static let id = Lens<Category, String>(
            view: { $0.id },
            set: { var new = $1; new.id = $0; return new }
          )
          static let name = Lens<Category, String>(
            view: { $0.name },
            set: { var new = $1; new.name = $0; return new }
          )
        }
        
        static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data.Project.Category> {
          return pure(curry(Category.init))
            <*> json <| "id"
            <*> json <| "name"
        }
      }
      
      struct User: UserType, IdField, LocationField, NameField, Decodable {
        private(set) var id: String
        private(set) var location: Location
        private(set) var name: String
        
        static let template = User(id: "", location: .template, name: "")
        
        enum lens {
          static let id = Lens<User, String>(
            view: { $0.id },
            set: { var new = $1; new.id = $0; return new }
          )
          static let location = Lens<User, Location>(
            view: { $0.location },
            set: { var new = $1; new.location = $0; return new }
          )
          static let name = Lens<User, String>(
            view: { $0.name },
            set: { var new = $1; new.name = $0; return new }
          )
        }
        
        static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data.Project.User> {
          return pure(curry(User.init))
            <*> json <| "id"
            <*> json <| "location"
            <*> json <| "name"
        }
        
        struct Location: LocationType, IdField, NameField, Decodable {
          private(set) var id: String
          private(set) var name: String
          
          static let template = Location(id: "", name: "")
          
          enum lens {
            static let id = Lens<Location, String>(
              view: { $0.id },
              set: { var new = $1; new.id = $0; return new }
            )
            static let name = Lens<Location, String>(
              view: { $0.name },
              set: { var new = $1; new.name = $0; return new }
            )
          }
          
          static func decode(_ json: JSON) -> Decoded<StartUpQueryResult.Data.Project.User.Location> {
            return pure(curry(Location.init))
              <*> json <| "id"
              <*> json <| "name"
          }
        }
      }
    }
  }
}

let result = StartUpQueryResult.template

let newresult = result
  |> (
    StartUpQueryResult.lens.data
      .. StartUpQueryResult.Data.lens.project
      .. StartUpQueryResult.Data.Project.lens.creator
      .. StartUpQueryResult.Data.Project.User.lens.location
      .. StartUpQueryResult.Data.Project.User.Location.lens.id) .~ "hello"
  |> (
    StartUpQueryResult.lens.data
      .. StartUpQueryResult.Data.lens.rootCategories) .~ [.template, .template]

newresult.data.project.creator.location.id
newresult.data.rootCategories

func doSomething(category: CategoryType & IdField) {
  print("did something")
  print(category)
  print("-----------")
}

struct ProjectView<
  PT: ProjectType
    & CategoryField
    & CreatorField
    & IdField
    & NameField
  where
    PT._CategoryType: IdField & NameField,
    PT._UserType: IdField & LocationField,
    PT._UserType._LocationType: IdField> {
  let value: PT
  
}

func doSomething <PT: ProjectType & CategoryField & CreatorField & IdField & NameField> (project: PT)
  where PT._CategoryType: IdField & NameField, PT._UserType: IdField & LocationField, PT._UserType._LocationType: IdField {
    
    project.category.id
    project.creator
    project.creator.location.id
}

doSomething(category: result.data.project.category)
doSomething(category: result.data.rootCategories.first!)

doSomething(project: result.data.project)

let url = URL(string: "http://ksr.dev/graph")!
var request = URLRequest(url: url)
request.httpBody = "query=\(query)".data(using: .utf8)
request.httpMethod = "POST"

let task = URLSession.shared.dataTask(with: request) { data, response, error in
  guard let data = data else { return }
  
  print(String.init(data: data, encoding: .utf8))
  
  let json = try! JSONSerialization.jsonObject(with: data, options: [])
  let decoded = StartUpQueryResult.decode(JSON(json))
  
  guard let result = decoded.value else { dump(decoded.error); return; }
  
  dump(result)
  
  doSomething(project: result.data.project)
  doSomething(category: result.data.project.category)
  doSomething(category: result.data.rootCategories.first!)
  
  dump(ProjectView(value: result.data.project))
}
task.resume()

"done"

