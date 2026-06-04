import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var todaySteps: Double = 0
    
    static let shared = HealthKitManager()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let typesToRead: Set = [stepCount]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }
    
    func fetchTodaySteps(completion: @escaping (Double) -> Void) {
        let stepCount = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCount, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0)
                return
            }
            let steps = sum.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async {
                self.todaySteps = steps
            }
            completion(steps)
        }
        healthStore.execute(query)
    }
}
