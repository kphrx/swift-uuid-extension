import Testing

import class Foundation.JSONDecoder

@testable import UUIDExtension

struct CustomUUID: UUIDVariantBase {
  let rawValue: UUID

  var version: UUID.Version {
    self.rawValue.version
  }

  init?(rawValue: UUID) {
    guard rawValue.uuid.0 != 0 else { return nil }
    self.rawValue = rawValue
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension CustomUUID: UUIDVariant {}

struct UUIDExtensionTests {
  @Test func uuidVariant() async throws {
    let customUUIDFromString = try #require(
      CustomUUID(uuidString: "C232AB00-9414-11EC-B3C8-9E6BDECED846"))
    let customUUIDFromTuple = try #require(
      CustomUUID(
        uuid: (
          0xC2, 0x32, 0xAB, 0x00, 0x94, 0x14, 0x11, 0xEC, 0xB3, 0xC8, 0x9E, 0x6B, 0xDE, 0xCE, 0xD8,
          0x46
        )))

    #expect(customUUIDFromString == customUUIDFromTuple)
    #expect(customUUIDFromString.uuidString == "C232AB00-9414-11EC-B3C8-9E6BDECED846")
    #expect(customUUIDFromString.uuid.0 == 0xC2)
  }

  @Test func hashableUUID() async throws {
    let customUUID = try #require(
      CustomUUID(uuidString: "C232AB00-9414-11EC-B3C8-9E6BDECED846"))
    var uuids: Set<CustomUUID> = try [
      #require(.init(uuidString: "C232AB00-9414-11EC-B3C8-9E6BDECED846")),
      #require(.init(uuidString: "C232AB00-9414-11EC-B3C8-9E6BDECED846")),
    ]
    uuids.insert(customUUID)
    #expect(uuids.contains(customUUID))
    #expect(uuids.count == 1)
  }

  @Test func decodeError() async throws {
    let error = try #require(throws: DecodingError.self) {
      try JSONDecoder().decode(
        CustomUUID.self, from: .init("\"00000000-0000-0000-0000-000000000000\"".utf8))
    }

    if case .dataCorrupted(let errorContext) = error {
      #expect(
        errorContext.debugDescription
          == "Cannot initialize CustomUUID from invalid UUID value 00000000-0000-0000-0000-000000000000"
      )
    } else {
      Issue.record("Expected a DecodingError.dataCorrupted from \(error).")
    }
  }

  @Test func invalidUUIDString() async throws {
    #expect(CustomUUID(uuidString: "") == nil)
  }
}

struct CheckVersion {
  @Test func foundationUUID() async throws {
    let uuid = UUID()
    #expect(uuid.version == .v4)
  }

  @Test func version1() async throws {
    let uuid = UUID(uuidString: "C232AB00-9414-11EC-B3C8-9E6BDECED846")
    #expect(uuid?.version == .v1)
  }

  @Test func version3() async throws {
    let uuid = UUID(uuidString: "5df41881-3aed-3515-88a7-2f4a814cf09e")
    #expect(uuid?.version == .v3)
  }

  @Test func version4() async throws {
    let uuid = UUID(uuidString: "919108f7-52d1-4320-9bac-f847db4148a8")
    #expect(uuid?.version == .v4)
  }

  @Test func version5() async throws {
    let uuid = UUID(uuidString: "2ed6657d-e927-568b-95e1-2665a8aea6a2")
    #expect(uuid?.version == .v5)
  }

  @Test func version6() async throws {
    let uuid = UUID(uuidString: "1EC9414C-232A-6B00-B3C8-9F6BDECED846")
    #expect(uuid?.version == .v6)
  }

  @Test func version7() async throws {
    let uuid = UUID(uuidString: "017F22E2-79B0-7CC3-98C4-DC0C0C07398F")
    #expect(uuid?.version == .v7)
  }

  @Test func version8() async throws {
    let uuidTimeBased = UUID(uuidString: "2489E9AD-2EE2-8E00-8EC9-32D5F69181C0")
    let uuidNameBased = UUID(uuidString: "5C146B14-3C52-8AFD-938A-375D0DF1FBF6")
    #expect(uuidTimeBased?.version == .v8)
    #expect(uuidNameBased?.version == .v8)
  }
}
