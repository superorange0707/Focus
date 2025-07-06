import SwiftUI
import SafariServices

struct SearchResultsView: View {
    let results: [SearchResult]
    let platform: Platform
    let onDismiss: () -> Void
    @State private var selectedResult: SearchResult?
    @State private var showingDetail = false
    
    var body: some View {
        ZStack {
            // Background blur
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(results.count) Results")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        
                        Text("Found on \(platform.displayName)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: onDismiss) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                
                // Results list
                ScrollView {
                    LazyVStack(spacing: 15) {
                        ForEach(results) { result in
                            SearchResultCard(
                                result: result,
                                onTap: {
                                    selectedResult = result
                                    showingDetail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                }
            }
            .background(.ultraThinMaterial)
            .cornerRadius(25, corners: [.topLeft, .topRight])
            .frame(maxHeight: UIScreen.main.bounds.height * 0.85)
        }
        .sheet(isPresented: $showingDetail) {
            if let result = selectedResult {
                ResultDetailView(result: result)
            }
        }
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    let onTap: () -> Void
    @State private var showingPreview = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header with platform info
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: result.platform.icon)
                        .foregroundColor(result.platform.color)
                        .font(.title3)
                    
                    Text(result.platform.displayName)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Type indicator
                Text(typeIndicator)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(result.platform.color.opacity(0.2))
                    .foregroundColor(result.platform.color)
                    .cornerRadius(8)
            }
            
            // Title
            Text(result.title)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
            
            // Description
            Text(result.description)
                .font(.body)
                .foregroundColor(.secondary)
                .lineLimit(3)
                .multilineTextAlignment(.leading)
            
            // Preview content if available
            if let previewContent = result.previewContent {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "text.quote")
                            .foregroundColor(result.platform.color)
                            .font(.caption)
                        
                        Text("Preview")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(previewContent)
                        .font(.caption)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .padding(.leading, 20)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            
            // Metadata
            if !result.metadata.isEmpty {
                HStack(spacing: 15) {
                    ForEach(Array(result.metadata.keys.sorted()), id: \.self) { key in
                        if let value = result.metadata[key] {
                            HStack(spacing: 4) {
                                Image(systemName: metadataIcon(for: key))
                                    .font(.caption2)
                                Text(value)
                                    .font(.caption2)
                                    .fontWeight(.medium)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
            // Action buttons
            HStack(spacing: 12) {
                // Quick action button
                Button(action: {
                    performQuickAction()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: quickActionIcon)
                        Text(quickActionText)
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(result.platform.color)
                    .cornerRadius(8)
                }
                
                // Preview button
                Button(action: {
                    showingPreview = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "eye")
                        Text("Preview")
                    }
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(result.platform.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(result.platform.color, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                // More options
                Button(action: onTap) {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(.secondary)
                        .font(.title3)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.3), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .sheet(isPresented: $showingPreview) {
            ResultPreviewView(result: result)
        }
    }
    
    private var typeIndicator: String {
        switch result.type {
        case .video: return "VIDEO"
        case .post: return "POST"
        case .article: return "ARTICLE"
        case .image: return "IMAGE"
        case .user: return "USER"
        case .website: return "WEBSITE"
        case .news: return "NEWS"
        case .product: return "PRODUCT"
        }
    }
    
    private var quickActionIcon: String {
        switch result.directAction {
        case .openInApp: return "arrow.up.right.square"
        case .openInBrowser: return "safari"
        case .share: return "square.and.arrow.up"
        case .bookmark: return "bookmark"
        case .none: return "arrow.up.right.square"
        }
    }
    
    private var quickActionText: String {
        switch result.directAction {
        case .openInApp: return "Open in App"
        case .openInBrowser: return "Open in Browser"
        case .share: return "Share"
        case .bookmark: return "Bookmark"
        case .none: return "Open"
        }
    }
    
    private func performQuickAction() {
        switch result.directAction {
        case .openInApp:
            openInNativeApp()
        case .openInBrowser:
            openInBrowser()
        case .share:
            shareContent()
        case .bookmark:
            bookmarkContent()
        case .none:
            openInNativeApp()
        }
    }
    
    private func openInNativeApp() {
        let success = URLSchemeHandler.shared.openInNativeApp(platform: result.platform, url: result.url)
        if !success {
            openInBrowser()
        }
    }
    
    private func openInBrowser() {
        if let url = URL(string: result.url) {
            UIApplication.shared.open(url)
        }
    }
    
    private func shareContent() {
        let activityVC = UIActivityViewController(
            activityItems: [result.title, result.url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func bookmarkContent() {
        // Implement bookmark functionality
        print("Bookmarking: \(result.title)")
    }
    
    private func metadataIcon(for key: String) -> String {
        switch key {
        case "duration": return "clock"
        case "views": return "eye"
        case "channel": return "person"
        case "upvotes": return "arrow.up"
        case "comments": return "bubble.left"
        case "subreddit": return "r.circle"
        case "uploaded", "posted": return "calendar"
        case "domain": return "globe"
        case "type": return "tag"
        default: return "info.circle"
        }
    }
}

struct ResultDetailView: View {
    let result: SearchResult
    @Environment(\.dismiss) private var dismiss
    @State private var showingSafari = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Platform header
                    HStack {
                        Image(systemName: result.platform.icon)
                            .foregroundColor(result.platform.color)
                            .font(.title)
                        
                        VStack(alignment: .leading) {
                            Text(result.platform.displayName)
                                .font(.headline)
                                .fontWeight(.semibold)
                            Text(typeIndicator)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    
                    // Content
                    VStack(alignment: .leading, spacing: 15) {
                        Text(result.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(result.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Preview content
                        if let previewContent = result.previewContent {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "text.quote")
                                        .foregroundColor(result.platform.color)
                                    Text("Preview")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                
                                Text(previewContent)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(.ultraThinMaterial)
                                    .cornerRadius(10)
                            }
                        }
                        
                        // Metadata
                        if !result.metadata.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Details")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                
                                ForEach(Array(result.metadata.keys.sorted()), id: \.self) { key in
                                    if let value = result.metadata[key] {
                                        HStack {
                                            Text(key.capitalized)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                            Spacer()
                                            Text(value)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                    }
                                }
                            }
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                        }
                    }
                    
                    // Action buttons
                    VStack(spacing: 15) {
                        Button(action: {
                            showingSafari = true
                        }) {
                            HStack {
                                Image(systemName: "safari")
                                Text("Open in Safari")
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(result.platform.color)
                            .cornerRadius(15)
                        }
                        
                        Button(action: {
                            openInNativeApp()
                        }) {
                            HStack {
                                Image(systemName: "arrow.up.right.square")
                                Text("Open in \(result.platform.displayName)")
                            }
                            .font(.headline)
                            .foregroundColor(result.platform.color)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(result.platform.color, lineWidth: 1)
                            )
                        }
                        
                        Button(action: {
                            shareContent()
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(.ultraThinMaterial)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Result Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .sheet(isPresented: $showingSafari) {
            SafariView(url: URL(string: result.url) ?? URL(string: "https://google.com")!)
        }
    }
    
    private var typeIndicator: String {
        switch result.type {
        case .video: return "Video"
        case .post: return "Post"
        case .article: return "Article"
        case .image: return "Image"
        case .user: return "User"
        case .website: return "Website"
        case .news: return "News"
        case .product: return "Product"
        }
    }
    
    private func openInNativeApp() {
        let success = URLSchemeHandler.shared.openInNativeApp(platform: result.platform, url: result.url)
        if !success {
            showingSafari = true
        }
    }
    
    private func shareContent() {
        let activityVC = UIActivityViewController(
            activityItems: [result.title, result.url],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

struct ResultPreviewView: View {
    let result: SearchResult
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Preview header
                HStack {
                    Image(systemName: result.platform.icon)
                        .foregroundColor(result.platform.color)
                        .font(.title2)
                    
                    VStack(alignment: .leading) {
                        Text("Preview")
                            .font(.headline)
                            .fontWeight(.semibold)
                        Text(result.platform.displayName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(15)
                
                // Preview content
                VStack(alignment: .leading, spacing: 15) {
                    Text(result.title)
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    if let previewContent = result.previewContent {
                        Text(previewContent)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(10)
                    }
                    
                    Text(result.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Action button
                Button(action: {
                    let success = URLSchemeHandler.shared.openInNativeApp(platform: result.platform, url: result.url)
                    if !success {
                        URLSchemeHandler.shared.openInBrowser(url: result.url)
                    }
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "arrow.up.right.square")
                        Text("Open in \(result.platform.displayName)")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(result.platform.color)
                    .cornerRadius(15)
                }
            }
            .padding()
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Safari View for better web browsing experience
struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    SearchResultsView(
        results: SearchService.shared.search(query: "iOS", platform: .youtube),
        platform: .youtube,
        onDismiss: {}
    )
} 