//
//  ViewController.swift
//  browser
//
//  Created by Gabriel Millatiner on 28/05/2025.
//

import UIKit
import WebKit


// Being extended by FirstScreen+WKNavigationDelegate.swift
class BrowserViewController: UIViewController {
    var webView: WKWebView!
    var addressBar: UITextField!
    
    var notAllowedAlert: UIAlertController { let alert = UIAlertController(title: "Navigation Blocked", message: "Access to this website is not allowed.", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in NSLog("The \"OK\" navigation blocked alert occurred.") }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel action"), style: .cancel, handler: { _ in NSLog("The \"Cancel\" navigation blocked alert occurred.")}))
    return alert
        }
    
    let notAllowedURLs: [URL] = [
        URL(string: "https://ynet.co.il")!,
        URL(string: "https://google.com")!
    ]


    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddressBar()
        setupWebView()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
        setupLayoutConstraints()

        let url = URL(string: "https://www.duckduckgo.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    func setupWebView() {
        webView = WKWebView()
        // webView = WKWebView(frame: .init(x: 0, y:0, width:200, height:200), configuration: .init())
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupLayoutConstraints() {
        // Activate constraints for addressBar and webView here
        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -20),
            addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            addressBar.heightAnchor.constraint(equalToConstant: 40),

            webView.topAnchor.constraint(equalTo: addressBar.bottomAnchor, constant: 0),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupAddressBar() {
        addressBar = UITextField()
        addressBar.borderStyle = .roundedRect
        addressBar.autocapitalizationType = .none
        addressBar.autocorrectionType = .no
        addressBar.keyboardType = .URL
        addressBar.returnKeyType = .go
        addressBar.addTarget(self, action: #selector(loadURLFromAddressBar), for: .editingDidEndOnExit)
        
        // Create the 'Go' button for the address bar
        let goButton = UIButton(type: .system)
        goButton.setTitle("Go", for: .normal)
        goButton.addTarget(self, action: #selector(loadURLFromAddressBar), for: .touchUpInside)
        goButton.frame = CGRect(x: 0, y: 0, width: 50, height: 30) // Set a frame for the button
        goButton.configuration?.contentInsets = .zero

        addressBar.rightView = goButton
        addressBar.rightViewMode = .always // could also do .unlessEditing

        view.addSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func loadURLFromAddressBar() {
          guard var inputText = addressBar.text, !inputText.isEmpty else { return }
          // Check if the input text has a scheme, if not, prepend https://
        if !inputText.lowercased().hasPrefix("http://") && !inputText.lowercased().hasPrefix("https://") {
            inputText = "https://" + inputText
        }
        guard let url = URL(string: inputText) else { 
            print("Error: Could not create URL from \(inputText)")
            // Optionally, display an error to the user here if URL is invalid
            webView.loadHTMLString("<html><body><h1>Invalid URL</h1><p>Could not create a valid URL from the input: \(inputText)</p></body></html>", baseURL: nil)
            return 
        }
        print("Loading url \(url) from address bar ")
        webView.load(URLRequest(url: url))
    }

    @objc func goToNextScreen() {
        let nextScreen = SecondScreen()
        nextScreen.title = "Second Screen"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}
