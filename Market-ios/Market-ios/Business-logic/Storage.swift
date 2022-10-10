import Foundation

final class Storage: NSObject {

    private let userDefaults: UserDefaults = .standard

    public func getValue<T: Decodable>(for key: String) -> T? {
        guard let object = userDefaults.object(forKey: key) as? Data else {
            return userDefaults.object(forKey: key) as? T
        }
        return try? JSONDecoder().decode(T.self, from: object)
    }

    public func set<T: Encodable>(value: T?, for key: String) {
        guard let encoded = try? JSONEncoder().encode(value) else {
            userDefaults.set(value, forKey: key)
            return
        }
        userDefaults.set(encoded, forKey: key)
    }

    public func removeValue(for key: String) {
        userDefaults.removeObject(forKey: key)
    }
}

