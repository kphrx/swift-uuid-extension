import Testing

import struct Foundation.Calendar
import struct Foundation.Date

@testable import UUIDExtension

struct UUIDv7Tests {
  @Test func timestamp() throws {
    let now = Date.now
    let uuid = UUID.V7(now)
    #expect(Int(now.timeIntervalSince(uuid.toDate()) * 1000) == 0)
  }

  @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
  @Test func compare() throws {
    let now = Date.now
    let uuid1 = UUID.V7(now)
    let uuid2 = UUID.V7(try #require(Calendar.current.date(byAdding: .day, value: 1, to: now)))
    #expect(uuid1 < uuid2)
  }

  @Test func invalidVersion() throws {
    #expect(UUID.V7(rawValue: .init()) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-0000-8000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-1000-8000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-2000-9000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-3000-A000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-4000-B000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-5000-8000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-6000-9000-000000000000")) == nil)
    #expect(UUID.V7(rawValue: .init(uuidString: "00000000-0000-8000-B000-000000000000")) == nil)
  }
}
