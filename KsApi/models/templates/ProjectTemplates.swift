import Prelude

// swiftlint:disable line_length
extension Project {
  internal static let template = Project(
    backing: nil,
    blurb: "A fun project.",
    category: .template,
    country: .US,
    creator: .template |> User.lens.stats.createdProjectsCount .~ 1,
    memberData: Project.MemberData(
      lastUpdatePublishedAt: nil,
      permissions: [],
      unreadMessagesCount: nil,
      unseenActivityCount: nil
    ),
    dates: Project.Dates(
      deadline: NSDate().timeIntervalSince1970 + 60.0 * 60.0 * 24.0 * 15.0,
      launchedAt: NSDate().timeIntervalSince1970 - 60.0 * 60.0 * 24.0 * 15.0,
      potdAt: nil,
      stateChangedAt: NSDate().timeIntervalSince1970 - 60.0 * 60.0 * 24.0 * 15.0
    ),
    id: 1,
    location: .template,
    name: "The Project",
    personalization: Project.Personalization(
      backing: nil,
      isBacking: nil,
      isStarred: nil
    ),
    photo: .template,
    rewards: nil,
    slug: "a-fun-project",
    state: .live,
    stats: Project.Stats(
      backersCount: 10,
      commentsCount: 10,
      goal: 2_000,
      pledged: 1_000,
      updatesCount: 1
    ),
    urls: Project.UrlsEnvelope(
      web: Project.UrlsEnvelope.WebEnvelope(
        project: "https://www.kickstarter.com/projects/creator/a-fun-project"
      )
    ),
    video: .template
  )

  internal static let todayByScottThrift = .template
    |> Project.lens.photo.full .~ "https://ksr-ugc.imgix.net/assets/012/224/660/847bc4da31e6863e9351bee4e55b8005_original.jpg?w=1024&h=576&fit=fill&bg=FBFAF8&v=1464773625&auto=format&q=92&s=38af4533c87179eeab9790037edec189"
    |> Project.lens.name .~ "Today"
    |> Project.lens.blurb .~ "A 24-hour timepiece beautifully designed to change the way you see your day."
    |> Project.lens.category.name .~ "Product Design"
    |> Project.lens.stats.backersCount .~ 1_090
    |> Project.lens.stats.pledged .~ 212_870
    |> Project.lens.stats.goal .~ 24_000

  internal static let cosmicSurgery = .template
    |> Project.lens.photo.full .~ "https://ksr-ugc.imgix.net/assets/012/347/230/2eddca8c4a06ecb69b8787b985201b92_original.jpg?w=460&fit=max&v=1463756137&auto=format&q=92&s=98a6df348751e8b325e48eb8f802fa7e"
    |> Project.lens.photo.med .~ "https://ksr-ugc.imgix.net/assets/012/347/230/2eddca8c4a06ecb69b8787b985201b92_original.jpg?w=460&fit=max&v=1463756137&auto=format&q=92&s=98a6df348751e8b325e48eb8f802fa7e"
    |> Project.lens.photo.small .~ "https://ksr-ugc.imgix.net/assets/012/347/230/2eddca8c4a06ecb69b8787b985201b92_original.jpg?w=460&fit=max&v=1463756137&auto=format&q=92&s=98a6df348751e8b325e48eb8f802fa7e"
    |> Project.lens.name .~ "Cosmic Surgery"
    |> Project.lens.blurb .~ "Cosmic Surgery is a photo book, set in the not too distant future where the world of cosmetic surgery is about to be transformed."
    |> Project.lens.category.name .~ "Photo Books"
    |> Project.lens.stats.backersCount .~ 329
    |> Project.lens.stats.pledged .~ 22_318
    |> Project.lens.stats.goal .~ 22_000
    |> (Project.lens.location • Location.lens.displayableName) .~ "Hastings, UK"
    |> Project.lens.country .~ .GB
    |> Project.lens.creator .~ (
      .template
        |> User.lens.name .~ "Alma Haser"
        |> User.lens.avatar.large .~ "https://ksr-ugc.imgix.net/assets/006/286/957/203502774070f5c0bf5ddcbb58e13000_original.jpg?w=80&h=80&fit=crop&v=1461378633&auto=format&q=92&s=68edc5b8d1b110634b59589253801ea1"
        |> User.lens.avatar.medium .~ "https://ksr-ugc.imgix.net/assets/006/286/957/203502774070f5c0bf5ddcbb58e13000_original.jpg?w=80&h=80&fit=crop&v=1461378633&auto=format&q=92&s=68edc5b8d1b110634b59589253801ea1"
        |> User.lens.avatar.small .~ "https://ksr-ugc.imgix.net/assets/006/286/957/203502774070f5c0bf5ddcbb58e13000_original.jpg?w=80&h=80&fit=crop&v=1461378633&auto=format&q=92&s=68edc5b8d1b110634b59589253801ea1"
  )

  internal static let anomalisa = .template
    |> Project.lens.photo.full .~ "https://ksr-ugc.imgix.net/assets/011/388/954/25e113da402393de9de995619428d10d_original.png?w=1024&h=576&fit=fill&bg=000000&v=1463681956&auto=format&q=92&s=2a9b6a90e1f52b96d7cbdcad28319f9d"
    |> Project.lens.name .~ "Charlie Kaufman's Anomalisa"
    |> Project.lens.blurb .~ "From writer Charlie Kaufman (Being John Malkovich, Eternal Sunshine of the Spotless Mind) and Duke Johnson (Moral Orel, Frankenhole) comes Anomalisa."
    |> Project.lens.category.name .~ "Animation"
    |> Project.lens.stats.backersCount .~ 5_770
    |> Project.lens.stats.pledged .~ 406_237
    |> Project.lens.stats.goal .~ 200_000
    |> (Project.lens.location • Location.lens.displayableName) .~ "Burbank, CA"
}
