import Foundation
import XCTest
@testable import DBDesignPatterns

final class HeroDetailViewModelTests: XCTestCase {
    private var getHeroUseCaseMock: GetHeroUseCaseMock!
    private var markHeroAsFavoriteUseCaseMock: MarkHeroAsFavoriteUseCaseMock!
    private var sut: HeroDetailViewModel?
    
    override func setUp() {
        getHeroUseCaseMock = GetHeroUseCaseMock()
        markHeroAsFavoriteUseCaseMock = MarkHeroAsFavoriteUseCaseMock()
        sut = HeroDetailViewModel(
            getHeroUseCase: getHeroUseCaseMock,
            markHeroAsFavoriteUseCase: markHeroAsFavoriteUseCaseMock
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Get Hero Success Cases
    func test_when_loadhero_usecase_state_is_success() {
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
    func test_when_loadhero_usecase_is_hero_not_found_error() {
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
    
    func test_when_loadhero_usecase_state_is_error() {
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
    
    // MARK: - Mark As Favorite Success Cases
    func test_when_markasfavorite_usecase_state_is_favorite() {
        // Given
        sut?.hero = MockAppData.givenHeroList.filter { $0.name == "Goku" }.first
        markHeroAsFavoriteUseCaseMock.receivedResponseData = MockAppData.givenHeroLikeData()
        let successExpectation = expectation(description: "View has succeed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            if state == .favorite {
                successExpectation.fulfill()
            }
        })
        sut?.markHeroAsFavorite()
        
        // Then
        wait(for: [successExpectation], timeout: 3)
    }
    
    // MARK: - Mark As Favorite Failure Cases
    func test_when_markasfavorite_usecase_state_is_favorite_error() {
        // Given
        sut?.hero = MockAppData.givenHeroList.filter { $0.name == "Piccolo" }.first
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case let .inlineError(message):
                XCTAssertEqual(message, "You have already marked this hero as favorite")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.markHeroAsFavorite()
        
        // Then
        wait(for: [failureExpectation], timeout: 3)
    }
    
    func test_when_markasfavorite_usecase_state_is_error() {
        // Given
        sut?.hero = MockAppData.givenHeroList.filter { $0.name == "Goku" }.first
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case let .inlineError(message):
                XCTAssertEqual(message, "Server error")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.markHeroAsFavorite()
        
        // Then
        wait(for: [failureExpectation], timeout: 3)
    }
}

