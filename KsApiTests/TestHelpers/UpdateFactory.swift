@testable import KsApi

extension Update {
  internal static let template = Update(
    body: "Hello world",
    commentsCount: 2,
    hasLiked: false,
    id: 1,
    isPublic: true,
    likesCount: 3,
    projectId: 1,
    publishedAt: NSDate().timeIntervalSince1970,
    sequence: 1,
    title: "Hello",
    urls: Update.UrlsEnvelope(web: Update.UrlsEnvelope.WebEnvelope(
      update: "https://www.kickstarter.com/projects/udoo/udoo-x86/posts/1571540")
    ),
    user: nil,
    visible: true
  )
}
