# Focus Search

A minimalist iOS app that helps users search across multiple platforms without getting distracted by recommendation algorithms.

## Features

### 🎯 **Focus-Driven Design**
- Clean, distraction-free interface
- No recommendation feeds or suggested content
- Direct search functionality

### 🔍 **Multi-Platform Search**
- **YouTube** - Search videos and channels
- **Reddit** - Search posts and communities  
- **Instagram** - Search posts and profiles
- **Facebook** - Search groups and posts
- **Twitter** - Search tweets and users

### 🎨 **iOS 17+ Glass Morphism UI**
- Beautiful glass morphism effects
- Ultra-thin material backgrounds
- Smooth animations and transitions
- Modern iOS design patterns

### 📱 **Smart Result Display**
- Platform-specific result cards
- Rich metadata display (views, duration, upvotes, etc.)
- Preview content without leaving the app
- Option to open in browser or native app

## How It Works

1. **Choose Platform** - Select which platform to search (YouTube, Reddit, etc.)
2. **Search** - Enter your query in the clean search interface
3. **View Results** - See results in a unified, distraction-free format
4. **Interact** - Preview content or choose to open in external apps

## Technical Stack

- **iOS 17+** - Latest iOS features and design patterns
- **SwiftUI** - Modern declarative UI framework
- **Glass Morphism** - `.ultraThinMaterial` backgrounds
- **Multi-Platform APIs** - YouTube Data API, Reddit API, etc.

## Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 17.0+ deployment target
- iPhone/iPad device or simulator

### Installation
1. Clone the repository
2. Open `Focus.xcodeproj` in Xcode
3. Build and run on your device or simulator

## Project Structure

```
Focus/
├── FocusApp.swift              # App entry point
├── ContentView.swift           # Main interface
├── Models.swift               # Data models and services
├── PlatformSelectorView.swift # Platform selection UI
├── SearchInputView.swift      # Search input component
└── SearchResultsView.swift    # Results display
```

## API Integration

The app currently uses simulated data for demonstration. To integrate real APIs:

### YouTube Data API
- Get API key from Google Cloud Console
- Implement video search and metadata fetching

### Reddit API
- Register Reddit app for API access
- Implement post search and community browsing

### Other Platforms
- Instagram Graph API (requires business account)
- Facebook Graph API
- Twitter API v2

## Design Philosophy

**Focus Search** is built on the principle that users should be able to find what they're looking for without being distracted by algorithmic recommendations. The app provides:

- **Intentional Search** - Users choose what to search for
- **Clean Results** - No ads, recommendations, or suggested content
- **Platform Flexibility** - Search across multiple platforms from one interface
- **Modern UI** - Beautiful glass morphism design that feels native to iOS

## Future Enhancements

- [ ] Real API integration for all platforms
- [ ] Search history and favorites
- [ ] Advanced filtering options
- [ ] Dark mode support
- [ ] iPad optimization
- [ ] Search suggestions and autocomplete
- [ ] Offline result caching

## License

This project is for educational and demonstration purposes.

---

**Focus Search** - Find what you're looking for, not what algorithms want you to see. 