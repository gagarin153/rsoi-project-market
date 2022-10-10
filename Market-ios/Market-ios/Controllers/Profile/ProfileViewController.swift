import UIKit

final class ProfileViewController: UIViewController {
        
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame.size = CGSize(width: 200.0, height: 200.0)
        
        return imageView
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        return label
    }()
    
    private var button: UIButton  {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        
        return button
    }
    
    private lazy var mainButton = button
    private lazy var additionalButton = button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateUI()
    }
    
    private func setupUI() {
        [imageView, label, mainButton, additionalButton].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 200.0),
            imageView.widthAnchor.constraint(equalToConstant: 200.0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
            label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0),
            
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            mainButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            mainButton.heightAnchor.constraint(equalToConstant: 50.0),
            mainButton.widthAnchor.constraint(equalToConstant: 200.0),
            mainButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            additionalButton.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 10),
            additionalButton.heightAnchor.constraint(equalToConstant: 50.0),
            additionalButton.widthAnchor.constraint(equalToConstant: 200.0),
            additionalButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    private func updateUI() {
        if User.shared.token != nil {
            let emojiImage = "😍".textToImage()
            imageView.image = emojiImage
            label.text = "Мы рады, что вы с нами!"
            mainButton.setTitle("Выйти", for: .normal)
            additionalButton.isHidden = true
            mainButton.removeTarget(nil, action: nil, for: .allEvents)
            mainButton.addTarget(self, action: #selector(loginOut), for: .touchUpInside)
        } else {
            let emojiImage = "😇".textToImage()
            imageView.image = emojiImage
            label.text = "Присоединяйтесь к нам!\nУ нас много интересного"
            mainButton.setTitle("Войти", for: .normal)
            mainButton.removeTarget(nil, action: nil, for: .allEvents)
            mainButton.addTarget(self, action: #selector(openLoginIn), for: .touchUpInside)
            additionalButton.setTitle("Зарегистрироваться", for: .normal)
            additionalButton.isHidden = false
            additionalButton.removeTarget(nil, action: nil, for: .allEvents)
            additionalButton.addTarget(self, action: #selector(openRegistration), for: .touchUpInside)
        }
    }
    
    @objc func openLoginIn() {
        openLoginVC(with: .loginIn)
    }
    
    @objc func openRegistration() {
        openLoginVC(with: .registration)
    }
    
    @objc func loginOut() {
        User.shared.token = nil
        updateUI()
    }
    
    private func openLoginVC(with state: LoginViewController.State) {
        let viewController = LoginViewController(state: state) { [weak self] in
            self?.updateUI()
        }
        present(viewController, animated: true, completion: nil)
    }
}
