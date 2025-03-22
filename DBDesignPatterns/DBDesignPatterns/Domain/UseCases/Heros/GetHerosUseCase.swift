import Foundation

protocol GetHerosUseCaseProtocol {
    /// Runs a get hero list
    /// - Parameter completion: a clossure of type `((Result<[HeroModel], HeroError>) -> Void)` that represents the data result and returns either a hero list or an error
    func run(completion: @escaping (Result<[HeroModel], Error>) -> Void)
}

final class GetHerosUseCase: GetHerosUseCaseProtocol {
    
    func run(completion: @escaping (Result<[HeroModel], Error>) -> Void) {
        GetHerosAPIRequest().perform { result in
            do {
                let decodedHeros = try result.get()
                // Apply the Mapper design pattern to transform an api dto to a domain model
                let mapper = HeroDTOToHeroModelMapper()
                let heros = decodedHeros.map { mapper.map($0) }
                
                guard !heros.isEmpty else {
                    completion(.failure(HeroError.emptyList()))
                    return
                }
                
                completion(.success(heros))
            } catch let error as APIErrorResponse {
                completion(.failure(HeroError.network(error.message)))
            } catch {
                completion(.failure(HeroError.uknown()))
            }
        }
    }
}
