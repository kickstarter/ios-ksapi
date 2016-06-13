import Prelude

extension Config {
  internal static let template = Config(
    abExperiments: [:],
    appId: 123456789,
    countryCode: "US",
    features: [:],
    iTunesLink: "http://www.itunes.com",
    launchedCountries: [.US],
    locale: "en",
    stripePublishableKey: "pk"
  )

  internal static let config = Config.template

  internal static let deConfig = Config.template
    |> Config.lens.countryCode .~ "DE"
    |> Config.lens.locale .~ "de"
}
