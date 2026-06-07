# PetWatch 🐾

**Apple Watch 原生 HD 像素风电子宠物 - 将健康数据与亲子互动融入 RPG 养成**

[![Platform](https://img.shields.io/badge/Platform-watchOS%2010%2B-black.svg)](https://developer.apple.com/watchos/)
[![Swift](https://img.shields.io/badge/Language-Swift%205.9-orange.svg)](https://swift.org)
[![SwiftData](https://img.shields.io/badge/Persistence-SwiftData-blue.svg)](https://developer.apple.com/xcode/swiftdata/)

---

## 🌟 项目愿景
**PetWatch** 不仅仅是一款电子宠物应用，它是一个连接虚拟世界与现实生活的纽带。通过 Apple Watch 的传感器捕捉孩子的运动与睡眠数据，结合家长在 iPhone 端的学习任务核查，将孩子的“自我提升”转化为宠物的“生命能量”。

我们的目标是利用 **HD Pixel Art (高清像素艺术)** 的美学和经典的 **RPG 养成机制**，培养孩子的责任感，让健康生活与快乐学习变得像玩游戏一样有趣。

---

## 🎮 核心玩法

### 1. 三维属性系统 (Status System)
*   **🍖 饥饿值 (Hunger):** 宠物的生存底线。通过现实中的**步数 (HealthKit)** 和**学习任务 (家长核查)** 来补充。
*   **😊 心情值 (Mood):** 衡量互动的质量。高心情会大幅提升金币产出速度（1.5x 加成）。
*   **⚡ 精力值 (Stamina):** 挂钩作息规律。采用 **“充电即睡眠”** 逻辑——当手表处于充电状态时，宠物同步恢复精力，解决了续航与养成逻辑的冲突。

### 2. 荣誉与收集 (RPG Mechanics)
*   **💰 金币商店:** 通过保持宠物健康产出金币，购买帽子、眼镜等像素饰品以及精美的环境背景。
*   **🏆 战力排行榜:** 战力值由“等级 + 资产价值”构成，纯粹的荣誉驱动，激励孩子保持长期的健康习惯。
*   **✨ 进化系统:** 随着经验值 (EXP) 的积累，宠物将经历从幼年期到成熟期的形象进化。

### 3. 亲子互动闭环 (Parent-Child Loop)
*   **任务核查:** 家长在伴侣端发布任务（如：今日作业），完成后一键核查，宠物在手表端即时获得奖励，形成正向反馈。

---

## 🎨 视觉风格
参考 **《宝可梦》(GBA/DS 时代)** 的 UI 艺术风格：
*   **HD Pixel Art:** 细腻的像素描边与分层背景环境。
*   **有机动效:** 宠物具备呼吸感浮动 (Steps 动画)，营造鲜活的生命力。
*   **高对比度设计:** 针对 watchOS OLED 屏幕优化的黑底高亮界面。

---

## 🛠 技术架构
*   **UI 框架:** SwiftUI (采用响应式布局适配不同表盘尺寸)。
*   **数据层:** SwiftData (基于持久化存储的现代模型框架)。
*   **同步引擎:** CloudKit (利用私有数据库实现 iPhone 与 Watch 的无缝数据镜像)。
*   **健康集成:** HealthKit (实时监听步数与活动能量数据)。
*   **硬件交互:** WatchConnectivity & Haptic Feedback。

---

## 📂 项目结构
```text
apple-watch-pet/
├── Sources/
│   ├── App/        # App 入口与全局配置
│   ├── Models/     # Pet, Task, DecorItem 数据模型
│   ├── Managers/   # 核心引擎 (Status, Health, CloudKit)
│   └── Views/      # SwiftUI 界面组件
├── docs/           # 需求说明书 (BRD), 技术设计 (TDD)
└── README.md       # 项目总览
```

---

## 🚀 开发进度 (Roadmap)
- [x] **Phase 1:** 核心模型设计与项目初始化
- [x] **Phase 2:** 状态衰减与步数转化引擎开发
- [x] **Phase 3:** 基础 HUD 界面与商店原型实现
- [x] **Phase 4:** CloudKit 远程同步架构搭建
- [ ] **Phase 5:** HD 像素风格 UI 精细化还原
- [ ] **Phase 6:** 全球排行榜逻辑实现
- [ ] **Phase 7:** 触感反馈与交互润色

---

## 📄 开源协议
本项目采用 [MIT License](LICENSE) 协议。
