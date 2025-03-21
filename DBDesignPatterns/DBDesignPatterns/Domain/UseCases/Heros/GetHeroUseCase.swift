import Foundation

protocol GetHeroUseCaseProtocol {
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
