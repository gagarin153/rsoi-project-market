import UIKit

class RootViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabbar()
        setupVCs()
    }
    
    
    private func setupTabbar() {
        view.backgroundColor = .systemBackground
        tabBar.tintColor = .label
        tabBar.backgroundColor = .yellow.withAlphaComponent(0.5)
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
}

