import Foundation

struct OrderOptions: Codable {
    let paymentMethod: String
    let deliveryMethod: String
    let address: String
    let totalPrice: Int
}
