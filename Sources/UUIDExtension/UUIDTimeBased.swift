// Copyright 2026 kPherox
// SPDX-License-Identifier: Apache-2.0

import struct Foundation.Date

public protocol UUIDTimeBased: UUIDVariantBase {
  var timestamp: Int { get }

  init(_ time: Date)

  func toDate() -> Date
}
