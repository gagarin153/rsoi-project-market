final class User {
    let storage = Storage()
    
    static let shared = User()
    
    var token: String? {
        didSet {
            if token == nil {
                storage.removeValue(for: StorageKeys.name.rawValue)
                storage.removeValue(for: StorageKeys.password.rawValue)
            }
        }
    }
    
    private init() {}
}
