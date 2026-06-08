import SwiftUI

struct EnvironmentBackgroundView: View {
    let backgroundEmoji: String? // 可以根据 DecorItem 切换
    
    var body: some View {
        ZStack {
            // Sky
            Rectangle()
                .fill(Color(red: 128/255, green: 208/255, blue: 240/255))
            
            // Ground
            VStack {
                Spacer()
                Rectangle()
                    .fill(Color(red: 144/255, green: 238/255, blue: 144/255))
                    .frame(height: 60)
            }
            
            // Decor (e.g. Grass or purchased background elements)
            if let bg = backgroundEmoji {
                Text(bg)
                    .font(.system(size: 40))
                    .offset(x: 40, y: 30)
            } else {
                // Default Grass
                HStack(spacing: 20) {
                    Text("🌿").font(.system(size: 20))
                    Text("🌿").font(.system(size: 20))
                }
                .opacity(0.4)
                .offset(y: 40)
            }
        }
        .border(PixelTheme.border, width: 2)
        .clipped()
    }
}

#Preview {
    EnvironmentBackgroundView(backgroundEmoji: nil)
        .frame(width: 200, height: 150)
}
