import Foundation
import SwiftData

@Model
final class Pet {
    var name: String
    var hunger: Double // 0-100
    var mood: Double   // 0-100
    var stamina: Double // 0-100
    var level: Int
    var coins: Int
    var lastUpdateTime: Date
    
    @Relationship(deleteRule: .cascade)
    var inventory: [DecorItem] = []
    
    var currentBackgroundID: String?
    
    init(name: String = "小智喵") {
        self.name = name
        self.hunger = 100.0
        self.mood = 100.0
        self.stamina = 100.0
        self.level = 1
        self.coins = 0
        self.lastUpdateTime = Date()
    }
    
    /// 计算战力 (Pet Power)
    /// 战力 = (等级 * 100) + (已解锁饰品总价值 * 0.5) + (已解锁场景价值)
    var petPower: Int {
        let itemsValue = inventory.reduce(0) { $0 + $1.price }
        return (level * 100) + Int(Double(itemsValue) * 0.5)
    }
}
