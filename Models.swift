import Foundation
import SwiftUI

// Platform enum
enum Platform: String, CaseIterable {
    case youtube = "youtube"
    case reddit = "reddit"
    case instagram = "instagram"
    case facebook = "facebook"
    case twitter = "twitter"
    
    var displayName: String {
        switch self {
        case .youtube: return "YouTube"
        case .reddit: return "Reddit"
        case .instagram: return "Instagram"
        case .facebook: return "Facebook"
        case .twitter: return "Twitter"
        }
    }
    
    var icon: String {
        switch self {
        case .youtube: return "play.rectangle.fill"
        case .reddit: return "bubble.left.and.bubble.right.fill"
        case .instagram: return "camera.fill"
        case .facebook: return "person.2.fill"
        case .twitter: return "bird.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .youtube: return .red
        case .reddit: return .orange
        case .instagram: return .purple
        case .facebook: return .blue
        case .twitter: return .cyan
        }
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
    
    enum ResultType {
        case video
        case post
        case article
        case image
        case user
    }
}

// Search service
class SearchService {
    static func search(query: String, platform: Platform) -> [SearchResult] {
        // Simulate API results
        switch platform {
        case .youtube:
            return [
                SearchResult(
                    title: "How to Build iOS Apps with SwiftUI",
                    description: "Learn the basics of SwiftUI and build your first iOS app with modern UI design patterns.",
                    url: "https://youtube.com/watch?v=example1",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "15:30", "views": "125K", "channel": "iOS Dev"]
                ),
                SearchResult(
                    title: "iOS 17 Design Guidelines",
                    description: "Complete guide to designing apps for iOS 17 with glass morphism and new design patterns.",
                    url: "https://youtube.com/watch?v=example2",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "22:15", "views": "89K", "channel": "Design Master"]
                ),
                SearchResult(
                    title: "SwiftUI Glass Morphism Tutorial",
                    description: "Step-by-step tutorial on creating beautiful glass morphism effects in SwiftUI.",
                    url: "https://youtube.com/watch?v=example3",
                    thumbnailURL: nil,
                    platform: .youtube,
                    type: .video,
                    metadata: ["duration": "18:45", "views": "67K", "channel": "Swift Tutorials"]
                )
            ]
        case .reddit:
            return [
                SearchResult(
                    title: "Best iOS development resources in 2024",
                    description: "r/iOSProgramming - A comprehensive list of the best resources for iOS development this year.",
                    url: "https://reddit.com/r/iOSProgramming/comments/example1",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .post,
                    metadata: ["upvotes": "1.2k", "comments": "234", "subreddit": "r/iOSProgramming"]
                ),
                SearchResult(
                    title: "SwiftUI vs UIKit: Which should you learn?",
                    description: "r/swift - Detailed comparison and recommendations for new iOS developers.",
                    url: "https://reddit.com/r/swift/comments/example2",
                    thumbnailURL: nil,
                    platform: .reddit,
                    type: .post,
                    metadata: ["upvotes": "856", "comments": "156", "subreddit": "r/swift"]
                )
            ]
        default:
            return [
                SearchResult(
                    title: "Sample \(platform.displayName) Result",
                    description: "This is a sample result for \(platform.displayName) search.",
                    url: "https://\(platform.rawValue).com/sample",
                    thumbnailURL: nil,
                    platform: platform,
                    type: .post,
                    metadata: [:]
                )
            ]
        }
    }
} 