//
//  CafeManuscritUITests.swift
//  CafeManuscritUITests
//
//  Created by 고재민 on 6/1/25.
//
import XCTest

final class CafeManuscritUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        
        // 테스트용 환경 설정
        app.launchEnvironment["UI_TESTING"] = "1"
        app.launchEnvironment["DISABLE_ANIMATIONS"] = "1"
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - 앱 실행 및 기본 화면 테스트
    
    @MainActor
    func testAppLaunch() throws {
        app.launch()
        
        // 로딩 화면 확인
        let logoImage = app.images["drop.fill"]
        XCTAssertTrue(logoImage.waitForExistence(timeout: 3))
        
        // 메인 화면으로 전환 확인
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
    }
    
    // MARK: - 네비게이션 테스트
    
    @MainActor
    func testTopNavigationBar() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 로고 확인
        let logoText = app.staticTexts["Cafe"]
        XCTAssertTrue(logoText.exists)
        
        let subtitleText = app.staticTexts["Manuscrit"]
        XCTAssertTrue(subtitleText.exists)
        
        // 검색창 확인
        let searchField = app.textFields["레시피를 찾아보세요..."]
        XCTAssertTrue(searchField.exists)
        
        // 프로필 버튼 확인
        let profileButton = app.buttons.containing(.image, identifier: "person").element
        XCTAssertTrue(profileButton.exists)
    }
    
    // MARK: - 탭 네비게이션 테스트
    
    @MainActor
    func testTabNavigation() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 각 탭 테스트
        let searchTab = app.tabBars.buttons["검색"]
        searchTab.tap()
        XCTAssertTrue(app.staticTexts["검색 화면"].exists)
        
        let writeTab = app.tabBars.buttons["레시피 작성"]
        writeTab.tap()
        XCTAssertTrue(app.staticTexts["레시피 작성"].exists)
        
        let bookmarkTab = app.tabBars.buttons["북마크"]
        bookmarkTab.tap()
        XCTAssertTrue(app.staticTexts["북마크"].exists)
        
        let profileTab = app.tabBars.buttons["프로필"]
        profileTab.tap()
        XCTAssertTrue(app.staticTexts["프로필"].exists)
        
        // 홈으로 돌아가기
        homeTab.tap()
        XCTAssertTrue(app.staticTexts["안녕하세요!"].exists)
    }
    
    // MARK: - 로그인 플로우 테스트
    
    @MainActor
    func testLoginFlow() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 프로필 버튼 탭 (비로그인 상태)
        let profileButton = app.buttons.containing(.image, identifier: "person").element
        profileButton.tap()
        
        // 로그인 화면 확인
        let loginTitle = app.staticTexts["Cafe Manuscrit"]
        XCTAssertTrue(loginTitle.waitForExistence(timeout: 3))
        
        let loginDescription = app.staticTexts["레시피를 공유하려면 로그인이 필요해요"]
        XCTAssertTrue(loginDescription.exists)
        
        // 로그인 버튼들 확인
        let appleLoginButton = app.buttons["Apple로 로그인"]
        XCTAssertTrue(appleLoginButton.exists)
        
        let googleLoginButton = app.buttons["Google로 로그인"]
        XCTAssertTrue(googleLoginButton.exists)
        
        let browseButton = app.buttons["로그인 없이 둘러보기"]
        XCTAssertTrue(browseButton.exists)
    }
    
    @MainActor
    func testAppleLogin() throws {
        app.launch()
        
        // 로그인 화면으로 이동
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        let profileButton = app.buttons.containing(.image, identifier: "person").element
        profileButton.tap()
        
        // Apple 로그인 버튼 탭
        let appleLoginButton = app.buttons["Apple로 로그인"]
        XCTAssertTrue(appleLoginButton.waitForExistence(timeout: 3))
        
        appleLoginButton.tap()
        
        // 로딩 상태 확인
        XCTAssertTrue(appleLoginButton.waitForExistence(timeout: 2))
        
        // 로그인 완료 후 메인 화면 복귀 확인 (더미 로그인이므로 1.5초 후)
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
    }
    
    // MARK: - 홈 화면 컨텐츠 테스트
    
    @MainActor
    func testHomeContent() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 환영 메시지 확인
        let welcomeText = app.staticTexts["안녕하세요!"]
        XCTAssertTrue(welcomeText.exists)
        
        let subtitleText = app.staticTexts["오늘은 어떤 커피를 드려보실까요?"]
        XCTAssertTrue(subtitleText.exists)
        
        // 추천 레시피 섹션 확인
        let featuredSection = app.staticTexts["✨ 오늘의 추천 레시피"]
        XCTAssertTrue(featuredSection.exists)
        
        // 최신 레시피 섹션 확인
        let recentSection = app.staticTexts["📝 최신 레시피"]
        XCTAssertTrue(recentSection.exists)
    }
    
    @MainActor
    func testRecipeCards() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 레시피 카드들 확인
        let firstRecipeTitle = app.staticTexts["황금비율 V60 레시피"]
        XCTAssertTrue(firstRecipeTitle.exists)
        
        let secondRecipeTitle = app.staticTexts["에티오피아 예가체프 특제"]
        XCTAssertTrue(secondRecipeTitle.exists)
        
        // 레시피 카드 탭 테스트
        firstRecipeTitle.tap()
        // TODO: 레시피 상세 화면 확인 (아직 구현되지 않음)
    }
    
    // MARK: - 검색 기능 테스트
    
    @MainActor
    func testSearchFunctionality() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 검색창 탭
        let searchField = app.textFields["레시피를 찾아보세요..."]
        searchField.tap()
        
        // 검색 화면으로 이동 확인
        let searchTab = app.tabBars.buttons["검색"]
        XCTAssertTrue(searchTab.isSelected)
    }
    
    // MARK: - 접근성 테스트
    
    @MainActor
    func testAccessibility() throws {
        app.launch()
        
        // 홈 화면까지 대기
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // VoiceOver 접근성 확인
        XCTAssertTrue(homeTab.isAccessibilityElement)
        XCTAssertEqual(homeTab.label, "홈")
        
        let searchTab = app.tabBars.buttons["검색"]
        XCTAssertTrue(searchTab.isAccessibilityElement)
        XCTAssertEqual(searchTab.label, "검색")
    }
    
    // MARK: - 성능 테스트
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testScrollPerformance() throws {
        app.launch()
        
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        let scrollView = app.scrollViews.firstMatch
        
        measure(metrics: [XCTOSSignpostMetric.scrollDecelerationMetric]) {
            scrollView.swipeUp()
            scrollView.swipeDown()
        }
    }
    
    // MARK: - 에러 상황 테스트
    
    @MainActor
    func testNetworkErrorHandling() throws {
        // 네트워크 오류 시뮬레이션을 위한 환경 설정
        app.launchEnvironment["SIMULATE_NETWORK_ERROR"] = "1"
        app.launch()
        
        let homeTab = app.tabBars.buttons["홈"]
        XCTAssertTrue(homeTab.waitForExistence(timeout: 5))
        
        // 네트워크 에러 상황에서도 앱이 크래시하지 않는지 확인
        // TODO: 실제 에러 처리 UI가 구현되면 해당 요소들 확인
    }
    
    // MARK: - 헬퍼 메서드들
    
    private func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) -> Bool {
        let predicate = NSPredicate(format: "exists == true")
        let expectation = expectation(for: predicate, evaluatedWith: element, handler: nil)
        let result = XCTWaiter.wait(for: [expectation], timeout: timeout)
        return result == .completed
    }
    
    private func takeScreenshot(name: String) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
