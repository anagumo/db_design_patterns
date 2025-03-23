import Foundation
@testable import DBDesignPatterns

final class GetHeroUseCaseMock: GetHeroUseCaseProtocol {
    var receivedDataResponse: [HeroModel]?
    
    func run(name: String, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        guard let receivedDataResponse else {
            completion(.failure(HeroError.network("Server error")))
            return
        }
        
        guard let heroModel = receivedDataResponse.filter({ $0.name == name }).first else {
            completion(.failure(HeroError.notFound()))
            return
        }
        
        completion(.success(heroModel))
    }
}
