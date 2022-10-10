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
}
