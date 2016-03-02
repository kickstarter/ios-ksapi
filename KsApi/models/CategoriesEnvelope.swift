import struct Models.Category
import protocol Argo.Decodable
import enum Argo.Decoded
import enum Argo.JSON
import func Argo.<||
import func Argo.<^>
import func Curry.curry

public struct CategoriesEnvelope {
  public let categories: [Models.Category]
}

extension CategoriesEnvelope : Decodable {
  public static func decode(json: JSON) -> Decoded<CategoriesEnvelope> {
    return curry(CategoriesEnvelope.init)
      <^> json <|| "categories"
  }
}
