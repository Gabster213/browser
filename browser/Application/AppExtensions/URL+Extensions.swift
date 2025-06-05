//
//  URL+Extensions.swift
//  browser
//
//  Created by Gabriel Millatiner on 05/06/2025.
//
import UIKit
import WebKit

extension URL {
    var baseDomain: String? {
        return extractDomain(url: self)
    }
    
    func extractDomain(url: URL) -> String? {
        guard let host = url.host?.lowercased() else { return nil }
        return domainParser?.parse(host: host)?.domain
    }
    /// Checks if two URLs belong to the same base domain.
    func isSame(otherURL: URL) -> Bool {
        return self.baseDomain == extractDomain(url: otherURL)
    }
}
