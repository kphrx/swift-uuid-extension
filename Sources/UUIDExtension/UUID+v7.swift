// Copyright 2026 kPherox
// SPDX-License-Identifier: Apache-2.0

import struct Foundation.Date

extension UUID {
  public static func v7(_ time: Date) -> Self {
    let timestamp: Int = .init(time.timeIntervalSince1970 * 1000)

    return .init(
      uuid: (
        .init((timestamp >> 40) & 0xFF), .init((timestamp >> 32) & 0xFF),
        .init((timestamp >> 24) & 0xFF), .init((timestamp >> 16) & 0xFF),
        .init((timestamp >> 8) & 0xFF), .init(timestamp & 0xFF),
        (UInt8.random(in: 0...255) & 0x0F) | 0x70, .random(in: 0...255),
        (UInt8.random(in: 0...255) & 0x3F) | 0x80, .random(in: 0...255),
        .random(in: 0...255), .random(in: 0...255), .random(in: 0...255), .random(in: 0...255),
        .random(in: 0...255), .random(in: 0...255)
      ))
  }

  public static func v7() -> Self {
    if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
      .v7(Date.now)
    } else {
      .v7(Date())
    }
  }

  public struct V7: UUIDTimeBased {
    public var rawValue: UUID

    public var version: UUID.Version {
      .v7
    }

    public init() {
      self.rawValue = .v7()
    }

    public init?(rawValue: UUID) {
      guard case .v7 = rawValue.version else { return nil }
      self.rawValue = rawValue
    }

    public var timestamp: Int {
      .init(self.uuid.0) << 40 | .init(self.uuid.1) << 32 | .init(self.uuid.2) << 24 | .init(
        self.uuid.3) << 16 | .init(self.uuid.4) << 8 | .init(self.uuid.5)
    }

    public init(_ time: Date) {
      self.rawValue = .v7(time)
    }

    public func toDate() -> Date {
      .init(timeIntervalSince1970: .init(self.timestamp) / 1000)
    }
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UUID.V7: UUIDVariant {}
