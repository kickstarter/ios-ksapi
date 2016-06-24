import XCTest
@testable import KsApi
@testable import Argo

final class ProjectStatsEnvelopeTests: XCTestCase {
  // swiftlint:disable function_body_length
  func testJSONDecoding() {
    let json: [String: AnyObject] = [
      "referral_distribution": [
        [
          "code": "my_wonderful_referrer_code",
          "referrer_name": "My wonderful referrer name",
          "percentage_of_dollars": "0.250",
          "referrer_type": "Wonderful",
          "pledged": "20.0",
          "backers_count": 8
        ],
        [
          "code": "my_okay_referrer_code",
          "referrer_name": "My okay referrer name",
          "percentage_of_dollars": "0.001",
          "referrer_type": "Okay",
          "pledged": "1.0",
          "backers_count": 1
        ]
      ],
      "reward_distribution": [
        [
          "pledged": "1.0",
          "reward_id": 0,
          "backers_count": 5,
          "minimum": "0.0"
        ],
        [
          "pledged": "25.0",
          "reward_id": 123456,
          "backers_count": 10,
          "minimum": "5.0"
        ]
      ],
      "cumulative": [
        "pledged": "40.0",
        "average_pledge": 17.38,
        "percent_raised": 2.666666666666667,
        "backers_count": 20,
        "goal": "15.0"
      ],
      "funding_distribution": [
        [
          "cumulative_backers_count": 7,
          "cumulative_pledged": "30",
          "pledged": "38.0",
          "date": 555444333,
          "backers_count": 13
        ],
        [
          "cumulative_backers_count": 14,
          "cumulative_pledged": 1000,
          "pledged": "909.0",
          "date": 333222111,
          "backers_count": 1
        ]
      ],
      "video_stats": [
        "external_completions": 5,
        "external_starts": 14,
        "internal_completions": 10,
        "internal_starts": 14
      ]
    ]

    let stats = ProjectStatsEnvelope.decodeJSONDictionary(json)
    XCTAssertNotNil(stats)

    XCTAssertEqual(40, stats.value?.cumulative.pledged)
    XCTAssertEqual(17, stats.value?.cumulative.averagePledge)
    XCTAssertEqual(20, stats.value?.cumulative.backersCount)

    XCTAssertEqual(5, stats.value?.videoStats?.externalCompletions)
    XCTAssertEqual(14, stats.value?.videoStats?.internalStarts)

    let fundingDistributions = stats.value?.fundingDistribution ?? []
    let rewardDistributions = stats.value?.rewardDistribution ?? []
    let referralDistributions = stats.value?.referralDistribution ?? []

    XCTAssertEqual(7, fundingDistributions[0].cumulativeBackersCount)
    XCTAssertEqual(14, fundingDistributions[1].cumulativeBackersCount)

    XCTAssertEqual("my_wonderful_referrer_code", referralDistributions[0].code)
    XCTAssertEqual(8, referralDistributions[0].backersCount)
    XCTAssertEqual("my_okay_referrer_code", referralDistributions[1].code)
    XCTAssertEqual(1, referralDistributions[1].backersCount)

    XCTAssertEqual(0, rewardDistributions[0].id)
    XCTAssertEqual(123456, rewardDistributions[1].id)

  }
  // swiftlint:enable function_body_length

  func testJSONDecoding_MissingData() {
    let json: [String: AnyObject] = [
      "referral_distribution": [
      ],
      "reward_distribution": [
      ],
      "cumulative": [
      ],
      "funding_distribution": [
      ],
      "video_stats": [
      ]
    ]

    let stats = ProjectStatsEnvelope.decodeJSONDictionary(json)

    XCTAssertNil(stats.value?.cumulative)
    XCTAssertNil(stats.value?.fundingDistribution)
    XCTAssertNil(stats.value?.referralDistribution)
    XCTAssertNil(stats.value?.rewardDistribution)
    XCTAssertNil(stats.value?.videoStats)
  }
}
