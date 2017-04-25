// Hopefully this can be code gen'd
import Argo
import Curry
import Runes

public struct CategoriesQueryResult: Decodable, RootCategoriesField {
  public private(set) var rootCategories: [Category]

  public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult> {
    return pure(curry(self.init))
      <*> json <|| ["data", "rootCategories"]
  }

  public struct Category: Decodable, CategoryType, IdField, NameField, CategoryProjectsConnectionField, CategorySubcategoriesConnectionField {
    public private(set) var id: String
    public private(set) var name: String
    public private(set) var projects: CategoryProjectsConnection
    public private(set) var subcategories: CategorySubcategoriesConnection

    public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult.Category> {
      return pure(curry(self.init))
        <*> json <| "id"
        <*> json <| "name"
        <*> json <| "projects"
        <*> json <| "subcategories"
    }

    public struct CategorySubcategoriesConnection: Decodable, CategorySubcategoriesConnectionType, CategoryNodesField {
      public private(set) var nodes: [Category]

      public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult.Category.CategorySubcategoriesConnection> {
        return pure(curry(self.init))
          <*> json <|| "nodes"
      }

      public struct Category: Decodable, CategoryType, IdField, NameField {
        public private(set) var id: String
        public private(set) var name: String

        public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult.Category.CategorySubcategoriesConnection.Category> {
          return pure(curry(self.init))
            <*> json <| "id"
            <*> json <| "name"
        }
      }
    }

    public struct CategoryProjectsConnection: Decodable, CategoryProjectsConnectionType, TotalCountField {
      public private(set) var totalCount: Int

      public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult.Category.CategoryProjectsConnection> {
        return pure(curry(self.init))
          <*> json <| "totalCount"
      }
    }

    public struct Category: Decodable, CategoryType, IdField, NameField {
      public private(set) var id: String
      public private(set) var name: String

      public static func decode(_ json: JSON) -> Decoded<CategoriesQueryResult.Category.Category> {
        return pure(curry(self.init))
          <*> json <| "id"
          <*> json <| "name"
      }
    }
  }
}
