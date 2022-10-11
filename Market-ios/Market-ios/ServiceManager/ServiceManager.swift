import Alamofire

final class ServiceManager {
    
    static let shared = ServiceManager()
    private let storage = Storage()
    
    private init() { }
    
    func fetchAllItems(
        completion: ((Result<[Item], Error>) -> Void)?
    ) {
        AF.request(
            URLPaths.allItemsLocal.rawValue,
            method: .get
        ).response { response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            guard let data = response.data else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            let decoder = JSONDecoder()
            
            var items: [Item] = []
            do {
                items = try decoder.decode([Item].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            completion?(.success(items))
        }
    }
    
    func fetchItem(
        with id: Int,
        completion: ((Result<(Item, Bool), Error>) -> Void)?
    ) {
        AF.request(
            URLPaths.allItemsLocal.rawValue + String(id),
            method: .get
        ).response { [weak self] response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            guard let data = response.data else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            let decoder = JSONDecoder()
            
            var item: Item?
            do {
                item = try decoder.decode(Item.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            guard let item = item else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            self?.getCart { result in
                switch result {
                case let .success(cartItems):
                    if cartItems.contains(where: { $0.itemId == id }) {
                        completion?(.success((item, true)))
                    } else {
                        completion?(.success((item, false)))
                    }
                case .failure:
                    completion?(.success((item, false)))
                }
            }
        }
    }
    
    func addOrDeleteFromCart(
        with id: Int,
        method: HTTPMethod,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        let headers: HTTPHeaders = [
            "x-access-tokens": User.shared.token ?? "",
            "Accept": "application/json"
        ]
        
        let parameters = [
            "userId": User.shared.userId ?? "",
            "itemId": String(id)
        ]
        
        AF.request(URLPaths.cartItemLocal.rawValue,
                   method: method,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers
        ).response { response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            completion?(.success(()))
        }
    }
    
    func getCart(
        completion: ((Result<[CartItem], Error>) -> Void)?
    ) {
        guard let userId = User.shared.userId, let token = User.shared.token else {
            completion?(.failure(NetworkError.notLogin))
            return
        }
        
        let headers: HTTPHeaders = [
            "x-access-tokens": token,
            "Accept": "application/json"
        ]
        
        AF.request(
            URLPaths.cartItemsLocal.rawValue + String(userId),
            method: .get,
            headers: headers
        ).response { response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            guard let data = response.data else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            let decoder = JSONDecoder()
            
            var items: [CartItem] = []
            do {
                items = try decoder.decode([CartItem].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            completion?(.success(items))
        }
    }
    
    func orderOPtions(
        completion: ((Result<OrderOptions, Error>) -> Void)?
    ) {
        guard let userId = User.shared.userId, let token = User.shared.token else {
            completion?(.failure(NetworkError.notLogin))
            return
        }
        
        let headers: HTTPHeaders = [
            "x-access-tokens": token,
            "Accept": "application/json"
        ]
        
        AF.request(
            URLPaths.checkoutOptionsLocal.rawValue + String(userId),
            method: .get,
            headers: headers
        ).response { response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            guard let data = response.data else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            let decoder = JSONDecoder()
            
            var options: OrderOptions?
            do {
                options = try decoder.decode(OrderOptions.self, from: data)
            } catch {
                print(error.localizedDescription)
            }
            
            guard let options = options else {
                return
            }
            
            completion?(.success(options))
        }
    }
    
    func order(
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        guard let userId = User.shared.userId, let token = User.shared.token else {
            completion?(.failure(NetworkError.notLogin))
            return
        }
        
        let headers: HTTPHeaders = [
            "x-access-tokens": User.shared.token ?? "",
            "Accept": "application/json"
        ]
        
        AF.request(
                   URLPaths.checkoutOrderLocal.rawValue + String(userId),
                   method: .post,
                   headers: headers
        ).response { response in
            if let error = response.error {
                completion?(.failure(error))
                return
            }
            
            completion?(.success(()))
        }
    }
}
