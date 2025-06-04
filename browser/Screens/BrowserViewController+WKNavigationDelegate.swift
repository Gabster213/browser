//
//  BrowserViewController+WKNavigationDelegate.swift
//  browser
//

import WebKit
import UIKit


let wikipediaURL = URL(string: "https://wikipedia.org")!

extension URL {
    var baseDomain: String? {
        guard let host = self.host?.lowercased() else { return nil }
        let parts = host.components(separatedBy: ".")
        guard parts.count >= 2 else { return nil }
        return parts.suffix(2).joined(separator: ".")
    }
    /// Checks if two URLs belong to the same base domain.
    func isSame(otherURL: URL) -> Bool {
        return self.baseDomain == otherURL.baseDomain
    }
}


extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let url = webView.url // Ideally maybe would move to a field on the class (updates on navigation)
        setAddressBarTxt(url: url?.absoluteString)
        if isWikipedia(url: url) {
            setPageBgColor()
        }
    }
    
    private func isWikipedia(url: URL?) -> Bool {
        return url?.isSame(otherURL: wikipediaURL) ?? false
    }

    private func setAddressBarTxt(url: String?) {
        addressBar.text = webView.url?.absoluteString
        print("Successfully loaded: \(webView.url?.absoluteString ?? "No URL")")
    }
    
    private func setPageBgColor() {
        let jsScript = "document.body.style.background = 'salmon'"
        webView.evaluateJavaScript(jsScript)
    }

     func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        guard let currentURL = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        let isMainFrame = navigationAction.targetFrame?.isMainFrame ?? false
        if viewModel.isURLBlocked(currentURL) && isMainFrame {
            self.present(notAllowedAlert, animated: true, completion: nil)
            decisionHandler(.cancel) // product decision whether to actually cancel nav here,or only not display the pop-up
            return
        } else {
            decisionHandler(.allow)
        }
    }

    // Called when an error occurs while starting to load data for the main frame.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("ERROR: Provisional navigation failed: \(error.localizedDescription)")
        print("Details: \(error)")
        let nsError = error as NSError
        let errorMessage = """
        <html>
        <body>
            <h1>Failed to Load Page</h1>
            <p>Could not load the page due to an error.</p>
            <p><strong>Error Code:</strong> \(nsError.code)</p>
            <p><strong>Domain:</strong> \(nsError.domain)</p>
            <p><strong>Description:</strong> \(error.localizedDescription)</p>
        </body>
        </html>
        """
        webView.loadHTMLString(errorMessage, baseURL: nil)
    }

    // Called when an error occurs during navigation.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("ERROR: Navigation failed: \(error.localizedDescription)")
        print("Details: \(error)")
        // Avoid reloading error page if it's a cancellation or already showing an error
        let nsError = error as NSError
        if nsError.code == NSURLErrorCancelled { return }
        let errorMessage = """
        <html>
        <body>
            <h1>Navigation Error</h1>
            <p>An error occurred while navigating.</p>
            <p><strong>Error Code:</strong> \(nsError.code)</p>
            <p><strong>Domain:</strong> \(nsError.domain)</p>
            <p><strong>Description:</strong> \(error.localizedDescription)</p>
        </body>
        </html>
        """
        webView.loadHTMLString(errorMessage, baseURL: nil)
    }
}
