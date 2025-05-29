//
//  ViewController.swift
//  browser
//
//  Created by Gabriel Millatiner on 28/05/2025.
//

import UIKit

class FirstScreen: UIViewController {
    let nextButton = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "First Screen"
        setupNextButton()
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    func setupNextButton() {
        view.addSubview(nextButton)
        nextButton.configuration = .filled()
        nextButton.configuration?.background.backgroundColor = .systemPink
        nextButton.configuration?.title = "Next"
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.addTarget(self, action: #selector(goToNextScreen), for: .touchUpInside)
        NSLayoutConstraint.activate([
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 200),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    @objc func goToNextScreen() {
        let nextScreen = SecondScreen()
        nextScreen.title = "Second Screen"
        navigationController?.pushViewController(nextScreen, animated: true)
    }
}
