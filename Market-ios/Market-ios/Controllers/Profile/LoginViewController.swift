import UIKit


final class LoginViewController: UIViewController {
    
    enum State {
        case loginIn
        case registration
    }
    
    let state: State
    let completion: (()->())?
    
    private lazy var loginTextFiled: UITextField = {
        let textField = textField
        textField.placeholder = "Введите имя"
        
        return textField
    }()
    
    private lazy var passwordTextFiled: UITextField = {
        let textField = textField
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        
        return textField
    }()
    
    private var textField: UITextField  {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        textField.tintColor = .label
        textField.borderStyle = UITextField.BorderStyle.line
            
        return textField
    }
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .mainYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        button.frame.size = CGSize(width: 100.0, height: 20.0)
        button.tintColor = .label
        
        return button
    }()
    
    init(state: State, completion: (()->())?) {
         self.state = state
         self.completion = completion
         super.init(nibName: nil, bundle: nil)
     }

     @available(*, unavailable)
     required init?(coder: NSCoder) {
         preconditionFailure("Unavailable")
     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        if state == .loginIn {
            button.setTitle("Войдите", for: .normal)
            button.addTarget(self, action: #selector(loginIn), for: .touchUpInside)
        } else {
            button.setTitle("Зарегистрироваться", for: .normal)
            button.addTarget(self, action: #selector(registration), for: .touchUpInside)
        }
        
        [loginTextFiled, passwordTextFiled, button].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            loginTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 250),
            loginTextFiled.heightAnchor.constraint(equalToConstant: 50.0),
            loginTextFiled.widthAnchor.constraint(equalToConstant: 250.0),
            loginTextFiled.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            passwordTextFiled.topAnchor.constraint(equalTo: loginTextFiled.bottomAnchor, constant: 8),
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 50.0),
            passwordTextFiled.widthAnchor.constraint(equalToConstant: 250.0),
            passwordTextFiled.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: passwordTextFiled.bottomAnchor, constant: 15),
            button.heightAnchor.constraint(equalToConstant: 50.0),
            button.widthAnchor.constraint(equalToConstant: 200.0),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func loginIn() {
        guard
            let login = loginTextFiled.text, let password = passwordTextFiled.text
        else { return }
        
        AuthServiceManager.shared.fetchToken(
            login: login.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines)
        ) { [weak self] result in
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: self?.completion)
            case .failure:
                self?.presentAlert()
            }
        }
    }
    
    @objc func registration() {
        guard
            let login = loginTextFiled.text, let password = passwordTextFiled.text
        else { return }
        
        AuthServiceManager.shared.registration (
            login: login.trimmingCharacters(in: .whitespacesAndNewlines),
            password: password.trimmingCharacters(in: .whitespacesAndNewlines)
        ) { [weak self] result in
            switch result {
            case .success:
                self?.dismiss(animated: true, completion: self?.completion)
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
