import Foundation
import XCTest
@testable import DBDesignPatterns

final class HomeViewModelTests: XCTestCase {
    private var getHerosUseCaseMock: GetHerosUseCaseMock!
    private var sut: HomeViewModelProtocol?
    
    override func setUp() {
        super.setUp()
        getHerosUseCaseMock = GetHerosUseCaseMock()
        sut = HomeViewModel(getHeroUseCase: getHerosUseCaseMock)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Home Success Cases
    func test_when_usecase_state_is_success() {
        // Given
        getHerosUseCaseMock.receivedResponseData = MockAppData.givenHeroList
        let loadingExpectation = expectation(description: "View is loading")
        let successExpectation = expectation(description: "View has succeed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .ready:
                successExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHeros()
        
        // Then
        let herosCount = sut?.heros.count ?? .zero
        XCTAssertEqual(herosCount, 5)
        wait(for: [loadingExpectation, successExpectation], timeout: 3)
    }
    
    // MARK: - Home Failure Cases
    func test_when_use_case_state_is_error() {
        // Given
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case let .error(message):
                XCTAssertEqual(message, "Server error")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHeros()
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
    
    // MARK: - Home Edge Cases
    func test_when_usecase_state_is_emptylist_error() {
        // Given
        getHerosUseCaseMock.receivedResponseData = []
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case let .error(message):
                XCTAssertEqual(message, "Empty hero list")
                failureExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHeros()
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
}
