import UIKit

class RootViewController: UITabBarController {
    
    let storage = Storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        setupVCs()
        
        fetchToken()
    }
    
    
    private func setupTabbar() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.backgroundColor = .mainYellow
        
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithDefaultBackground()
        tabBarAppearance.backgroundColor = .mainYellow
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupVCs() {
        viewControllers = [
            createNavController(for: MordaViewController(), title: "главная", image: UIImage(systemName: "house")),
            createNavController(for: CartViewController(), title: "корзина", image: UIImage(systemName: "cart")),
            createNavController(for: ProfileViewController(), title: "профиль", image: UIImage(systemName: "person"))
        ]
    }
    
    private func createNavController(
        for rootViewController: UIViewController,
        title: String,
        image: UIImage?) -> UIViewController {
            let navController = UINavigationController(rootViewController: rootViewController)
            navController.tabBarItem.title = title
            navController.tabBarItem.image = image
            return navController
    }
    
    private func fetchToken() {
        let login = storage.getValue(for: StorageKeys.name.rawValue) ?? ""
        let password = storage.getValue(for: StorageKeys.password.rawValue) ?? ""
        
        AuthServiceManager.shared.fetchToken(
            login: login,
            password: password,
            completion: nil
        )
    }
}

