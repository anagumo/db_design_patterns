import Foundation

protocol GetHerosUseCaseProtocol {
    func run(completion: @escaping (Result<[Hero], Error>) -> Void)
}

final class GetHerosUseCase: GetHerosUseCaseProtocol {
    
    func run(completion: @escaping (Result<[Hero], any Error>) -> Void) {
        GetHerosAPIRequest().perform { result in
            do {
                let decodedHeros = try result.get()
                // Apply the mapper pattern design to transform an api model to domain one
                let mapper = HeroDTOToHeroModelMapper()
                let heros = decodedHeros.map { mapper.map($0) }
                completion(.success(heros))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
}
