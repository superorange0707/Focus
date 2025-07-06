import SwiftUI

struct SearchInputView: View {
    @Binding var searchText: String
    let platform: Platform
    let onSearch: () -> Void
    @StateObject private var searchService = SearchService.shared
    @State private var suggestions: [SearchSuggestion] = []
    @State private var showingSuggestions = false
    @State private var selectedSuggestionIndex = 0
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            // Main search input
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    TextField("Search \(platform.displayName)...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.body)
                        .focused($isTextFieldFocused)
                        .onChange(of: searchText) { _, newValue in
                            updateSuggestions(for: newValue)
                        }
                        .onSubmit {
                            performSearch()
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                            suggestions = []
                            showingSuggestions = false
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.secondary)
                                .font(.title3)
                        }
                        .transition(.scale.combined(with: .opacity))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isTextFieldFocused ? platform.color.opacity(0.6) : Color.white.opacity(0.3),
                            lineWidth: isTextFieldFocused ? 2 : 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                
                // Suggestions dropdown
                if showingSuggestions && !suggestions.isEmpty {
                    VStack(spacing: 0) {
                        ForEach(Array(suggestions.enumerated()), id: \.element.id) { index, suggestion in
                            SuggestionRow(
                                suggestion: suggestion,
                                isSelected: index == selectedSuggestionIndex,
                                onTap: {
                                    searchText = suggestion.text
                                    showingSuggestions = false
                                    performSearch()
                                }
                            )
                            
                            if index < suggestions.count - 1 {
                                Divider()
                                    .background(Color.white.opacity(0.1))
                            }
                        }
                    }
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.15), radius: 15, x: 0, y: 10)
                    .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            // Quick search buttons
            if searchText.isEmpty && !isTextFieldFocused {
                QuickSearchButtons(platform: platform) { query in
                    searchText = query
                    performSearch()
                }
            }
            
            // Platform-specific search tips
            if searchText.isEmpty {
                SearchTipsView(platform: platform)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: showingSuggestions)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: searchText.isEmpty)
    }
    
    private func updateSuggestions(for query: String) {
        if query.isEmpty {
            suggestions = []
            showingSuggestions = false
        } else {
            suggestions = searchService.getSuggestions(for: query, platform: platform)
            showingSuggestions = !suggestions.isEmpty
            selectedSuggestionIndex = 0
        }
    }
    
    private func performSearch() {
        guard !searchText.isEmpty else { return }
        showingSuggestions = false
        onSearch()
    }
}

struct SuggestionRow: View {
    let suggestion: SearchSuggestion
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                // Suggestion type icon
                Image(systemName: suggestionTypeIcon)
                    .foregroundColor(suggestionTypeColor)
                    .font(.caption)
                    .frame(width: 20, height: 20)
                    .background(suggestionTypeColor.opacity(0.2))
                    .clipShape(Circle())
                
                // Suggestion text
                VStack(alignment: .leading, spacing: 2) {
                    Text(suggestion.text)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    
                    Text(suggestionTypeText)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Platform icon if available
                if let platform = suggestion.platform {
                    Image(systemName: platform.icon)
                        .foregroundColor(platform.color)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(isSelected ? Color.white.opacity(0.1) : Color.clear)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var suggestionTypeIcon: String {
        switch suggestion.type {
        case .recent: return "clock"
        case .popular: return "star"
        case .trending: return "flame"
        case .related: return "link"
        }
    }
    
    private var suggestionTypeColor: Color {
        switch suggestion.type {
        case .recent: return .blue
        case .popular: return .yellow
        case .trending: return .orange
        case .related: return .green
        }
    }
    
    private var suggestionTypeText: String {
        switch suggestion.type {
        case .recent: return "Recent search"
        case .popular: return "Popular"
        case .trending: return "Trending"
        case .related: return "Related"
        }
    }
}

struct QuickSearchButtons: View {
    let platform: Platform
    let onTap: (String) -> Void
    
    var quickQueries: [String] {
        switch platform {
        case .youtube:
            return ["iOS tutorial", "SwiftUI", "App development", "Coding tips"]
        case .reddit:
            return ["r/iOSProgramming", "r/swift", "iOS development", "App Store"]
        case .instagram:
            return ["#iOS", "#SwiftUI", "#AppDev", "#Coding"]
        case .facebook:
            return ["iOS groups", "Developer community", "App development", "Coding"]
        case .twitter:
            return ["iOS dev", "SwiftUI", "App development", "Coding"]
        case .google:
            return ["iOS development", "SwiftUI tutorial", "App Store", "Apple Developer"]
        case .bing:
            return ["iOS development", "SwiftUI tutorial", "App Store", "Apple Developer"]
        }
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Quick Search")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal, 5)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 10) {
                ForEach(quickQueries, id: \.self) { query in
                    Button(action: {
                        onTap(query)
                    }) {
                        Text(query)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

struct SearchTipsView: View {
    let platform: Platform
    
    var tips: [String] {
        switch platform {
        case .youtube:
            return [
                "Try: 'iOS tutorial' for step-by-step guides",
                "Try: 'SwiftUI tips' for development tips",
                "Try: 'coding tutorial' for programming help"
            ]
        case .reddit:
            return [
                "Try: 'r/iOSProgramming' for community discussions",
                "Try: 'r/swift' for Swift language help",
                "Try: 'iOS development' for general topics"
            ]
        case .instagram:
            return [
                "Try: '#iOS' for design inspiration",
                "Try: '#AppDev' for development content",
                "Try: '#Coding' for programming posts"
            ]
        case .facebook:
            return [
                "Try: 'iOS groups' for community groups",
                "Try: 'developer community' for networking",
                "Try: 'app development' for project discussions"
            ]
        case .twitter:
            return [
                "Try: 'iOS dev' for developer tweets",
                "Try: 'SwiftUI' for framework discussions",
                "Try: 'app development' for industry news"
            ]
        case .google, .bing:
            return [
                "Try: 'iOS development' for comprehensive results",
                "Try: 'SwiftUI tutorial' for learning resources",
                "Try: 'App Store guidelines' for publishing info"
            ]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.caption)
                
                Text("Search Tips")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 5)
            
            ForEach(tips, id: \.self) { tip in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(platform.color)
                        .font(.caption2)
                        .padding(.top, 2)
                    
                    Text(tip)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(.ultraThinMaterial)
                .cornerRadius(15)
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

#Preview {
    SearchInputView(
        searchText: .constant("iOS tutorial"),
        platform: .youtube,
        onSearch: {}
    )
    .padding()
    .background(
        LinearGradient(
            colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    )
} 