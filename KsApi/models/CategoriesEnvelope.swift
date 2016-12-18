import Argo
import Curry

public struct CategoriesEnvelope {
  public let categories: [Category]
}

extension CategoriesEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<CategoriesEnvelope> {
    return curry(CategoriesEnvelope.init)
      <^> json <|| "categories"
  }
}
