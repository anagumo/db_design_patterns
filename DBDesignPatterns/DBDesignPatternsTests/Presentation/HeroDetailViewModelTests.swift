import Foundation
import XCTest
@testable import DBDesignPatterns

final class HeroDetailViewModelTests: XCTestCase {
    private var getHeroUseCaseMock: GetHeroUseCaseMock!
    private var sut: HeroDetailViewModel?
    
    override func setUp() {
        getHeroUseCaseMock = GetHeroUseCaseMock()
        sut = HeroDetailViewModel(
            getHeroUseCase: getHeroUseCaseMock,
            likeHeroUseCase: LikeHeroUseCase()
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Get Hero Success Cases
    func test_when_usecase_state_is_success() {
        // Given
        getHeroUseCaseMock.receivedData = MockAppData.givenHeroList
        let loadingExpectation = expectation(description: "View is loading")
        let successExpectation = expectation(description: "View has succeed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case let .success(heroModel):
                XCTAssertTrue(!heroModel.name.isEmpty)
                successExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHero(name: "Piccolo")
        
        // Then
        wait(for: [loadingExpectation, successExpectation], timeout: 3)
    }
    
    // MARK: - Get Hero Failure Cases
    func test_when_usecase_state_is_hero_not_found() {
        getHeroUseCaseMock.receivedData = MockAppData.givenHeroList
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case let .fullScreenError(message):
                XCTAssertEqual(message, "Hero not found")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHero(name: "Gohan") // :(
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
    
    func test_when_usecase_state_is_failure() {
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case let .fullScreenError(message):
                XCTAssertEqual(message, "Server error")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHero(name: "Goku")
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
}

