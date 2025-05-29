//
//  ViewController.swift
//  browser
//
//  Created by Gabriel Millatiner on 28/05/2025.
//

import UIKit
import WebKit

class FirstScreen: UIViewController, WKNavigationDelegate {
    let nextButton = UIButton()
    var webView: WKWebView!
    var addressBar: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "First Screen"
        setupAddressBar()
        setupWebView()
        setupNextButton()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground

        let url = URL(string: "https://www.wikipedia.org")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }

    func setupWebView() {
        webView = WKWebView()
        //         webView = WKWebView(frame: .init(x: 0, y:0, width:200, height:200), configuration: .init())
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            webView.bottomAnchor.constraint(equalTo: addressBar.topAnchor),
//        ])
    }

    func setupAddressBar() {
        addressBar = UITextField()
        addressBar.borderStyle = .roundedRect
        addressBar.autocapitalizationType = .none
        addressBar.autocorrectionType = .no
        addressBar.keyboardType = .URL
        addressBar.returnKeyType = .go
        addressBar.addTarget(self, action: #selector(loadURLFromAddressBar), for: .editingDidEndOnExit)
        view.addSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
    }

    func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.configuration = .filled()
        nextButton.configuration?.background.backgroundColor = .systemPink
        nextButton.configuration?.title = "Next"
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)

        NSLayoutConstraint.deactivate(nextButton.constraints)
        
        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            addressBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addressBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            addressBar.heightAnchor.constraint(equalToConstant: 40),

            webView.topAnchor.constraint(equalTo: addressBar.bottomAnchor, constant: 8),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50),

            webView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -8)
        ])
    }

    @objc func loadURLFromAddressBar() {
        guard let text = addressBar.text, let url = URL(string: text) else { return }
        print("Loading url \(url) from address bar ")
        webView.load(URLRequest(url: url))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        addressBar.text = webView.url?.absoluteString
    }

    @objc func goToNextScreen() {
        let nextScreen = SecondScreen()
        nextScreen.title = "Second Screen"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}
