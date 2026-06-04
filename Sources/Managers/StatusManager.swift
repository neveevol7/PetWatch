import Foundation
import SwiftData

class StatusManager {
    static let shared = StatusManager()
    
    private init() {}
    
    /// 更新宠物状态（处理衰减和恢复）
    func updateStatus(for pet: Pet, isCharging: Bool) {
        let now = Date()
        let timeInterval = now.timeIntervalSince(pet.lastUpdateTime)
        let hoursPassed = timeInterval / 3600.0
        let minutesPassed = timeInterval / 60.0
        
        // 1. 饥饿值衰减 (-5% 每小时)
        let hungerDecay = hoursPassed * 5.0
        pet.hunger = max(0, pet.hunger - hungerDecay)
        
        // 2. 心情值衰减 (-2% 每小时)
        let moodDecay = hoursPassed * 2.0
        pet.mood = max(0, pet.mood - moodDecay)
        
        // 3. 精力值恢复 (方案 A: 充电每分钟恢复 1%)
        if isCharging {
            let staminaRecovery = minutesPassed * 1.0
            pet.stamina = min(100, pet.stamina + staminaRecovery)
        } else {
            // 如果不充电，精力值随时间略微自然损耗 (比如 -1% 每小时)
            let staminaDecay = hoursPassed * 1.0
            pet.stamina = max(0, pet.stamina - staminaDecay)
        }
        
        // 更新最后更新时间
        pet.lastUpdateTime = now
    }
}
