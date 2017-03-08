import Argo
import Curry
import Prelude
import Runes

public struct LiveAuthTokenEnvelope {
  public fileprivate(set) var token: String
}

extension LiveAuthTokenEnvelope: Decodable {
  public static func decode(_ json: JSON) -> Decoded<LiveAuthTokenEnvelope> {
    return curry(LiveAuthTokenEnvelope.init)
      <^> json <| "ksr_live_token"
  }
}

extension LiveAuthTokenEnvelope {
  public enum lens {
    public static let backgroundImage = Lens<LiveAuthTokenEnvelope, String>(
      view: { $0.token },
      set: { var new = $1; new.token = $0; return new }
    )
  }
}
