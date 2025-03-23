import Foundation
import XCTest
@testable import DBDesignPatterns

final class LoginViewModelTests: XCTestCase {
    private var loginUseCaseMock: LoginUseCaseMock!
    private var sut: LoginViewModelProtocol?
    
    override func setUp() {
        super.setUp()
        loginUseCaseMock = LoginUseCaseMock()
        sut = LoginViewModel(loginUseCase: loginUseCaseMock)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Login Success Cases
    func test_when_usecase_state_is_success() {
        // Given
        loginUseCaseMock.receivedData = LoginDataMock.givenJWTData()
        let loadingExpectation = expectation(description: "View is loading")
        let successExpectation = expectation(description: "View has succeed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            if state == .loading {
                loadingExpectation.fulfill()
            } else if state == .success {
                successExpectation.fulfill()
            }
        })
        sut?.login(username: "regularuser@keepcoding.es", password: "123456")
        
        // Then
        wait(for: [loadingExpectation, successExpectation], timeout: 3)
    }
    
    // MARK: Login Failure Cases
    func test_when_usecase_state_is_regex_failure() {
        // Given
        loginUseCaseMock.receivedData = LoginDataMock.givenJWTData()
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .inlineError(let regexLintError):
                XCTAssertEqual(regexLintError, .email)
                failureExpectation.fulfill()
            default: break
            }
        })
        sut?.login(username: "regularuser", password: "123456")
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
    
    func test_when_usecase_state_is_failure() {
        // Given
        let loadingExpectation = expectation(description: "View is loading")
        let failureExpectation = expectation(description: "View has failed")
        
        // When
        sut?.onStateChanged.bind(completion: { state in
            switch state {
            case .loading:
                loadingExpectation.fulfill()
            case .fullScreenError(let message):
                XCTAssertEqual(message, "Server error")
                failureExpectation.fulfill()
            default: break
            }
        })
        sut?.login(username: "regularuser@keepcoding.es", password: "123456")
        
        // Then
        wait(for: [loadingExpectation, failureExpectation], timeout: 3)
    }
}
