import UIKit
import Kingfisher

final class ItemCell: UICollectionViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private  let price: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 16.0)

        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .white
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 20
        
        [imageView, title, price].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        
        // Layout constraints for `profileImageView`
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            imageView.heightAnchor.constraint(equalToConstant: 180.0)
        ])
        
        // Layout constraints for `usernameLabel`
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8.0)
        ])
        
        // Layout constraints for `descriptionLabel`
        NSLayoutConstraint.activate([
            price.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            price.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 4.0)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with item: Item) {
        imageView.kf.setImage(with: URL(string: item.imageURL))
        title.text = item.title
        price.text = "Цена: \(item.price) ₽"
    }
}
