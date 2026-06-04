# 技术详细设计文档 (TDD)：Apple Watch 虚拟宠物 (MVP)

## 1. 系统架构概述
本项目采用 MVVM 架构，结合 SwiftData 进行本地持久化与 CloudKit 同步。逻辑层由多个单例模式的 Manager 组成，确保状态的一致性与低功耗运行。

## 2. 数据架构 (Data Schema)

### 2.1 Pet Model (`@Model`)
| 字段名 | 类型 | 说明 |
| :--- | :--- | :--- |
| `id` | UUID | 唯一标识符 |
| `name` | String | 宠物名称 |
| `hunger` | Double | 饥饿值 (0-100) |
| `mood` | Double | 心情值 (0-100) |
| `stamina` | Double | 精力值 (0-100) |
| `level` | Int | 等级 |
| `coins` | Int | 持有金币数 |
| `exp` | Int | 累积经验值 |
| `lastUpdateTime` | Date | 上次逻辑更新时间戳 |
| `inventory` | [DecorItem] | 拥有的装饰品 (一对多关系) |
| `equippedItems` | [String] | 当前穿戴的饰品 ID 列表 |

### 2.2 DecorItem Model (`@Model`)
| 字段名 | 类型 | 说明 |
| :--- | :--- | :--- |
| `id` | String | 道具唯一 ID |
| `category` | Enum | 类型 (Hat, Background, etc.) |
| `price` | Int | 购买价格 |
| `pixelData` | String | 像素资源引用名 |

### 2.3 PetTask Model (`@Model`)
| 字段名 | 类型 | 说明 |
| :--- | :--- | :--- |
| `id` | String | 任务 ID |
| `title` | String | 任务描述 |
| `isCompleted` | Bool | 孩子是否点击完成 |
| `isApproved` | Bool | 家长是否核查通过 |

## 3. 状态机逻辑 (State Machine)

### 3.1 自动衰减逻辑 (Tick System)
App 激活或每隔 15 分钟（通过 Background Tasks）触发：
*   **Hunger Decay:** 每小时 -5.0。
*   **Mood Decay:** 每小时 -2.0。
*   **Stamina Decay:** 非充电状态下每小时 -1.0。

### 3.2 恢复逻辑触发
*   **运动触发:** 每增加 100 步 -> Hunger +1.0。
*   **充电触发:** 检测到 `WKInterfaceDevice.current().batteryState == .charging` -> Stamina 每分钟 +1.0。
*   **任务触发:** 家长端 `isApproved` 变为 `true` -> Hunger +20.0，Coins +10。

### 3.3 失败判定
*   当 `hunger <= 0` 时，设置 `isFamine = true`。
*   `isFamine == true` 时，所有金币产出逻辑暂停，宠物视觉滤镜变为灰色。

## 4. 关键类定义 (Manager Pattern)

### 4.1 StatusManager
负责所有数值计算的核心引擎。
- `func updateAllStatuses(pet: Pet)`
- `func calculatePetPower(pet: Pet) -> Int`

### 4.2 HealthKitManager
负责与苹果健康数据交互。
- `func startStepObservation()`
- `func fetchStepCount(completion: @escaping (Double) -> Void)`

### 4.3 DeviceStatusManager
负责硬件状态监测。
- `var isCharging: Published<Bool>`

## 5. 存储与同步策略
*   **本地存储:** SwiftData。
*   **多端同步:** CloudKit Private Database。iPhone 端修改 `PetTask.isApproved` 后，Watch 端通过 `NSPersistentCloudKitContainer` 自动接收变更并触发 `StatusManager` 更新。

## 6. 文档修订记录
- **v1.0 (2026-05-27):** 初始技术架构与数据模型定义。
