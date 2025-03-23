import Foundation
@testable import DBDesignPatterns

final class MarkHeroAsFavoriteUseCaseMock: LikeHeroUseCaseProtocol {
    var receivedResponseData: Data?
    
    func run(identifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard receivedResponseData != nil else {
            completion(.failure(HeroError.network("Server error")))
            return
        }
        
        completion(.success(()))
    }
}
