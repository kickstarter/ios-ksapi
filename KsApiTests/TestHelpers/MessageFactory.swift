@testable import KsApi
import Prelude

extension Message {
  internal static let template = Message(
    body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam augue dolor, " +
      "accumsan nec aliquam a, porttitor sed dui. Integer iaculis ipsum fringilla metus " +
      "porttitor euismod. Donec in libero vitae lectus ultrices vehicula id eget dolor. " +
    "Nulla lacinia erat a ullamcorper sollicitudin.",
    createdAt: 123456789.0,
    id: 1,
    recipient: User.template,
    sender: User.template |> User.lens.id %~ { $0 + 1 }
  )
}
