import struct Foundation.Date

public protocol UUIDTimeBased: UUIDVariantBase {
  var timestamp: Int { get }

  init(_ time: Date)

  func toDate() -> Date
}
