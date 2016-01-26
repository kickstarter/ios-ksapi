import Argo
import Curry
import Models

public struct CategoriesEnvelope {
  public let categories: [Models.Category]
}

extension CategoriesEnvelope : Decodable {
  public static func decode(json: JSON) -> Decoded<CategoriesEnvelope> {
    return curry(CategoriesEnvelope.init)
      <^> json <|| "categories"
  }
}
