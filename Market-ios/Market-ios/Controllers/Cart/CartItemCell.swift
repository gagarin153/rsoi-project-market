import UIKit
import Kingfisher

final class CartItemCell: UITableViewCell {
    
    private var buttonHandler: (()->())?
    
    static var identifier: String {
        return String(describing: self)
    }
    
    private let itemImageView: UIImageView = {
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
    
    let deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.setTitle("Удалить", for: .normal)
        button.tintColor = .label
        button.layer.cornerRadius = 20.0

        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupLayouts()
    }
    
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 20
        
        [itemImageView, title, price, deleteButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    private func setupLayouts() {
        itemImageView.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            itemImageView.heightAnchor.constraint(equalToConstant: 120),
            itemImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            title.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 8.0)
        ])
        
        NSLayoutConstraint.activate([
            price.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16.0),
            price.centerYAnchor.constraint(equalTo: itemImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            deleteButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            deleteButton.heightAnchor.constraint(equalToConstant: 50.0),
            deleteButton.widthAnchor.constraint(equalToConstant: 100.0)
        ])
    }
    
    func setup(with item: CartItem, buttonHandler: @escaping ()->()) {
        itemImageView.kf.setImage(with: URL(string: item.imageURL))
        title.text = item.title
        price.text = "Цена: \(item.price) ₽"
        self.buttonHandler = buttonHandler
        deleteButton.removeTarget(nil, action: nil, for: .allEvents)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    
    @objc func deleteButtonTapped() {
        buttonHandler?()
    }
}
