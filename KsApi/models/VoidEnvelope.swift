import Argo

public struct VoidEnvelope {
}

extension VoidEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<VoidEnvelope> {
    return .Success(VoidEnvelope())
  }
}
