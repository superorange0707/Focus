import SwiftUI

struct SearchInputView: View {
    @Binding var searchText: String
    let platform: Platform
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.title3)
                
                TextField("Search \(platform.displayName)...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                    .font(.body)
                    .onSubmit {
                        onSearch()
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title3)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
            
            // Platform-specific search tips
            SearchTipsView(platform: platform)
        }
    }
}

struct SearchTipsView: View {
    let platform: Platform
    
    var tips: [String] {
        switch platform {
        case .youtube:
            return ["Try: 'iOS tutorial', 'SwiftUI tips', 'coding tutorial'"]
        case .reddit:
            return ["Try: 'r/iOSProgramming', 'r/swift', 'iOS development'"]
        case .instagram:
            return ["Try: 'iOS design', 'app development', 'coding'"]
        case .facebook:
            return ["Try: 'iOS groups', 'developer community', 'app development'"]
        case .twitter:
            return ["Try: 'iOS dev', 'SwiftUI', 'app development'"]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Search Tips")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 5)
            
            ForEach(tips, id: \.self) { tip in
                Text(tip)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            }
        }
    }
}

#Preview {
    SearchInputView(
        searchText: .constant("iOS tutorial"),
        platform: .youtube,
        onSearch: {}
    )
    .padding()
    .background(Color.gray.opacity(0.1))
} 