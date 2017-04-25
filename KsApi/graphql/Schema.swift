// Hopefully this can be code gen'd
public protocol QueryObject: CustomStringConvertible, Hashable {}

extension QueryObject {
  public var hashValue: Int {
    return description.hashValue
  }
}

public func == <Q: QueryObject>(lhs: Q, rhs: Q) -> Bool {
  return lhs.hashValue == rhs.hashValue
}

private func join<Q: QueryObject>(_ nodes: Set<Q>, _ separator: String = " ") -> String {
  return nodes.map { $0.description }.sorted().joined(separator: separator)
}

public enum EdgesContainerArguments {
  case after(String)
  case before(String)
  case first(Int)
  case last(Int)
}

public enum EdgesContainerBody<Q: QueryObject> {
  case pageInfo(Set<PageInfo>)
  case edges(Set<Edges<Q>>)
}

public enum PageInfo: String {
  case endCursor
  case hasNextPage
  case hasPreviousPage
  case startCursor
}

public enum Edges<Q: QueryObject> {
  case node(Set<Q>)
}

public enum Nodes<Q: QueryObject> {
  case nodes(Set<Q>)
}

public enum Query {
  case me(Set<User>)
  case project(slug: String, Set<Project>)
  case rootCategories(Set<Category>)
  case supportedCountries(Set<Country>)

  public enum User {
    case backedProjects(Set<Project>)
    case id
    case imageUrl(width: Int)
    case location(Set<Location>)
    case name
  }

  public enum Category {
    case id
    case name
    case projects(state: GQLProjectState, Set<CategoryProjectsConnection>, Nodes<Project>)
    case subcategories(Set<Category>)
  }

  public enum Country {
    case code
    case name
  }

  public enum Location {
    case id
    case name
  }

  public enum CategoryProjectsConnection {
    case totalCount
  }

  public enum Currency {
    case amount
    case currency
  }

  public enum Project {
    case canceledAt
    case category(Set<Category>)
    case creator(Set<User>)
    case deadlineAt
    case description
    case fundingRatio
    case goal(Set<Currency>)
    case id
    case imageUrl(blur: Bool, width: Int)
    case isProjectWeLove
    case location(Set<Location>)
    case name
    case percentFunded
    case pledged(Set<Currency>)
    case rewards(Set<Reward>)
    case slug
    case updates(Set<ProjectUpdateConnection>)
    case url
    case state
  }

  public enum ProjectUpdateConnection {
    case totalCount
  }

  public enum Reward {
    case description
    case id
    case name
  }

  public static func build(_ queries: Set<Query>) -> String {
    return "{ \(join(queries)) }"
  }
}

extension EdgesContainerArguments: QueryObject {
  public var description: String {
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
  public var description: String {
    switch self {
    case let .edges(edges):
      return "edges { \(join(edges)) }"
    case let .pageInfo(pageInfo):
      return "pageInfo { \(join(pageInfo)) }"
    }
  }
}

extension Edges: QueryObject {
  public var description: String {
    switch self {
    case let .node(project):
      return "node { \(join(project)) }"
    }
  }
}

extension Nodes: QueryObject {
  public var description: String {
    switch self {
    case let .nodes(fields):
      return "nodes { \(join(fields)) }"
    }
  }
}

extension PageInfo: QueryObject {
  public var description: String {
    return rawValue
  }
}

extension Query: QueryObject {
  public var description: String {
    switch self {
    case let .me(fields):
      return "me { \(join(fields)) }"
    case let .project(slug, fields):
      return "project(slug: \"\(slug)\") { \(join(fields)) }"
    case let .rootCategories(fields):
      return "rootCategories { \(join(fields)) }"
    case let .supportedCountries(fields):
      return "supportedCountries { \(join(fields)) }"
    }
  }
}

extension Query.User: QueryObject {
  public var description: String {
    switch self {
    case let .backedProjects(fields):
      return "backedProjects { nodes { \(join(fields)) } }"
    case .id:
      return "id"
    case let .imageUrl(width):
      return "imageUrl(width: \(width))"
    case let .location(fields):
      return "location { \(join(fields)) }"
    case .name:
      return "name"
    }
  }
}

extension Query.Category: QueryObject {
  public var description: String {
    switch self {
    case .id:
      return "id"
    case .name:
      return "name"
    case let .projects(state, connections, .nodes(fields)):
      let first = "projects(state:\(state)) { \(join(connections)) "
      if fields.count == 0 {
        return first + "}"
      } else {
        return first + " nodes { \(join(fields)) } }"
      }
    case let .subcategories(fields):
      return "subcategories { nodes { \(join(fields)) } }"
    }
  }
}

extension Query.Country: QueryObject {
  public var description: String {
    switch self {
    case .code: return "code"
    case .name: return "name"
    }
  }
}

extension Query.CategoryProjectsConnection: QueryObject {
  public var description: String {
    switch self {
    case .totalCount:
      return "totalCount"
    }
  }
}

extension Query.ProjectUpdateConnection: QueryObject {
  public var description: String {
    switch self {
    case .totalCount:
      return "totalCount"
    }
  }
}

extension Query.Project: QueryObject {
  public var description: String {
    switch self {
    case .canceledAt:
      return "canceledAt"
    case let .category(fields):
      return "category { \(join(fields)) }"
    case .deadlineAt:
      return "deadlineAt"
    case .description:
      return "description"
    case let .creator(fields):
      return "creator { \(join(fields)) }"
    case .fundingRatio:
      return "fundingRatio"
    case let .goal(fields):
      return "goal { \(join(fields)) }"
    case .id:
      return "id"
    case let .imageUrl(blur, width):
      return "imageUrl(blur: \(blur), width: \(width))"
    case .isProjectWeLove:
      return "isProjectWeLove"
    case let .location(fields):
      return "location { \(join(fields)) }"
    case .name:
      return "name"
    case .percentFunded:
      return "percentFunded"
    case let .pledged(fields):
      return "pledged { \(join(fields)) }"
    case let .rewards(fields):
      return "rewards { nodes { \(join(fields)) } }"
    case .slug:
      return "slug"
    case .state:
      return "state"
    case let .updates(connections):
      return "updates { \(join(connections)) }"
    case .url:
      return "url"
    }
  }
}

extension Query.Location: QueryObject {
  public var description: String {
    switch self {
    case .id:   return "id"
    case .name: return "name"
    }
  }
}

extension Query.Currency: QueryObject {
  public var description: String {
    switch self {
    case .amount:   return "amount"
    case .currency: return "currency"
    }
  }
}

extension Query.Reward: QueryObject {
  public var description: String {
    switch self {
    case .description:   return "description"
    case .id:   return "id"
    case .name: return "name"
    }
  }
}
