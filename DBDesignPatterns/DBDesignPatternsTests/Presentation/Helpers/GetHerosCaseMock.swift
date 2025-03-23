import Foundation
@testable import DBDesignPatterns

final class GetHerosUseCaseMock: GetHerosUseCaseProtocol {
    var receivedData: [HeroModel]?
    
    func run(completion: @escaping (Result<[HeroModel],Error>) -> Void) {
        guard let receivedData else {
            completion(.failure(HeroError.network("Server error")))
            return
        }
        
        guard !receivedData.isEmpty else {
            completion(.failure(HeroError.emptyList()))
            return
        }
        
        completion(.success(receivedData))
    }
}
