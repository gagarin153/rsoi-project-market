import Foundation

struct Item: Codable {
    
    let id: Int
    let title: String
    let price: Int
    let rating: Int
    let imageURL: String
    let type: String
}
