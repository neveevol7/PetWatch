import SwiftUI
import SwiftData

struct TaskListView: View {
    @Query private var tasks: [PetTask]
    @Query private var pets: [Pet]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        List {
            Section("待办任务") {
                ForEach(tasks.filter { !$0.isApproved }) { task in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(task.title)
                                .font(.system(size: 14))
                            Text(task.isCompleted ? "等待家长核查..." : "未完成")
                                .font(.system(size: 10))
                                .foregroundStyle(task.isCompleted ? .orange : .gray)
                        }
                        Spacer()
                        if !task.isCompleted {
                            Button("完成") {
                                task.isCompleted = true
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.mini)
                        } else {
                            // 模拟家长核查按钮 (仅为 MVP 演示)
                            Button("核查") {
                                approveTask(task)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(.green)
                            .controlSize(.mini)
                        }
                    }
                }
            }
            
            Button("添加测试任务") {
                let newTask = PetTask(title: "完成数学作业 📝")
                modelContext.insert(newTask)
            }
            .font(.system(size: 10))
        }
        .navigationTitle("任务中心")
    }
    
    private func approveTask(_ task: PetTask) {
        task.isApproved = true
        if let pet = pets.first {
            pet.hunger = min(100, pet.hunger + task.hungerReward)
            // 奖励少量金币
            pet.coins += 10
        }
    }
}
