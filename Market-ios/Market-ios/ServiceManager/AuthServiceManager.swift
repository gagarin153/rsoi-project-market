import Foundation
import Alamofire

enum NetworkError: Error {
    case defaultError
}

final class AuthServiceManager {
    
    static let shared = AuthServiceManager()
    let storage = Storage()
    
    private init() { }
    
    func fetchToken(
        login: String,
        password: String,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        let credentialData = "\(login):\(password)".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
        let base64Credentials = credentialData.base64EncodedString()
        let headers: HTTPHeaders = [
            "Authorization": "Basic \(base64Credentials)",
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        
        AF.request(URLPaths.loginLocal.rawValue,
                   method: .post,
                   headers: headers
        ).response { [weak self] response in
            if let error = response.error {
                completion?(.failure(error))
            }
            
            guard let token = convertDataToDictionary(data: response.data)["token"] as? String
            else {
                completion?(.failure(NetworkError.defaultError))
                return
            }
            
            User.shared.token = token
            self?.storage.set(value: login, for: StorageKeys.name.rawValue)
            self?.storage.set(value: password, for: StorageKeys.password.rawValue)
            
            completion?(.success(()))
        }
    }
    
    func registration(
        login: String,
        password: String,
        completion: ((Result<Void, Error>) -> Void)?
    ) {
        let parameters = [StorageKeys.name.rawValue: login, StorageKeys.password.rawValue: password]
        
        AF.request(URLPaths.registrationLocal.rawValue,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default
        ).response { [weak self] response in
            if let error = response.error {
                completion?(.failure(error))
            }
            
            self?.fetchToken(
                login: login,
                password: password,
                completion: completion
            )
        }
    }
}


func convertDataToDictionary(data: Data?) -> [String:AnyObject] {
    if let data = data {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
            return json ?? [:]
        } catch {
            print("Something went wrong")
        }
    }
    
    return [:]
}
