import Foundation
import WatchKit

class DeviceStatusManager: ObservableObject {
    @Published var isCharging: Bool = false
    
    static let shared = DeviceStatusManager()
    
    private init() {
        // 开启电池监测
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        updateChargingStatus()
        
        // 监听电池状态变化
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(batteryStateChanged),
            name: NSNotification.Name.WKInterfaceDeviceBatteryStateDidChange,
            object: nil
        )
    }
    
    @objc private func batteryStateChanged() {
        updateChargingStatus()
    }
    
    private func updateChargingStatus() {
        let state = WKInterfaceDevice.current().batteryState
        DispatchQueue.main.async {
            self.isCharging = (state == .charging || state == .full)
        }
    }
}
