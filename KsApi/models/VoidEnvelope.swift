import Argo

public struct VoidEnvelope {
}

extension VoidEnvelope: Decodable {
  public static func decode(json: JSON) -> Decoded<VoidEnvelope> {
    return .Success(VoidEnvelope())
  }
}
