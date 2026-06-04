import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var pets: [Pet]
    @Environment(\.modelContext) private var modelContext
    
    @StateObject private var deviceStatus = DeviceStatusManager.shared
    @StateObject private var healthKit = HealthKitManager.shared
    
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let pet = pets.first {
                    PetMainView(pet: pet)
                } else {
                    ContentUnavailableView("欢迎来到虚拟宠物", systemImage: "pawprint.fill", description: Text("领养你的第一个宠物开始吧"))
                    Button("领养小智喵") {
                        addPet()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                healthKit.requestAuthorization { _, _ in
                    healthKit.fetchTodaySteps { steps in
                        if let pet = pets.first {
                            StatusManager.shared.syncSteps(for: pet, currentTotalSteps: Int(steps))
                        }
                    }
                }
                if let pet = pets.first {
                    StatusManager.shared.updateStatus(for: pet, isCharging: deviceStatus.isCharging)
                }
            }
            .onReceive(timer) { _ in
                if let pet = pets.first {
                    StatusManager.shared.updateStatus(for: pet, isCharging: deviceStatus.isCharging)
                    healthKit.fetchTodaySteps { steps in
                        StatusManager.shared.syncSteps(for: pet, currentTotalSteps: Int(steps))
                    }
                }
            }
            .navigationTitle("PetWatch")
        }
    }
    
    private func addPet() {
        let newPet = Pet(name: "小智喵")
        modelContext.insert(newPet)
    }
}

struct PetMainView: View {
    let pet: Pet
    
    var body: some View {
        VStack(spacing: 4) {
            // 顶部等级与金币
            HStack {
                Text("⭐ LV.\(pet.level)")
                Spacer()
                Text("💰 \(pet.coins)")
            }
            .font(.system(size: 10, weight: .bold))
            .padding(.horizontal)
            
            // 宠物展示区
            ZStack {
                // 背景场景 (如果有)
                Circle()
                    .fill(Color.gray.opacity(0.1))
                    .frame(width: 70, height: 70)
                
                // 宠物本体
                Text(pet.hunger > 10 ? "🐱" : "😿")
                    .font(.system(size: 40))
                    .grayscale(pet.hunger > 10 ? 0 : 0.8)
                
                // 佩戴的第一个饰品预览
                if let firstDecor = pet.inventory.first(where: { $0.category == .hat }) {
                    Text(firstDecor.emoji)
                        .font(.system(size: 20))
                        .offset(y: -25)
                }
            }
            
            // RPG 属性条
            VStack(spacing: 2) {
                StatusProgressView(label: "饥饿", value: pet.hunger, color: .green)
                StatusProgressView(label: "心情", value: pet.mood, color: .red)
                StatusProgressView(label: "精力", value: pet.stamina, color: .blue)
            }
            .padding(.horizontal)
            
            // 底部导航
            HStack(spacing: 10) {
                NavigationLink(destination: TaskListView()) {
                    Image(systemName: "checklist")
                }
                NavigationLink(destination: StoreView()) {
                    Image(systemName: "cart.fill")
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
            .padding(.top, 4)
        }
    }
}

struct StatusProgressView: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                Text(label).font(.system(size: 8))
                Spacer()
                Text("\(Int(value))%").font(.system(size: 8))
            }
            ProgressView(value: value, total: 100)
                .tint(color)
                .scaleEffect(x: 1, y: 0.5, anchor: .center)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Pet.self, inMemory: true)
}
