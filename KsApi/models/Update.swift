import Foundation
import Argo
import Curry

public struct Update {
  public let body: String?
  public let commentsCount: Int?
  public let hasLiked: Bool?
  public let id: Int
  public let isPublic: Bool
  public let likesCount: Int?
  public let projectId: Int
  public let publishedAt: NSTimeInterval?
  public let sequence: Int
  public let title: String
  public let urls: UrlsEnvelope
  public let user: User?
  public let visible: Bool?

  public struct UrlsEnvelope {
    public let web: WebEnvelope

    public struct WebEnvelope {
      public let update: String
    }
  }
}

extension Update: Equatable {
}
public func == (lhs: Update, rhs: Update) -> Bool {
  return lhs.id == rhs.id
}

extension Update: Decodable {

  public static func decode(json: JSON) -> Decoded<Update> {
    let create = curry(Update.init)
    let tmp = create
      <^> json <|?  "body"
      <*> json <|? "comments_count"
      <*> json <|? "has_liked"
      <*> json <|  "id"
      <*> json <|  "public"
      <*> json <|? "likes_count"
    return tmp
      <*> json <|  "project_id"
      <*> json <|? "published_at"
      <*> json <|  "sequence"
      <*> json <| "title" <|> .Success("")
      <*> json <|  "urls"
      <*> json <|? "user"
      <*> json <|?  "visible"
  }
}

extension Update.UrlsEnvelope: Decodable {
  static public func decode(json: JSON) -> Decoded<Update.UrlsEnvelope> {
    return curry(Update.UrlsEnvelope.init)
      <^> json <| "web"
  }
}

extension Update.UrlsEnvelope.WebEnvelope: Decodable {
  static public func decode(json: JSON) -> Decoded<Update.UrlsEnvelope.WebEnvelope> {
    return curry(Update.UrlsEnvelope.WebEnvelope.init)
      <^> json <| "update"
  }
}
