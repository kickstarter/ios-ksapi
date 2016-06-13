// swiftlint:disable type_name
import Prelude

extension Config {
  public enum lens {
    public static let countryCode = Lens<Config, String>(
      view: { $0.countryCode },
      set: { Config(abExperiments: $1.abExperiments, appId: $1.appId, countryCode: $0, features: $1.features,
        iTunesLink: $1.iTunesLink, launchedCountries: $1.launchedCountries, locale: $1.locale,
        stripePublishableKey: $1.stripePublishableKey) }
    )

    public static let locale = Lens<Config, String>(
      view: { $0.locale },
      set: { Config(abExperiments: $1.abExperiments, appId: $1.appId, countryCode: $1.countryCode,
        features: $1.features, iTunesLink: $1.iTunesLink, launchedCountries: $1.launchedCountries, locale: $0,
        stripePublishableKey: $1.stripePublishableKey) }
    )
  }
}
