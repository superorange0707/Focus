import SwiftUI

struct PlatformSelectorView: View {
    @Binding var selectedPlatform: Platform
    
    var body: some View {
        VStack(spacing: 15) {
            Text("Choose Platform")
                .font(.headline)
                .foregroundColor(.primary)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(Platform.allCases, id: \.self) { platform in
                        PlatformCard(
                            platform: platform,
                            isSelected: selectedPlatform == platform
                        ) {
                            selectedPlatform = platform
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
            VStack(spacing: 8) {
                Image(systemName: platform.icon)
                    .font(.title2)
                    .foregroundColor(isSelected ? .white : platform.color)
                
                Text(platform.displayName)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isSelected ? platform.color : .ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        isSelected ? platform.color : Color.white.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    PlatformSelectorView(selectedPlatform: .constant(.youtube))
        .padding()
        .background(Color.gray.opacity(0.1))
} 