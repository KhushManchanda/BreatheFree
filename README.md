# 🚬 Zyn Tracking

A comprehensive iOS and Apple Watch app for tracking daily Zyn consumption with detailed analytics and data visualization.

## ✨ Features

### 📱 iPhone App
- **Daily Counter**: Track your Zyn consumption day by day
- **Multiple Strengths**: Separate counters for 3mg, 6mg, and 9mg Zyn
- **Date Navigation**: View and edit historical data with intuitive date selection
- **Smart Labels**: Clear identification of different Zyn strengths
- **Data Visualization**: Charts showing daily trends and consumption patterns
- **Persistent Storage**: Your data is saved locally and persists between app launches

### ⌚ Apple Watch App
- **Quick Tracking**: Fast one-tap Zyn consumption logging
- **Individual Counters**: View and manage each strength separately
- **Daily Summary**: See your totals and breakdown at a glance
- **Data Synchronization**: Real-time sync with your iPhone app
- **Optimized Interface**: Designed specifically for the small screen

## 🛠️ Technical Details

- **Platform**: iOS 16.0+ / watchOS 9.0+
- **Framework**: SwiftUI
- **Architecture**: MVVM with ObservableObject
- **Data Persistence**: UserDefaults with Codable
- **Charts**: Swift Charts framework
- **Device Sync**: WatchConnectivity framework
- **Language**: Swift 5.9+

## 📱 Screenshots

*Screenshots will be added here once the app is fully functional*

## 🚀 Getting Started

### Prerequisites
- Xcode 15.0+
- iOS 16.0+ device or simulator
- Apple Watch (optional, for Watch app functionality)

### Installation
1. Clone this repository
2. Open `Zyn Tracking.xcodeproj` in Xcode
3. Select your development team in project settings
4. Build and run on your device or simulator

### Building for Apple Watch
1. Add Apple Watch target in Xcode
2. Ensure `Shared/ZynData.swift` is included in both targets
3. Build and run on Watch simulator or device

## 📊 Data Structure

The app uses a hierarchical data model:
- **ZynEntry**: Individual consumption records with date, count, and strength
- **ZynCounter**: Aggregates entries by strength (3mg, 6mg, 9mg)
- **ZynTracker**: Main data manager handling persistence and synchronization

## 🔄 Data Synchronization

Data is synchronized between iPhone and Apple Watch using WatchConnectivity:
- Real-time updates when data changes
- Automatic sync when devices reconnect
- Fallback to local storage if sync fails

## 🎨 UI/UX Features

- **Dark Mode Support**: Automatically adapts to system appearance
- **Accessibility**: VoiceOver support and dynamic type
- **Responsive Design**: Adapts to different screen sizes
- **Intuitive Navigation**: Tab-based interface with clear labels

## 🔧 Development

### Project Structure
```
Zyn Tracking/
├── Zyn Tracking/           # iPhone app source
├── Zyn Track Watch App/    # Apple Watch app source
├── Shared/                 # Shared data models
└── Zyn Tracking.xcodeproj  # Xcode project file
```

### Key Files
- `Shared/ZynData.swift` - Core data models and WatchConnectivity
- `ContentView.swift` - Main iPhone app interface
- `WatchContentView.swift` - Main Watch app interface
- `CounterView.swift` - Individual strength counters
- `VisualizationView.swift` - Charts and analytics

## 🤝 Contributing

This is a personal project, but suggestions and improvements are welcome!

## 📄 License

This project is for personal use only.

## 🙏 Acknowledgments

- Built with SwiftUI and the latest iOS frameworks
- Inspired by the need for better habit tracking
- Special thanks to the iOS development community

---

**Note**: This app is designed for personal use and should not be considered medical advice. Always consult healthcare professionals regarding nicotine consumption.
