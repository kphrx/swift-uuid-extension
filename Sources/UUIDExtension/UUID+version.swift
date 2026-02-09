// Copyright 2025 kPherox
// SPDX-License-Identifier: Apache-2.0

import struct Foundation.UUID

extension UUID {
  public enum Version {
    case v0
    case v1
    case v2
    case v3
    case v4
    case v5
    case v6
    case v7
    case v8
    case v9
    case v10
    case v11
    case v12
    case v13
    case v14
    case v15
  }

  public var version: Version {
    switch self.uuid.6 & 0xF0 {
    case 0x10: .v1
    case 0x20: .v2
    case 0x30: .v3
    case 0x40: .v4
    case 0x50: .v5
    case 0x60: .v6
    case 0x70: .v7
    case 0x80: .v8
    case 0x90: .v9
    case 0xA0: .v10
    case 0xB0: .v11
    case 0xC0: .v12
    case 0xD0: .v13
    case 0xE0: .v14
    case 0xF0: .v15
    default: .v0
    }
  }
}
