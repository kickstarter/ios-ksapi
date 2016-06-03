@testable import KsApi

internal struct ConfigFactory {
  internal static let config = Config(
    abExperiments: [:],
    appId: 123456789,
    countryCode: "US",
    features: [:],
    iTunesLink: "http://www.itunes.com",
    launchedCountries: [.US],
    locale: "en",
    stripePublishableKey: "pk"
  )

  internal static let deConfig = Config(
    abExperiments: [:],
    appId: 987654321,
    countryCode: "DE",
    features: [:],
    iTunesLink: "http://www.itunes.com",
    launchedCountries: [.US],
    locale: "de",
    stripePublishableKey: "pk"
  )
}
