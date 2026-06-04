# 开发实施计划 - Apple Watch 虚拟宠物 (MVP)

此计划概述了 Apple Watch 虚拟宠物 App 的技术实现方案，重点围绕头脑风暴阶段确定的核心机制：饥饿值（运动/学习）、心情值（互动）和精力值（充电）。

## 1. 目标
使用 SwiftUI 开发一款原生的 watchOS App，集成 HealthKit 和 CloudKit，打造一个由家长验证的虚拟宠物体验。

## 2. 核心文件与背景
- **设计规范 (Design Spec):** `/Users/yu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Neal/Apple Watch Virtual Pet/2026-05-26-apple-watch-pet-design.md`
- **平台:** watchOS 10+ (原生 SwiftUI)
- **框架:** HealthKit (步数/睡眠), WatchConnectivity (亲子端同步), CloudKit (持久化存储), SwiftUI (用户界面)。

## 3. 实施步骤

### 第一阶段：项目设置与数据建模 (Phase 1)
- [x] 初始化一个新的 watchOS App 项目 (SwiftUI)。
- [x] 定义核心 `Pet`（宠物）模型：
    - `hunger`: 双精度浮点数 (0-100)
    - `mood`: 双精度浮点数 (0-100)
    - `stamina`: 双精度浮点数 (0-100)
    - `level`: 整数 (等级)
    - `coins`: 整数 (金币)
    - `inventory`: 装饰品列表
    - `currentBackground`: 当前背景装饰
- [x] 使用 SwiftData 或 CoreData 设置持久化层（启用 CloudKit）。

### 第二阶段：核心状态逻辑（“大脑”部分）(Phase 2)
- [x] 实现 `StatusManager` 处理状态衰减：
    - 饥饿值衰减：每小时 -5%。
    - 心情值衰减：每小时 -2%。
- [x] 实现 `HealthKitManager`：
    - 读取每日步数并转化为饥饿值恢复。
    - 监测 `isCharging`（充电状态）以触发精力值恢复（采用 A+D 方案）。

### 第三阶段：UI 界面实现 (WatchOS) (Phase 3)
- [x] **主视图 (Main View):** 中心宠物形象（目前使用 Emoji 占位），侧边显示 3 条状态栏。
- [x] **任务视图 (Task View):** 家长分配的任务列表（通过 CloudKit 同步）。
- [x] **商店视图 (Store View):** 装饰品网格（帽子、眼镜等），可用金币购买。
- [ ] **排行榜视图 (Leaderboard View):** 根据“收藏家得分”排序的宠物列表。

### 第四阶段：亲子同步 (CloudKit/WatchConnectivity) (Phase 4)
- [x] 实现“任务完成”流程：
    - 家长在 iPhone 端批准任务（MVP 阶段已在 Watch 端模拟）。
    - 手表端接收数据更新并增加 `hunger`（饥饿值）。

### 第五阶段：润色与细化 (Phase 5)
- [ ] 添加 Haptic（触感）反馈，用于任务完成和“低能量”警告。
- [ ] 实现当饥饿值达到 0 时的“变灰”失败状态效果。

## 4. 验证与测试
- [ ] **单元测试:** 验证模拟时间间隔内的衰减逻辑。
- [ ] **HealthKit 模拟:** 在模拟器中注入步数数据，验证能量增长。
- [ ] **集成测试:** 验证设备充电是否正确触发了精力值恢复。
- [ ] **UI 走查:** 确保所有状态栏和宠物形象在不同尺寸的手表上显示正常。
