import Foundation

protocol GetHeroUseCaseProtocol {
    /// Runs a get hero
    /// - Parameters:
    ///   - name: an object of type `(String)` that represents the hero name ej. Gohan :'( (missing in the server)
    ///   - completion: a clossure of type `((Result<HeroModel, Error>) -> Void)` that represents the data result and returns either a hero model or an error
    func run(name: String, completion: @escaping (Result<HeroModel, Error>) -> Void)
}

final class GetHeroUseCase: GetHeroUseCaseProtocol {
    
    func run(name: String, completion: @escaping (Result<HeroModel, Error>) -> Void) {
        GetHerosAPIRequest(name: name).perform { result in
            do {
                let decodedHero = try result.get().first
                guard let decodedHero else {
                    completion(.failure(HeroError.empty()))
                    return
                }
                // Apply the Mapper design pattern to transform an api dto to a domain model
                let mapper = HeroDTOToHeroModelMapper()
                let hero = mapper.map(decodedHero)
                completion(.success(hero))
            } catch let error as APIErrorResponse {
                completion(.failure(HeroError.network(error.message)))
            } catch {
                completion(.failure(HeroError.uknown()))
            }
        }
    }
}
