import Foundation

public extension String {
  var escapedXMLCharacters: String {
    #if os(macOS)
    return (CFXMLCreateStringByEscapingEntities(nil, String(self) as NSString, nil)! as NSString) as String
    #else
    return [
      ("&", "&amp;"),
      ("<", "&lt;"),
      (">", "&gt;"),
      ("'", "&apos;"),
      ("\"", "&quot;"),
    ].reduce(self) { (string, element) in
      string.replacingOccurrences(of: element.0, with: element.1)
    }
    #endif
  }
}
