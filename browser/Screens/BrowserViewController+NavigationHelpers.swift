import UIKit
import WebKit
import DomainParser

let domainParser = try? DomainParser()
let rpaTargetUrls : [URL] = [URL(string: "https://ynetnews.com")! , URL(string: "https://wikipedia.org")!, URL(string: "https://www.rottentomatoes.com")!, URL(string: "https://wix.com")!]

// MARK: - Navigation Helpers
extension BrowserViewController {
    func isRpaEnabled(url: URL) -> Bool {
        return rpaTargetUrls.contains(where: {maybeRpaUrl in url.isSame(otherURL: maybeRpaUrl)})
    }

    func setAddressBarTxt() {
        addressBar.text = webView.url?.absoluteString
        print("Successfully loaded: \(webView.url?.absoluteString ?? "No URL")")
    }
    
    func setPageBgColor() {
        let jsScript = """
        document.body.style.background = 'salmon';
        """
        webView.evaluateJavaScript(jsScript)
        print("Finished injecting RPA")
    }
}
