import Foundation
@testable import DBDesignPatterns

final class GetHeroUseCaseMock: GetHeroUseCaseProtocol {
    var receivedData: [HeroModel]?
    
    func run(name: String, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        guard let receivedData else {
            completion(.failure(HeroError.network("Server error")))
            return
        }
        
        guard let heroModel = receivedData.filter({ $0.name == name }).first else {
            completion(.failure(HeroError.notFound()))
            return
        }
        
        completion(.success(heroModel))
    }
}
