import SwiftUI

struct PlatformSelectorView: View {
    @Binding var selectedPlatform: Platform
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "globe")
                    .foregroundColor(.secondary)
                    .font(.caption)
                
                Text("Choose Platform")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        PlatformCard(
                            platform: platform,
                            isSelected: selectedPlatform == platform
                        ) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                selectedPlatform = platform
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct PlatformCard: View {
    let platform: Platform
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                // Platform icon with enhanced styling
                ZStack {
                    Circle()
                        .fill(isSelected ? platform.color : Color.clear)
                        .frame(width: 50, height: 50)
                        .shadow(color: isSelected ? platform.color.opacity(0.3) : .clear, radius: 8, x: 0, y: 4)
                    
                    Image(systemName: platform.icon)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : platform.color)
                }
                
                // Platform name
                Text(platform.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? platform.color : .primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 85, height: 90)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? platform.color.opacity(0.1) : Color.clear)
            )
            .background(
                Group {
                    if isSelected {
                        Color.clear
                    } else {
                        Color.clear.background(.ultraThinMaterial)
                    }
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? platform.color : Color.white.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .shadow(
                color: isSelected ? platform.color.opacity(0.2) : .black.opacity(0.1),
                radius: isSelected ? 12 : 8,
                x: 0,
                y: isSelected ? 6 : 4
            )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// Enhanced preview with multiple platforms
#Preview {
    VStack(spacing: 30) {
        PlatformSelectorView(selectedPlatform: .constant(.youtube))
        
        PlatformSelectorView(selectedPlatform: .constant(.google))
        
        PlatformSelectorView(selectedPlatform: .constant(.reddit))
    }
    .padding()
    .background(
        LinearGradient(
            colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 