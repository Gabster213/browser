import XCTest
@testable import browser

class BrowserViewControllerNavigationHelpersTests: XCTestCase {
    var viewController: BrowserViewController!
    let rpaTargetUrlsStrings: [String] = [
        "https://ynetnews.com",
        "https://wikipedia.org",
        "https://www.rottentomatoes.com",
        "https://wix.com"
    ]

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewController = BrowserViewController()
    }

    override func tearDownWithError() throws {
        viewController = nil
        try super.tearDownWithError()
    }

    func testIsRpaEnabled_withMatchingRpaUrl_shouldReturnTrue() {
        for urlString in rpaTargetUrlsStrings {
            guard let url = URL(string: urlString) else {
                XCTFail("Failed to create URL from string: \(urlString)")
                continue
            }
            XCTAssertTrue(viewController.isRpaEnabled(url: url), "isRpaEnabled should return true for RPA target URL: \(urlString)")
        }
    }

    func testIsRpaEnabled_withNonRpaUrl_shouldReturnFalse() {
        let nonRpaUrlStrings = [
            "https://www.moommo.hapara.com",
            "https://www.icq.com",
            "https://gabster.com"
        ]
        for urlString in nonRpaUrlStrings {
            guard let url = URL(string: urlString) else {
                XCTFail("Failed to create URL from string: \(urlString)")
                continue
            }
            XCTAssertFalse(viewController.isRpaEnabled(url: url), "isRpaEnabled should return false for non-RPA URL: \(urlString)")
        }
    }
    
    func testIsRpaEnabled_withUrlHavingPathForRpaTarget_shouldReturnTrue() {
        // This test depends on URL.isSame, defined in URL+Extensions.
        // Assumes URL(string: "https://wikipedia.org/wiki/Swift").isSame("https://wikipedia.org") -> true
        guard let url = URL(string: "https://wikipedia.org/wiki/Swift") else {
            XCTFail("Failed to create URL for testing.")
            return
        }
        XCTAssertTrue(viewController.isRpaEnabled(url: url), "isRpaEnabled should return true for an RPA target URL with a path, if isSame matches hosts.")
    }
} 
