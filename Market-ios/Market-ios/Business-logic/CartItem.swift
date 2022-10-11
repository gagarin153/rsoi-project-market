import Foundation

struct CartItem: Codable {
    
    let itemId: Int
    let title: String
    let price: Int
    let imageURL: String
    let userId: String
}
