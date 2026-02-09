// Copyright 2026 kPherox
// SPDX-License-Identifier: Apache-2.0

extension UUID {
  public static func v4() -> Self {
    .init()
  }

  public struct V4: UUIDVariantBase {
    public var rawValue: UUID

    public var version: UUID.Version {
      .v4
    }

    public init() {
      self.rawValue = .v4()
    }

    public init?(rawValue: UUID) {
      guard case .v4 = rawValue.version else { return nil }
      self.rawValue = rawValue
    }
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UUID.V4: UUIDVariant {}
