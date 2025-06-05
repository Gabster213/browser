import UIKit
import WebKit
import DomainParser

let domainParser = try? DomainParser()
let wikipediaURL = URL(string: "https://wikipedia.org")!

// MARK: - Navigation Helpers
extension BrowserViewController {
    func isWikipedia(url: URL?) -> Bool {
        return url?.isSame(otherURL: wikipediaURL) ?? false
    }

    func setAddressBarTxt(url: String?) {
        addressBar.text = webView.url?.absoluteString
        print("Successfully loaded: \(webView.url?.absoluteString ?? "No URL")")
    }
    
    func setPageBgColor() {
        let jsScript = "document.body.style.background = 'salmon'"
        webView.evaluateJavaScript(jsScript)
    }
}
