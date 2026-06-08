import SwiftUI

struct PetSpriteView: View {
    let petEmoji: String
    let isFamine: Bool
    let hatEmoji: String?
    
    @State private var isHopping = false
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .top) {
                // Pet Character
                Text(petEmoji)
                    .font(.system(size: 60))
                    .grayscale(isFamine ? 1.0 : 0)
                    .offset(y: isHopping ? -4 : 0)
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isHopping)
                
                // Integrated Hat Accessory
                if let hat = hatEmoji {
                    Text(hat)
                        .font(.system(size: 24))
                        .offset(x: -10, y: isHopping ? -20 : -15)
                        .rotationEffect(.degrees(-5))
                        .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isHopping)
                }
            }
            
            // Pixel Shadow
            Ellipse()
                .fill(Color.black.opacity(0.2))
                .frame(width: 40, height: 6)
                .scaleEffect(isHopping ? 0.8 : 1.2)
                .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isHopping)
        }
        .onAppear {
            isHopping = true
        }
    }
}

#Preview {
    ZStack {
        Color.gray
        PetSpriteView(petEmoji: "🐱", isFamine: false, hatEmoji: "🎩")
    }
}
