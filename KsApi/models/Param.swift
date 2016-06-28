/// Represents a way to paramterize a model by either an `id` integer or `slug` string.
public enum Param {
  case id(Int)
  case slug(String)

  /// Returns the `id` of the param if it is of type `.id`.
  public var id: Int? {
    if case let .id(id) = self {
      return id
    }
    return nil
  }

  /// Returns the `slug` of the param if it is of type `.slug`.
  public var slug: String? {
    if case let .slug(slug) = self {
      return slug
    }
    return nil
  }

  /// Returns a value suitable for interpolating into a URL.
  public var urlComponent: String {
    switch self {
    case let .id(id):
      return String(id)
    case let .slug(slug):
      return slug
    }
  }
}
