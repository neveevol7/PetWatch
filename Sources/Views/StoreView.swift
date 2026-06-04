import SwiftUI
import SwiftData

struct StoreView: View {
    @Query private var pets: [Pet]
    @Query private var availableItems: [DecorItem]
    @Environment(\.modelContext) private var modelContext
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(availableItems) { item in
                    VStack {
                        Text(item.emoji)
                            .font(.system(size: 30))
                        Text(item.name)
                            .font(.system(size: 8))
                        
                        if isItemOwned(item) {
                            Text("已拥有")
                                .font(.system(size: 8))
                                .foregroundStyle(.gray)
                        } else {
                            Button {
                                buyItem(item)
                            } label: {
                                Text("\(item.price) 💰")
                                    .font(.system(size: 8))
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.blue)
                            .controlSize(.mini)
                        }
                    }
                    .padding(5)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .padding()
            
            if availableItems.isEmpty {
                Button("生成默认货架") {
                    seedStore()
                }
                .font(.system(size: 10))
            }
        }
        .navigationTitle("宠物商店")
    }
    
    private func isItemOwned(_ item: DecorItem) -> Bool {
        guard let pet = pets.first else { return false }
        return pet.inventory.contains(where: { $0.id == item.id })
    }
    
    private func buyItem(_ item: DecorItem) {
        guard let pet = pets.first, pet.coins >= item.price else { return }
        pet.coins -= item.price
        pet.inventory.append(item)
    }
    
    private func seedStore() {
        let items = [
            DecorItem(id: "hat_1", name: "绅士礼帽", emoji: "🎩", price: 100, category: .hat),
            DecorItem(id: "glass_1", name: "酷酷墨镜", emoji: "🕶️", price: 150, category: .glasses),
            DecorItem(id: "bg_1", name: "海岛背景", emoji: "🏖️", price: 300, category: .background),
            DecorItem(id: "acc_1", name: "蝴蝶结", emoji: "🎀", price: 50, category: .accessory)
        ]
        for item in items {
            modelContext.insert(item)
        }
    }
}
