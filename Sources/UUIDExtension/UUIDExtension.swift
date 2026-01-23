@_exported import struct Foundation.UUID
import typealias Foundation.uuid_t

@available(iOS, deprecated: 17.0, renamed: "UUIDVariant")
@available(macOS, deprecated: 14.0, renamed: "UUIDVariant")
@available(tvOS, deprecated: 17.0, renamed: "UUIDVariant")
@available(watchOS, deprecated: 10.0, renamed: "UUIDVariant")
public protocol UUIDVariantBase: RawRepresentable, Hashable, Equatable, CustomStringConvertible,
  CustomDebugStringConvertible, Codable, Sendable
{
  var rawValue: UUID { get }

  var uuid: uuid_t { get }
  var uuidString: String { get }

  var version: UUID.Version { get }

  init?(rawValue: UUID?)
  init?(uuid: uuid_t)
  init?(uuidString: String)
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public protocol UUIDVariant: UUIDVariantBase, Comparable {}

extension UUIDVariantBase where RawValue == UUID {
  public var uuid: uuid_t {
    self.rawValue.uuid
  }

  public var uuidString: String {
    self.rawValue.uuidString
  }

  public init?(rawValue: UUID?) {
    guard let rawValue else { return nil }
    self.init(rawValue: rawValue)
  }

  public init?(uuid: uuid_t) {
    self.init(rawValue: .init(uuid: uuid))
  }

  public init?(uuidString: String) {
    self.init(rawValue: .init(uuidString: uuidString))
  }

  public var description: String {
    self.rawValue.description
  }

  public var debugDescription: String {
    self.rawValue.debugDescription
  }
}

extension UUIDVariantBase where Self: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue == rhs.rawValue
  }
}

extension UUIDVariantBase where Self: Hashable {
  public func hash(into hasher: inout Hasher) {
    self.rawValue.hash(into: &hasher)
  }
}

extension UUIDVariantBase where Self: Codable, RawValue == UUID {
  public init(from decoder: any Decoder) throws {
    let decoded = try decoder.singleValueContainer().decode(RawValue.self)
    guard let value = Self(rawValue: decoded) else {
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription:
            "Cannot initialize \(Self.self) from invalid \(RawValue.self) value \(decoded)"))
    }
    self = value
  }

  public func encode(to encoder: any Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(self.rawValue)
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
extension UUIDVariant where Self: Comparable {
  public static func < (lhs: Self, rhs: Self) -> Bool {
    lhs.rawValue < rhs.rawValue
  }
}
