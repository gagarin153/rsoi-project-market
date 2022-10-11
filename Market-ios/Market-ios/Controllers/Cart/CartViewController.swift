import UIKit

final class CartViewController: UIViewController {
    
    private var cartitems: [CartItem] = []
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .label
        button.layer.cornerRadius = 20.0
        button.addTarget(self, action: #selector(goToCheckout), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateItems()
    }
    
    private func setup() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(button)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Ваша корзина"
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartItemCell.self, forCellReuseIdentifier: CartItemCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -8),
            tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            button.widthAnchor.constraint(equalToConstant: 250),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func updateItems() {
        ServiceManager.shared.getCart { [weak self] result in
            switch result {
            case let .success(cartitems):
                self?.cartitems = cartitems
                self?.tableView.reloadData()
                self?.updateCheckoutButton()
            case .failure:
                self?.cartitems = []
                self?.tableView.reloadData()
                self?.updateCheckoutButton()
            }
        }
    }
    
    private func updateCheckoutButton() {
        guard cartitems.count > 0 else {
            button.isHidden = true
            return
        }
        
        let totalAmount = cartitems.reduce(0) { $0 + $1.price }
        button.isHidden = false
        button.setTitle("Оформить заказ на \(totalAmount) ₽", for: .normal)
    }
    
    private func deleteCartItem(with index: Int) {
        let itemId = cartitems[index].itemId
        
        ServiceManager.shared.addOrDeleteFromCart(
            with: itemId,
            method: .delete
        ) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.cartitems = self.cartitems.filter { $0.itemId != itemId}
                self.tableView.reloadData()
                self.updateCheckoutButton()
            case .failure:
                self.presentAlert()
            }
        }
    }
    
    private func presentAlert() {
        let dialog = UIAlertController(title:"Что-то пошло не так", message:"Попробуйте еще раз", preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .default, handler: {(alert:UIAlertAction!)-> Void in})
        dialog.addAction(okAction)
        self.present(dialog, animated:true, completion:nil)
    }
    
   @objc private func goToCheckout() {
       ServiceManager.shared.orderOPtions { [weak self] result in
           switch result {
           case let .success(options):
               let vc = CheckoutViewController(options: options)
               let navController = UINavigationController(rootViewController: vc)
               navController.modalPresentationStyle = .fullScreen
               self?.present(navController, animated: true, completion: nil)
           case .failure:
               self?.presentAlert()
           }
       }
    }
}

extension CartViewController: UITableViewDataSource {
    func  tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartitems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CartItemCell.identifier, for: indexPath) as! CartItemCell
        
        let item = cartitems[indexPath.item]
        cell.setup(with: item) { [weak self] in
            self?.deleteCartItem(with: indexPath.item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 200
    }
}


extension CartViewController: UITableViewDelegate {
    
}
