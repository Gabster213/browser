import WebKit
import UIKit

extension BrowserViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let url = webView.url // Ideally maybe would move to a field on the class (updates on navigation)
        setAddressBarTxt(url: url?.absoluteString)
        if isWikipedia(url: url) {
            setPageBgColor()
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping @MainActor (WKNavigationActionPolicy) -> Void) {
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
}
