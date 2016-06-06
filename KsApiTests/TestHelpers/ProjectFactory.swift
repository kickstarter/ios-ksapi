@testable import KsApi
import Prelude

// swiftlint:disable type_body_length
// swiftlint:disable file_length
extension Project {
  internal static let template = Project(
    backing: nil,
    blurb: "A fun project.",
    category: Category.template,
    country: .US,
    creator: User.template |> User.lens.stats.createdProjectsCount .~ 1,
    dates: Project.Dates(
      deadline: NSDate().timeIntervalSince1970 + 60.0 * 60.0 * 24.0 * 15.0,
      launchedAt: NSDate().timeIntervalSince1970 - 60.0 * 60.0 * 24.0 * 15.0,
      potdAt: nil,
      stateChangedAt: NSDate().timeIntervalSince1970 - 60.0 * 60.0 * 24.0 * 15.0
    ),
    id: 1,
    location: Location.template,
    name: "The Project",
    personalization: Project.Personalization(
      backing: nil,
      isBacking: nil,
      isStarred: nil
    ),
    photo: Project.Photo.template,
    rewards: nil,
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
        project: "https://www.kickstarter.com/projects/my-cool-projects"
      )
    ),
    video: Project.Video.template
  )
}
