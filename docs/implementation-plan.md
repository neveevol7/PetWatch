# Implementation Plan - Apple Watch Virtual Pet (MVP)

This plan outlines the technical implementation for the Apple Watch Virtual Pet app, focusing on the core mechanics identified during the brainstorming phase: Hunger (Movement/Learning), Mood (Interaction), and Stamina (Charging).

## 1. Objective
Build a native watchOS app using SwiftUI that integrates with HealthKit and CloudKit to create a parent-validated virtual pet experience.

## 2. Key Files & Context
- **Design Spec:** `/Users/yu/Library/Mobile Documents/iCloud~md~obsidian/Documents/Neal/Apple Watch Virtual Pet/2026-05-26-apple-watch-pet-design.md`
- **Platform:** watchOS 10+ (Native SwiftUI)
- **Frameworks:** HealthKit (Steps/Sleep), WatchConnectivity (Parent-Child Sync), CloudKit (Persistence), SwiftUI (UI).

## 3. Implementation Steps

### Phase 1: Project Setup & Data Modeling
- [ ] Initialize a new watchOS app project (SwiftUI).
- [ ] Define the core `Pet` model:
    - `hunger`: Double (0-100)
    - `mood`: Double (0-100)
    - `stamina`: Double (0-100)
    - `level`: Int
    - `coins`: Int
    - `inventory`: List of Decor Items
    - `currentBackground`: Decor Item
- [ ] Setup persistence layer using SwiftData or CoreData (CloudKit enabled).

### Phase 2: Core Status Logic (The "Brain")
- [ ] Implement the `StatusManager` to handle decay:
    - Hunger decay: -5% per hour.
    - Mood decay: -2% per hour.
- [ ] Implement `HealthKitManager`:
    - Read daily steps and convert to Hunger recovery.
    - Monitor `isCharging` status to trigger Stamina recovery (A+D scheme).

### Phase 3: UI Implementation (WatchOS)
- [ ] **Main View:** Central pet character (2D Placeholder for now) with 3 status bars on the side.
- [ ] **Task View:** List of parent-assigned tasks (synced via CloudKit).
- [ ] **Store View:** Grid of decorative items (Hats, Glasses) purchasable with coins.
- [ ] **Leaderboard View:** List of pets sorted by "Collector Score".

### Phase 4: Parent-Child Sync (CloudKit/WatchConnectivity)
- [ ] Implement the "Task Completion" flow:
    - Parent approves task on iPhone (simulated/planned for companion app).
    - Watch receives notification/data update and increases `hunger`.

### Phase 5: Polish & Refinement
- [ ] Add Haptic feedback for task completion and "low energy" warnings.
- [ ] Implement the "Gray out" failure state when Hunger reaches 0.

## 4. Verification & Testing
- [ ] **Unit Tests:** Verify decay logic over simulated time intervals.
- [ ] **HealthKit Simulation:** Use the simulator to inject step data and verify energy gain.
- [ ] **Integration Test:** Verify that charging the device correctly triggers Stamina recovery.
- [ ] **UI Review:** Ensure all status bars and the pet character scale correctly on different Watch sizes.
