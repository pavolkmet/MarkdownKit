import Foundation

extension Collection where Element == AttributedString {

    // MARK: - Computed Properties - Internal

    /// Concatenates the attributed strings in collection order.
    var concatenated: AttributedString {
        reduce(into: AttributedString()) { result, value in
            result.append(value)
        }
    }

    // MARK: - Helper Methods - Internal

    /// Joins non-empty attributed strings with the supplied separator.
    func joined(separator: AttributedString) -> AttributedString {
        reduce(into: AttributedString()) { result, value in
            guard !value.characters.isEmpty else {
                return
            }

            if !result.characters.isEmpty {
                result.append(separator)
            }
            result.append(value)
        }
    }
}
