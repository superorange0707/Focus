import Foundation
import SwiftUI

// Platform enum
enum Platform: String, CaseIterable {
    case youtube = "youtube"
    case reddit = "reddit"
    case instagram = "instagram"
    case facebook = "facebook"
    case twitter = "twitter"
    case google = "google"
    case bing = "bing"
    
    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .reddit: return "Reddit"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .twitter: return "Twitter"
        case .google: return "Google"
        case .bing: return "Bing"
        }
    }
    
    var icon: String {
        switch self {
        case .youtube: return "play.rectangle.fill"
        case .reddit: return "bubble.left.and.bubble.right.fill"
        case .instagram: return "camera.fill"
        case .facebook: return "person.2.fill"
        case .twitter: return "bird.fill"
        case .google: return "magnifyingglass"
        case .bing: return "magnifyingglass.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .youtube: return .red
        case .reddit: return .orange
        case .instagram: return .purple
        case .facebook: return .blue
        case .twitter: return .cyan
        case .google: return .blue
        case .bing: return .blue
        }
    }
    
    var searchURL: String {
        switch self {
        case .youtube: return "https://www.youtube.com/results?search_query="
        case .reddit: return "https://www.reddit.com/search/?q="
        case .instagram: return "https://www.instagram.com/explore/tags/"
        case .facebook: return "https://www.facebook.com/search/top/?q="
        case .twitter: return "https://twitter.com/search?q="
        case .google: return "https://www.google.com/search?q="
        case .bing: return "https://www.bing.com/search?q="
        }
    }
    
    var appScheme: String? {
        switch self {
        case .youtube: return "youtube://"
        case .reddit: return "reddit://"
        case .instagram: return "instagram://"
        case .facebook: return "fb://"
        case .twitter: return "twitter://"
        case .google: return "google://"
        case .bing: return "bing://"
        }
    }
}

// Search suggestion model
struct SearchSuggestion: Identifiable, Hashable {
    let id = UUID()
    let text: String
    let type: SuggestionType
    let platform: Platform?
    
    enum SuggestionType {
        case recent
        case popular
        case trending
        case related
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func == (lhs: SearchSuggestion, rhs: SearchSuggestion) -> Bool {
        lhs.text == rhs.text
    }
}

// Search result model
struct SearchResult: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let thumbnailURL: String?
    let platform: Platform
    let type: ResultType
    let metadata: [String: String]
    let previewContent: String?
    let directAction: DirectAction?
    
    enum ResultType {
        case video
        case post
        case article
        case image
        case user
        case website
        case news
        case product
    }
    
    enum DirectAction {
        case openInApp
        case openInBrowser
        case share
        case bookmark
    }
}

// Search service
class SearchService: ObservableObject {
    static let shared = SearchService()
    
    @Published var recentSearches: [String] = []
    @Published var popularSearches: [String] = []
    
    private init() {
        loadRecentSearches()
        loadPopularSearches()
    }
    
    func getSuggestions(for query: String, platform: Platform) -> [SearchSuggestion] {
        var suggestions: [SearchSuggestion] = []
        
        // Add recent searches
        let recentMatches = recentSearches.filter { $0.lowercased().contains(query.lowercased()) }
        suggestions.append(contentsOf: recentMatches.prefix(3).map { 
            SearchSuggestion(text: $0, type: .recent, platform: nil) 
        })
        
        // Add platform-specific suggestions
        let platformSuggestions = getPlatformSuggestions(for: platform, query: query)
        suggestions.append(contentsOf: platformSuggestions)
        
        // Add trending suggestions
        let trendingSuggestions = getTrendingSuggestions(for: platform)
        suggestions.append(contentsOf: trendingSuggestions)
        
        return Array(Set(suggestions)).prefix(8).map { $0 }
    }
    
    private func getPlatformSuggestions(for platform: Platform, query: String) -> [SearchSuggestion] {
        switch platform {
        case .youtube:
            return [
                "\(query) tutorial",
                "\(query) review",
                "\(query) 2024",
                "how to \(query)"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .reddit:
            return [
                "r/\(query)",
                "\(query) reddit",
                "\(query) discussion",
                "\(query) community"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        case .instagram:
            return [
                "#\(query)",
                "\(query) instagram",
                "\(query) photos",
                "\(query) stories"
            ].map { SearchSuggestion(text: $0, type: .related, platform: platform) }
        default:
            return []
        }
    }
    
    private func getTrendingSuggestions(for platform: Platform) -> [SearchSuggestion] {
        switch platform {
        case .youtube:
            return [
                "iOS 17 tutorial",
                "SwiftUI tips",
                "App development",
                "Coding tutorial"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        case .reddit:
            return [
                "r/iOSProgramming",
                "r/swift",
                "r/apple",
                "r/technology"
            ].map { SearchSuggestion(text: $0, type: .trending, platform: platform) }
        default:
            return []
        }
    }
    
    func search(query: String, platform: Platform) -> [SearchResult] {
        // Add to recent searches
        addToRecentSearches(query)
        
        // Simulate API results with enhanced data
        switch platform {
        case .youtube:
            return [
                SearchResult(
                    title: "How to Build iOS Apps with SwiftUI - Complete Tutorial 2024",
                    description: "Learn the basics of SwiftUI and build your first iOS app with modern UI design patterns. This comprehensive tutorial covers everything from basic concepts to advanced features.",
                    url: "https://youtube.com/watch?v=example1",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "15:30", "views": "125K", "channel": "iOS Dev", "uploaded": "2 days ago"],
                    previewContent: "In this tutorial, we'll cover SwiftUI basics, UI components, navigation, and data binding. Perfect for beginners!",
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "iOS 17 Design Guidelines - Glass Morphism & New Patterns",
                    description: "Complete guide to designing apps for iOS 17 with glass morphism and new design patterns. Learn how to create beautiful, modern interfaces.",
                    url: "https://youtube.com/watch?v=example2",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "22:15", "views": "89K", "channel": "Design Master", "uploaded": "1 week ago"],
                    previewContent: "Discover the latest iOS design trends including glass morphism, dynamic colors, and accessibility improvements.",
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "SwiftUI Glass Morphism Tutorial - Step by Step Guide",
                    description: "Step-by-step tutorial on creating beautiful glass morphism effects in SwiftUI. Learn advanced UI techniques and animations.",
                    url: "https://youtube.com/watch?v=example3",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "18:45", "views": "67K", "channel": "Swift Tutorials", "uploaded": "3 days ago"],
                    previewContent: "Create stunning glass morphism effects with blur, transparency, and dynamic backgrounds in your SwiftUI apps.",
                    directAction: .openInApp
                )
            ]
        case .reddit:
            return [
                SearchResult(
                    title: "Best iOS development resources in 2024 - Comprehensive Guide",
                    description: "r/iOSProgramming - A comprehensive list of the best resources for iOS development this year. Books, courses, tools, and communities.",
                    url: "https://reddit.com/r/iOSProgramming/comments/example1",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .post,
                    metadata: ["upvotes": "1.2k", "comments": "234", "subreddit": "r/iOSProgramming", "posted": "5 hours ago"],
                    previewContent: "Here's my curated list of the best iOS development resources for 2024. I've been developing for iOS for 5 years and these are the tools that have helped me the most...",
                    directAction: .openInApp
                ),
                SearchResult(
                    title: "SwiftUI vs UIKit: Which should you learn in 2024?",
                    description: "r/swift - Detailed comparison and recommendations for new iOS developers. Pros and cons of each framework.",
                    url: "https://reddit.com/r/swift/comments/example2",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .post,
                    metadata: ["upvotes": "856", "comments": "156", "subreddit": "r/swift", "posted": "1 day ago"],
                    previewContent: "I'm a beginner iOS developer and I'm confused about whether to learn SwiftUI or UIKit first. Here's my analysis after researching both...",
                    directAction: .openInApp
                )
            ]
        case .google:
            return [
                SearchResult(
                    title: "iOS Development Guide - Apple Developer",
                    description: "Official iOS development documentation and resources from Apple. Learn to build apps for iPhone, iPad, and Mac.",
                    url: "https://developer.apple.com/ios/",
                    thumbnailURL: nil,
                    platform: .google,
                    type: .website,
                    metadata: ["domain": "developer.apple.com", "type": "Official Documentation"],
                    previewContent: "Start your journey in iOS development with official Apple resources, tutorials, and documentation.",
                    directAction: .openInBrowser
                )
            ]
        default:
            return [
                SearchResult(
                    title: "Sample \(platform.displayName) Result",
                    description: "This is a sample result for \(platform.displayName) search with enhanced metadata and preview content.",
                    url: "https://\(platform.rawValue).com/sample",
                    thumbnailURL: nil,
                    platform: platform,
                    type: .website,
                    metadata: ["domain": "\(platform.rawValue).com"],
                    previewContent: "Sample preview content for \(platform.displayName) search results.",
                    directAction: .openInBrowser
                )
            ]
        }
    }
    
    private func addToRecentSearches(_ query: String) {
        if !recentSearches.contains(query) {
            recentSearches.insert(query, at: 0)
            if recentSearches.count > 10 {
                recentSearches = Array(recentSearches.prefix(10))
            }
            saveRecentSearches()
        }
    }
    
    private func loadRecentSearches() {
        if let data = UserDefaults.standard.data(forKey: "recentSearches"),
           let searches = try? JSONDecoder().decode([String].self, from: data) {
            recentSearches = searches
        }
    }
    
    private func saveRecentSearches() {
        if let data = try? JSONEncoder().encode(recentSearches) {
            UserDefaults.standard.set(data, forKey: "recentSearches")
        }
    }
    
    private func loadPopularSearches() {
        popularSearches = [
            "iOS tutorial",
            "SwiftUI",
            "App development",
            "Coding tips",
            "Design patterns"
        ]
    }
} 