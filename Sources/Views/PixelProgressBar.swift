import SwiftUI

struct PixelProgressBar: View {
    let label: String
    let value: Double
    let total: Double = 100.0
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundColor(PixelTheme.border)
                .frame(width: 30, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    Rectangle()
                        .fill(Color.black.opacity(0.8))
                        .border(PixelTheme.border, width: 1)
                    
                    // Fill
                    Rectangle()
                        .fill(color)
                        .padding(2)
                        .frame(width: geometry.size.width * CGFloat(value / total))
                }
            }
            .frame(height: 12)
        }
    }
}

#Preview {
    VStack {
        PixelProgressBar(label: "HP", value: 80, color: PixelTheme.green)
        PixelProgressBar(label: "心情", value: 60, color: PixelTheme.blue)
        PixelProgressBar(label: "精力", value: 30, color: PixelTheme.red)
    }
    .padding()
    .background(Color.white)
}
