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
public struct MarkdownDocument: Codable, @unchecked Sendable {

    // MARK: - Properties - Public

    /// The original Markdown source used for lossless Codable round trips.
    public let source: String

    // MARK: - Properties - Internal

    let document: Document

    // MARK: - Initialization - Public

    /// Parses Markdown source into a reusable document.
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
}
