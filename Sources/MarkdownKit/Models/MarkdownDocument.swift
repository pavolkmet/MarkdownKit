import Foundation
import Markdown

/// An immutable, reusable Markdown document that can be decoded and parsed away from the UI.
///
/// `MarkdownDocument` decodes from and encodes to a single Markdown string, so it can be used
/// directly by a response model whose JSON value is a string:
///
/// ```swift
/// struct PostResponse: Decodable, Sendable {
///     let text: MarkdownDocument
/// }
/// ```
///
/// Parsing happens once during initialization or decoding. Rendering remains separate, allowing
/// ``MarkdownText`` and ``MarkdownRenderer`` to apply the current appearance and visitors without
/// parsing the source again.
///
/// The underlying `swift-markdown` tree is documented as an immutable, persistent, thread-safe,
/// copy-on-write value. It is kept internal and immutable so this wrapper can safely provide
/// `Sendable` behavior while `swift-markdown` does not declare that conformance itself.
///
/// Equality and hashing use the exact original source because the parsed tree is derived entirely
/// from that value. Documents with identical rendered output but different Markdown source remain
/// distinct.
public struct MarkdownDocument: Codable, Hashable, @unchecked Sendable {

    // MARK: - Properties - Public

    /// The original Markdown source used for lossless Codable round trips.
    public let source: String

    // MARK: - Properties - Internal

    let document: Document

    // MARK: - Initialization - Public

    /// Parses Markdown source into a reusable document.
    ///
    /// Kept out of line so optimized clients call MarkdownKit instead of inlining the
    /// `swift-markdown` parser call, which would leave them with an undefined `Markdown` symbol
    /// when they link only the `MarkdownKit` product.
    @inline(never)
    public init(parsing source: String) {
        self.source = source
        self.document = Document(parsing: source)
    }

    /// Decodes and parses a document from a single Markdown string.
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.init(parsing: try container.decode(String.self))
    }

    // MARK: - Helper Methods - Public

    /// Encodes the exact Markdown source as a single string.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(source)
    }

    // MARK: - Equatable

    /// Returns whether two documents contain the same original Markdown source.
    public static func == (lhs: MarkdownDocument, rhs: MarkdownDocument) -> Bool {
        lhs.source == rhs.source
    }

    // MARK: - Hashable

    /// Hashes the original Markdown source that defines the document's identity.
    public func hash(into hasher: inout Hasher) {
        hasher.combine(source)
    }
}
