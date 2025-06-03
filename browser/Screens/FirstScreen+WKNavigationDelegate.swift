//
//  FirstScreen+WKNavigationDelegate.swift
//  browser
//

import WebKit
import UIKit

extension URL {
    /// Returns a normalized host string for comparison, removing "www." and converting to lowercase.
    var normalizedHost: String? {
        guard var host = host else { return nil }
        if host.hasPrefix("www.") {
            host.removeFirst(4) // Remove "www."
        }
        return host.lowercased()
    }

    /// Checks if two URLs refer to the same base site, ignoring "www." and scheme.
    /// - Parameter otherURL: The other URL to compare against.
    /// - Returns: `true` if both URLs point to the same normalized host, `false` otherwise.
    func isSame(otherURL: URL) -> Bool {
        // If either URL doesn't have a host, they cannot be the same site.
        guard let selfHost = self.normalizedHost,
              let otherHost = otherURL.normalizedHost else {
            return false
        }
        return selfHost == otherHost
    }
}


extension FirstScreen: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
        print("Successfully loaded: \(webView.url?.absoluteString ?? "No URL")")
    }
     func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void
    ) {
        guard let currentURL = navigationAction.request.url else {
                // If there's no URL, allow it or handle as appropriate for your app
                decisionHandler(.cancel)
                self.present(notAllowedAlert, animated: true, completion: nil)
                return
            }
        if notAllowedURLs.first(where: { disallowedURL in
                currentURL.isSame(otherURL: disallowedURL)
            }) != nil {
            print("Not allowed URL: \(currentURL.absoluteString)")
            decisionHandler(.cancel)
            self.present(notAllowedAlert, animated: true, completion: nil)
            return
            }
        print("Allowed URL: \(currentURL.absoluteString)")
        decisionHandler(.allow)
        return
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