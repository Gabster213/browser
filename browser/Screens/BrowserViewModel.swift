import UIKit
import WebKit

enum NavigationPolicy {
    case allow // Simply allow navigation
    case blockAndShowStandardAlert // Block and tell the View to show its standard 'notAllowedAlert'
    // Future extension:
    // case blockAndShowCustomAlert(title: String, message: String) // Block and provide custom alert details
    // case redirectTo(url: URL) // Redirect to a different URL
}
class BrowserViewModel {
    private let notAllowedURLs: [URL] = [
        URL(string: "https://ynet.co.il")!,
        URL(string: "https://google.com")!
    ]
    
    func processUrl(addressBarText url: String?) -> (success: Bool, url: String) {
        guard var inputText = url, !inputText.isEmpty else { return (success: false, url: "") }
      if !inputText.lowercased().hasPrefix("http://") && !inputText.lowercased().hasPrefix("https://") {
          inputText = "https://" + inputText
      }
      guard let url = URL(string: inputText) else {
          print("Error: Could not create URL from \(inputText)")
          return (success: false, url: "<html><body><h1>Invalid URL</h1><p>Could not create a valid URL from the input: \(inputText)</p></body></html>")
      }
      print("Loading url \(url) from address bar ")
      return (success: true, url: url.absoluteString)
    }
    
    func isURLBlocked(_ url: URL) -> Bool {
        if notAllowedURLs.first(where: { disallowedURL in url.isSame(otherURL: disallowedURL) }) != nil {
            return true
        }
        return false
    }
}
