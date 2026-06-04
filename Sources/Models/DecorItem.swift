import Foundation
import SwiftData

@Model
final class DecorItem {
    var id: String
    var name: String
    var emoji: String
    var price: Int
    var category: ItemCategory
    var isUnlocked: Bool
    
    enum ItemCategory: String, Codable {
        case hat
        case glasses
        case background
        case accessory
    }
    
    init(id: String, name: String, emoji: String, price: Int, category: ItemCategory, isUnlocked: Bool = false) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.price = price
        self.category = category
        self.isUnlocked = isUnlocked
    }
}
