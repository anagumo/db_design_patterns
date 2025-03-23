import Foundation
@testable import DBDesignPatterns

final class GetHerosUseCaseMock: GetHerosUseCaseProtocol {
    var receivedResponseData: [HeroModel]?
    
    func run(completion: @escaping (Result<[HeroModel],Error>) -> Void) {
        guard let receivedResponseData else {
            completion(.failure(HeroError.network("Server error")))
            return
        }
        
        guard !receivedResponseData.isEmpty else {
            completion(.failure(HeroError.emptyList()))
            return
        }
        
        completion(.success(receivedResponseData))
    }
}
