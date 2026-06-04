import Foundation
import SwiftData

@Model
final class PetTask {
    var id: String
    var title: String
    var hungerReward: Double
    var isCompleted: Bool
    var isApproved: Bool // 家长核查
    
    init(id: String = UUID().uuidString, title: String, hungerReward: Double = 20.0) {
        self.id = id
        self.title = title
        self.hungerReward = hungerReward
        self.isCompleted = false
        self.isApproved = false
    }
}
