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
        VStack(spacing: 0) {
            // 顶部状态栏 (仿宝可梦样式)
            HStack {
                Text("Lv\(pet.level) \(pet.name)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                Spacer()
                Text("💰 \(pet.coins)")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(PixelTheme.background)
            .foregroundColor(PixelTheme.border)
            .border(PixelTheme.border, width: 1)
            
            // 核心显示区：分层背景 + 动态宠物
            ZStack {
                EnvironmentBackgroundView(backgroundEmoji: pet.inventory.first(where: { $0.category == .background })?.emoji)
                
                PetSpriteView(
                    petEmoji: "🐱",
                    isFamine: pet.isFamine,
                    hatEmoji: pet.inventory.first(where: { $0.category == .hat })?.emoji
                )
                .offset(y: 10)
            }
            .frame(maxHeight: .infinity)
            
            // 底部属性面板
            VStack(spacing: 4) {
                PixelProgressBar(label: "HP", value: pet.hunger, color: PixelTheme.green)
                PixelProgressBar(label: "心情", value: pet.mood, color: PixelTheme.blue)
                PixelProgressBar(label: "精力", value: pet.stamina, color: PixelTheme.red)
            }
            .padding(8)
            .background(PixelTheme.background)
            .border(PixelTheme.border, width: 2)
            
            // 导航按钮
            HStack(spacing: 12) {
                NavigationLink(destination: TaskListView()) {
                    Text("任务").font(.system(size: 10))
                }
                NavigationLink(destination: StoreView()) {
                    Text("商店").font(.system(size: 10))
                }
                // 排行榜入口 (待实现)
                Button(action: {}) {
                    Text("排行").font(.system(size: 10))
                }
            }
            .buttonStyle(.bordered)
            .controlSize(.mini)
            .padding(.vertical, 4)
            .background(Color.black.opacity(0.1))
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(2)
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
