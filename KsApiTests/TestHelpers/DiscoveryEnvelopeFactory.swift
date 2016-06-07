@testable import KsApi
import Prelude

extension DiscoveryEnvelope {
  internal static let template = DiscoveryEnvelope(
    projects: [.template],
    urls: .template,
    stats: .template
  )
}

extension DiscoveryEnvelope.UrlsEnvelope {
  internal static let template = DiscoveryEnvelope.UrlsEnvelope(
    api: .template
  )
}

extension DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope {
  internal static let template = DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope(
    more_projects: "http://***REMOVED***/gimme/more"
  )
}

extension DiscoveryEnvelope.StatsEnvelope {
  internal static let template = DiscoveryEnvelope.StatsEnvelope(
    count: 200
  )
}
