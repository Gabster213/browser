//
//  FirstScreen+WKNavigationDelegate.swift
//  browser
//

import WebKit
import UIKit

extension FirstScreen: WKNavigationDelegate {

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
        print("Successfully loaded: \(webView.url?.absoluteString ?? "No URL")")
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