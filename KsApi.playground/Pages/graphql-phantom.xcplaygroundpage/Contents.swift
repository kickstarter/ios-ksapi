protocol GQField {
  associatedtype FieldType
  static var fieldType: FieldType.Type { get }
  static var fieldName: String { get }
}

public struct GQLUserId: GQField {
  static let fieldType = String.self
  static let fieldName = "id"
}

let aType = String.self

func test<A>(x: A.Type) {

  let a: A
}

test(x: String.self)