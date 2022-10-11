import UIKit

class CheckoutViewController: UIViewController {
    
    let options: OrderOptions
    
    private lazy var paymentTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.numberOfLines = 0
        label.text = "Способы оплаты:"
        
        return label
    }()
    
    private lazy var addressTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.numberOfLines = 0
        label.text = "Адрес:"
        
        return label
    }()
    
    private lazy var deliveryMerhodTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30.0)
        label.numberOfLines = 0
        label.text = "Способы доставки:"
        
        return label
    }()
    
    private lazy var paymentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var deliveryMerhodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(order), for: .touchUpInside)
        
        return button
    }()
    
    
    init(options: OrderOptions) {
         self.options = options
         super.init(nibName: nil, bundle: nil)
     }

     @available(*, unavailable)
     required init?(coder: NSCoder) {
         preconditionFailure("Unavailable")
     }


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Чекаут"
        
        setup()
        setupLayout()
    }
    
    private func setup() {
        button.setTitle("Оформить заказ на \(options.totalPrice) ₽", for: .normal)
        paymentLabel.text = "Наличные"
        addressLabel.text = options.address
        deliveryMerhodLabel.text = "Доставка в постомат"
        
        [paymentTitle, paymentLabel, deliveryMerhodLabel, deliveryMerhodTitle, addressLabel, addressTitle, button].forEach {
            view.addSubview($0)
        }
    }
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            button.heightAnchor.constraint(equalToConstant: 50),
            
            addressTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            addressTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addressTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            addressLabel.topAnchor.constraint(equalTo: addressTitle.bottomAnchor, constant: 10),
            addressLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            addressLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            paymentTitle.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 10),
            paymentTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            paymentTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            paymentLabel.topAnchor.constraint(equalTo: paymentTitle.bottomAnchor, constant: 10),
            paymentLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            paymentLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            deliveryMerhodTitle.topAnchor.constraint(equalTo: paymentLabel.bottomAnchor, constant: 10),
            deliveryMerhodTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            deliveryMerhodTitle.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            
            deliveryMerhodLabel.topAnchor.constraint(equalTo: deliveryMerhodTitle.bottomAnchor, constant: 10),
            deliveryMerhodLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            deliveryMerhodLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
        ])
    }
    
    @objc private func order() {
        ServiceManager.shared.order { [weak self] result in
            switch result {
            case .success:
                self?.dismiss(animated: true)
            case .failure:
                self?.presentAlert()
            }
        }
     }
    
    private func presentAlert() {
        let dialog = UIAlertController(title:"Что-то пошло не так", message:"Попробуйте еще раз", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        dialog.addAction(okAction)
        self.present(dialog, animated:true, completion:nil)
    }
}
