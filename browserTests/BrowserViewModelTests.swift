import XCTest
@testable import browser // Assuming 'browser' is your module name

class BrowserViewModelTests: XCTestCase {

    var viewModel: BrowserViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = BrowserViewModelImpl()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    // MARK: - Tests for processUrl

    func testProcessUrl_withValidHttpsUrl_shouldSucceed() {
        let input = "https://www.example.com"
        let (success, urlString) = viewModel.processUrl(addressBarText: input)
        XCTAssertTrue(success, "processUrl should succeed for a valid https URL.")
        XCTAssertEqual(urlString, input, "The URL string should match the input.")
    }

    func testProcessUrl_withUrlMissingScheme_shouldAddHttpsAndSucceed() {
        let input = "example.com"
        let httpsString = "https://"
        let (success, urlString) = viewModel.processUrl(addressBarText: input)
        XCTAssertTrue(success, "processUrl should succeed by adding https scheme.")
        XCTAssertEqual(urlString, httpsString + input, "The URL string should have https prepended.")
    }

    func testProcessUrl_withEmptyString_shouldFail() {
        let input = ""
        let (success, _) = viewModel.processUrl(addressBarText: input)
        XCTAssertFalse(success, "processUrl should fail for an empty string.")
    }

    func testProcessUrl_withNilInput_shouldFail() {
        let (success, _) = viewModel.processUrl(addressBarText: nil)
        XCTAssertFalse(success, "processUrl should fail for nil input.")
    }

    func testProcessUrl_withInvalidUrlString_shouldFail() {
        let input = "this is not a url"
        let (success, urlString) = viewModel.processUrl(addressBarText: input)
        XCTAssertFalse(success, "processUrl should fail for an invalid URL string.")
        XCTAssertTrue(urlString.contains(input), "Error message should contain the invalid input.")
    }

    // MARK: - Tests for isURLBlocked
    
    func testIsURLBlocked_withBlockedUrls_shouldReturnTrue() {
        // Assuming "https://ynet.co.il" is in your notAllowedURLs list in BrowserViewModelImpl
        guard let blockedUrl1 = URL(string: "https://ynet.co.il") else {
            XCTFail("Failed to create URL for testing.")
            return
        }
        XCTAssertTrue(viewModel.isURLBlocked(blockedUrl1), "isURLBlocked should return true for \(blockedUrl1)")
        guard let blockedUrl2 = URL(string: "https://google.com") else {
            XCTFail("Failed to create URL for testing.")
            return
        }
        XCTAssertTrue(viewModel.isURLBlocked(blockedUrl2), "isURLBlocked should return true for \(blockedUrl2)")
    }

    func testIsURLBlocked_withAllowedUrl_shouldReturnFalse() {
        guard let allowedUrl = URL(string: "https://www.duckduckgo.com") else {
            XCTFail("Failed to create URL for testing.")
            return
        }
        XCTAssertFalse(viewModel.isURLBlocked(allowedUrl), "isURLBlocked should return false for an allowed URL.")
    }
}
