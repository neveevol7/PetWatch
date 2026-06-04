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
        
        // 如果时间间隔太短（小于10秒），跳过更新以节省性能
        guard timeInterval > 10 else { return }
        
        // 1. 饥饿值衰减 (TDD: 每小时 -5.0)
        let hungerDecay = hoursPassed * 5.0
        pet.hunger = max(0, pet.hunger - hungerDecay)
        
        // 2. 心情值衰减 (TDD: 每小时 -2.0)
        let moodDecay = hoursPassed * 2.0
        pet.mood = max(0, pet.mood - moodDecay)
        
        // 3. 精力值恢复/损耗
        if isCharging {
            // 充电触发 (TDD: Stamina 每分钟 +1.0)
            let staminaRecovery = minutesPassed * 1.0
            pet.stamina = min(100, pet.stamina + staminaRecovery)
        } else {
            // 非充电状态 (TDD: 每小时 -1.0)
            let staminaDecay = hoursPassed * 1.0
            pet.stamina = max(0, pet.stamina - staminaDecay)
        }
        
        // 4. 金币产出逻辑 (饥饿状态下停止产出)
        if !pet.isFamine {
            // 基础产出率：每小时 10 金币
            let baseRate = 10.0
            
            // 激励乘数 (TDD: 高心情 > 80 为 1.5x, 低心情 < 20 为 0.5x)
            var multiplier = 1.0
            if pet.mood > 80 {
                multiplier = 1.5
            } else if pet.mood < 20 {
                multiplier = 0.5
            }
            
            let earnedCoins = Int(hoursPassed * baseRate * multiplier)
            if earnedCoins > 0 {
                pet.coins += earnedCoins
            }
        }
        
        // 更新最后更新时间
        pet.lastUpdateTime = now
    }
    
    /// 同步运动数据并转化
    func syncSteps(for pet: Pet, currentTotalSteps: Int) {
        let newSteps = currentTotalSteps - pet.lastRecordedSteps
        
        // 只有当步数增加且大于 0 时才处理 (处理跨天重置的情况)
        if newSteps > 0 {
            // TDD: 每增加 100 步 -> Hunger +1.0
            let hungerRecovery = Double(newSteps) / 100.0
            pet.hunger = min(100, pet.hunger + hungerRecovery)
        }
        
        // 更新记录的步数
        pet.lastRecordedSteps = currentTotalSteps
    }
    
    /// 增加经验值并处理升级
    func gainExp(_ amount: Int, for pet: Pet) {
        pet.exp += amount
        
        // 简单的升级公式：当前等级 * 100 = 升级所需经验
        let nextLevelExp = pet.level * 100
        if pet.exp >= nextLevelExp {
            pet.exp -= nextLevelExp
            pet.level += 1
            // 升级奖励金币
            pet.coins += 50
        }
    }
}
