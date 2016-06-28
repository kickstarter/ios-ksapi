// swiftlint:disable type_name
import Prelude

extension Project {
  public enum lens {
    public static let backing = Lens<Project, Backing?>(
      view: { $0.backing },
      set: { Project(backing: $0, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let blurb = Lens<Project, String>(
      view: { $0.blurb },
      set: { Project(backing: $1.backing, blurb: $0, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let category = Lens<Project, Category>(
      view: { $0.category },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $0, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let country = Lens<Project, Country>(
      view: { $0.country },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $0,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let creator = Lens<Project, User>(
      view: { $0.creator },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $0, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let dates = Lens<Project, Project.Dates>(
      view: { $0.dates },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $0, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let id = Lens<Project, Int>(
      view: { $0.id },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $0, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let location = Lens<Project, Location>(
      view: { $0.location },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $0,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let memberData = Lens<Project, Project.MemberData>(
      view: { $0.memberData },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $0, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let name = Lens<Project, String>(
      view: { $0.name },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $0, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards, slug: $1.slug,
        state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let personalization = Lens<Project, Project.Personalization>(
      view: { $0.personalization },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $0, photo: $1.photo, rewards: $1.rewards, slug: $1.slug,
        state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let photo = Lens<Project, Project.Photo>(
      view: { $0.photo },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $0, rewards: $1.rewards, slug: $1.slug,
        state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let rewards = Lens<Project, [Reward]?>(
      view: { $0.rewards },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $0, slug: $1.slug,
        state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let slug = Lens<Project, String>(
      view: { $0.slug },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $0, state: $1.state, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let state = Lens<Project, Project.State>(
      view: { $0.state },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $0, stats: $1.stats, urls: $1.urls, video: $1.video) }
    )

    public static let stats = Lens<Project, Project.Stats>(
      view: { $0.stats },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $0, urls: $1.urls, video: $1.video) }
    )

    public static let video = Lens<Project, Project.Video?>(
      view: { $0.video },
      set: { Project(backing: $1.backing, blurb: $1.blurb, category: $1.category, country: $1.country,
        creator: $1.creator, memberData: $1.memberData, dates: $1.dates, id: $1.id, location: $1.location,
        name: $1.name, personalization: $1.personalization, photo: $1.photo, rewards: $1.rewards,
        slug: $1.slug, state: $1.state, stats: $1.stats, urls: $1.urls, video: $0) }
    )
  }
}

extension LensType where Whole == Project, Part == User {
  public var avatar: Lens<Project, User.Avatar> {
    return Project.lens.creator • User.lens.avatar
  }

  public var id: Lens<Project, Int> {
    return Project.lens.creator • User.lens.id
  }

  public var name: Lens<Project, String> {
    return Project.lens.creator • User.lens.name
  }
}

extension LensType where Whole == Project, Part == Category {
  public var id: Lens<Project, Int> {
    return Project.lens.category • Category.lens.id
  }

  public var name: Lens<Project, String> {
    return Project.lens.category • Category.lens.name
  }

  public var parent: Lens<Project, Category?> {
    return Project.lens.category • Category.lens.parent
  }
}

extension LensType where Whole == Project, Part == Project.Stats {
  public var backersCount: Lens<Project, Int> {
    return Project.lens.stats • Project.Stats.lens.backersCount
  }

  public var commentsCount: Lens<Project, Int?> {
    return Project.lens.stats • Project.Stats.lens.commentsCount
  }

  public var goal: Lens<Project, Int> {
    return Project.lens.stats • Project.Stats.lens.goal
  }

  public var pledged: Lens<Project, Int> {
    return Project.lens.stats • Project.Stats.lens.pledged
  }

  public var updatesCount: Lens<Project, Int?> {
    return Project.lens.stats • Project.Stats.lens.updatesCount
  }

  public var fundingProgress: Lens<Project, Float> {
    return Project.lens.stats • Project.Stats.lens.fundingProgress
  }
}

extension LensType where Whole == Project, Part == Project.MemberData {
  public var lastUpdatePublishedAt: Lens<Project, NSTimeInterval?> {
    return Project.lens.memberData • Project.MemberData.lens.lastUpdatePublishedAt
  }

  public var unreadMessagesCount: Lens<Project, Int?> {
    return Project.lens.memberData • Project.MemberData.lens.unreadMessagesCount
  }

  public var unseenActivityCount: Lens<Project, Int?> {
    return Project.lens.memberData • Project.MemberData.lens.unseenActivityCount
  }
}

extension LensType where Whole == Project, Part == Project.Dates {
  public var deadline: Lens<Project, NSTimeInterval> {
    return Project.lens.dates • Project.Dates.lens.deadline
  }

  public var launchedAt: Lens<Project, NSTimeInterval> {
    return Project.lens.dates • Project.Dates.lens.launchedAt
  }

  public var potdAt: Lens<Project, NSTimeInterval?> {
    return Project.lens.dates • Project.Dates.lens.potdAt
  }

  public var stateChangedAt: Lens<Project, NSTimeInterval> {
    return Project.lens.dates • Project.Dates.lens.stateChangedAt
  }
}

extension LensType where Whole == Project, Part == Project.Personalization {
  public var isBacking: Lens<Project, Bool?> {
    return Project.lens.personalization • Project.Personalization.lens.isBacking
  }

  public var isStarred: Lens<Project, Bool?> {
    return Project.lens.personalization • Project.Personalization.lens.isStarred
  }
}

extension LensType where Whole == Project, Part == Project.Photo {
  public var full: Lens<Project, String> {
    return Project.lens.photo • Project.Photo.lens.full
  }

  public var med: Lens<Project, String> {
    return Project.lens.photo • Project.Photo.lens.med
  }

  public var size1024x768: Lens<Project, String> {
    return Project.lens.photo • Project.Photo.lens.size1024x768
  }

  public var small: Lens<Project, String> {
    return Project.lens.photo • Project.Photo.lens.small
  }
}

extension LensType where Whole == Project, Part == Project.MemberData {
  public var permissions: Lens<Whole, [Project.MemberData.Permission]> {
    return Whole.lens.memberData • Part.lens.permissions
  }
}
