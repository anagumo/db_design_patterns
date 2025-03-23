import Foundation

protocol MarkHeroAsFavoriteUseCaseProtocol {
    /// Runs a hero like
    /// - Parameters:
    ///   - identifier: an object of type `(String)` that represents the hero id
    ///   - completion: a clossure of type `((Result<Void, Error>) -> Void)` that represents the data result and returns either empty data or an error
    func run(identifier: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class MarkHeroAsFavoriteUseCase: MarkHeroAsFavoriteUseCaseProtocol {
    
    func run(identifier: String, completion: @escaping (Result<Void, Error>) -> Void) {
        
        MarkHeroAsFavoriteAPIRequest(identifier: identifier).perform { result in
            do {
                let _ = try result.get()
                completion(.success(()))
            } catch let error as APIErrorResponse {
                completion(.failure(HeroError.network(error.message)))
            } catch {
                completion(.failure(HeroError.uknown()))
            }
        }
    }
}
