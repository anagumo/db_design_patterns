final class HeroDTOToHeroModelMapper {
    func map(_ dto: HeroDTO) -> Hero {
        Hero(identifier: dto.identifier,
             name: dto.name,
             description: dto.description,
             favorite: dto.favorite,
             photo: dto.photo)
    }
}
