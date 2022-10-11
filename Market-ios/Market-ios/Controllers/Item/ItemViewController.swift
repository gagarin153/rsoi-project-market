import UIKit
import Kingfisher

class ItemViewController: UIViewController {
    
    enum ButtonState {
        case added
        case notAdded
    }
    
    private let itemId: Int
    private var currentButtonState = ButtonState.notAdded {
        didSet {
            
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var  button: UIButton  = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    private lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        
        return label
    }()
    
    init(itemId: Int) {
         self.itemId = itemId
         super.init(nibName: nil, bundle: nil)
     }

     @available(*, unavailable)
     required init?(coder: NSCoder) {
         preconditionFailure("Unavailable")
     }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupLayout()
        
        ServiceManager.shared.fetchItem(with: itemId) {
            [weak self] result in
            switch result {
            case let .success((item, stateFlag)):
                self?.updateUI(with: item, stateFlag: stateFlag)
            case .failure:
                print()
            }
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        [imageView, titleLabel, priceLabel, ratingLabel, button].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 300.0),
            imageView.leftAnchor.constraint(equalTo: view.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0),
            
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            ratingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
            
            priceLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 10),
            priceLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
            
            button.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 50.0)
        ])
    }
    
    private func updateUI(with item: Item, stateFlag: Bool) {
        imageView.kf.setImage(with: URL(string: item.imageURL))
        titleLabel.text = item.title
        
        priceLabel.attributedText = makeattributedString(with: "Цена: ", secondPart: "\(item.price) ₽")
        ratingLabel.attributedText = makeattributedString(with: "Рейтинг: ", secondPart: String(item.rating))
        
        currentButtonState = stateFlag ? .added : .notAdded
        updatedButton()
    }
    
    private func updatedButton() {
        if currentButtonState == .added {
            button.backgroundColor = .lightGray.withAlphaComponent(0.3)
            button.setTitle("Товар уже в корзине", for: .normal)
        } else {
            button.backgroundColor = .mainYellow
            button.setTitle("В корзину", for: .normal)
            button.titleLabel?.text = "В корзину"
        }
    }
    
    private func makeattributedString(with firstPart: String, secondPart: String)-> NSAttributedString {
        
        let attrs = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)]
        let attributedString = NSMutableAttributedString(string: firstPart, attributes:attrs)

        let normalString = NSMutableAttributedString(string: secondPart)
        attributedString.append(normalString)
        
        return attributedString
    }
}
