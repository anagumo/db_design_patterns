import Foundation

protocol LikeHeroUseCaseProtocol {
    func run(identifier: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class LikeHeroUseCase: LikeHeroUseCaseProtocol {
    
    func run(identifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        LikeHeroAPIRequest(identifier: identifier).perform { result in
            do {
                let _ = try result.get()
                completion(.success(()))
            } catch let error as APIErrorResponse {
                completion(.failure(HeroError.network(error.message)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
