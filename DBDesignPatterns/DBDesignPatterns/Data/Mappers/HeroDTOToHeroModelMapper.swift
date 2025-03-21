final class HeroDTOToHeroModelMapper {
    func map(_ dto: HeroDTO) -> HeroModel {
        HeroModel(identifier: dto.identifier,
             name: dto.name,
             description: dto.description,
             favorite: dto.favorite,
             photo: dto.photo)
    }
}
