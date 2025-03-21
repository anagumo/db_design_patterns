import UIKit

final class HeroCell: UICollectionViewCell {
    static let identifier = "HeroCell"
    
    @IBOutlet weak var photoAsyncImage: AsyncImage!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func setData(_ hero: Hero) {
        favoriteImageView.image = UIImage(systemName: (hero.getFavoriteImage()))
        favoriteImageView.tintColor = .dbOrange
        photoAsyncImage.layer.backgroundColor = UIColor.systemGray6.cgColor
        photoAsyncImage.setImage(hero.photo)
        photoAsyncImage.contentMode = .scaleAspectFill
        photoAsyncImage.layer.cornerRadius = 8
        nameLabel.text = hero.name
    }
}
