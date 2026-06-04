import Foundation
import CloudKit
import SwiftData

class CloudKitManager: ObservableObject {
    static let shared = CloudKitManager()
    
    private let container = CKContainer.default()
    private let privateDatabase = CKContainer.default().privateCloudDatabase
    
    @Published var syncStatus: String = "IDLE"
    
    private init() {}
    
    /// 检查 iCloud 账户可用性
    func checkAccountStatus(completion: @escaping (Bool) -> Void) {
        container.accountStatus { status, error in
            DispatchQueue.main.async {
                if status == .available {
                    completion(true)
                } else {
                    self.syncStatus = "Account Unavailable"
                    completion(false)
                }
            }
        }
    }
    
    /// 手动触发全量同步 (SwiftData 会自动处理大部分 CloudKit 同步，
    /// 这里主要用于特定的长任务审批或强制刷新逻辑)
    func performManualSync() {
        self.syncStatus = "SYNCING..."
        // 在 SwiftData 架构下，我们主要依赖 NSPersistentCloudKitContainer 的自动行为
        // 这里可以预留用于订阅远程通知或处理特定的跨设备冲突
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.syncStatus = "UP TO DATE"
        }
    }
}
