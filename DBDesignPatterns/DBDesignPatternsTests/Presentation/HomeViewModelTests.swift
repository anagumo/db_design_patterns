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
    func test_when_use_case_state_is_success() {
        // Given
        getHerosUseCaseMock.receivedData = MockAppData.givenHeroList
        let loadingExpectation = expectation(description: "View is loading")
        let successExpectation = expectation(description: "View has succeed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .success(let heroList):
                XCTAssertEqual(heroList.count, 5)
                successExpectation.fulfill()
            default:break
            }
        })
        sut?.loadHeros()
        
        // Then
        wait(for: [loadingExpectation, successExpectation], timeout: 3)
    }
    
    // MARK: - Home Failure Cases
    func test_when_use_case_state_is_failure() {
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
    func test_when_usecase_state_is_empty() {
        // Given
        getHerosUseCaseMock.receivedData = []
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
