# FrontierMetrix

A 3D globe-based financial asset visualization iOS app built with SwiftUI and MapKit.

## Features

- **3D Globe Visualization**: Interactive 3D globe using MapKit with smooth camera controls (rotate/tilt/zoom)
- **Asset Pins**: Interactive asset pins with pulsing risk badges and 44x44pt accessible targets
- **Capital Flow Arcs**: Great-circle polylines with arch height and gradient width/opacity by magnitude
- **Real-time Filtering**: Filter by asset class, region, risk level, and time window
- **Timeline Controls**: Play/pause timeline with scrubbing and haptic feedback
- **Performance Optimized**: Auto-switches between SwiftUI and MKMapView backends based on data load
- **Accessibility**: Full VoiceOver support with proper labels and hints

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Quick Start

1. **Open the project** in Xcode 15+
2. **Select your target device** (iPhone or iPad)
3. **Build and run** (⌘+R)

The app will launch with a 3D globe showing financial assets from around the world. Tap on any asset pin to view details, use the filter bar to customize the view, and control the timeline to see how data changes over time.

## Project Structure

```
FrontierMetrix/
├── App/
│   ├── FrontierMetrixApp.swift      # Main app entry point
│   ├── GlobeScreen.swift            # Main globe interface
│   └── DebugOverlay.swift           # Debug information overlay
├── Models/
│   ├── AssetSignal.swift            # Financial asset data model
│   ├── AssetFlow.swift              # Capital flow data model
│   ├── Filters.swift                # Filtering and region presets
│   ├── AssetClass.swift             # Asset type definitions
│   └── RiskLevel.swift              # Risk level definitions
├── Services/
│   ├── SignalRepository.swift       # Data repository protocol
│   ├── DataLoader.swift             # JSON data loading service
│   ├── TimelineEngine.swift         # Timeline control and animation
│   ├── FlowArcCalculator.swift      # Great-circle arc calculations
│   └── RiskStyling.swift            # Risk-based visual styling
├── Map/
│   ├── FrontierMapView.swift        # High-level map switcher
│   ├── SwiftUIMapBackend.swift      # SwiftUI Map implementation
│   ├── MKMapBackend.swift           # MKMapView implementation
│   ├── MapCameraController.swift    # Camera control logic
│   ├── MapAnnotations.swift         # Asset pin views
│   ├── MapOverlays.swift            # Flow arc overlays
│   └── GlobeMKView.swift            # MKMapView wrapper
├── UI/
│   ├── FilterBar.swift              # Asset filtering interface
│   ├── TimelineScrubber.swift       # Timeline controls
│   └── AssetInfoSheet.swift         # Asset detail sheet
├── Data/
│   ├── seed_assets.json             # Sample asset data
│   └── seed_flows.json              # Sample flow data
└── Tests/
    ├── FlowArcCalculatorTests.swift # Unit tests for arc calculations
    ├── RiskStylingTests.swift       # Unit tests for styling
    ├── DataLoaderTests.swift        # Unit tests for data loading
    └── UITests_GlobeBasics.swift    # UI tests for basic functionality
```

## Key Components

### 3D Globe
- Uses MapKit's 3D globe mode with realistic elevation
- Smooth camera controls with rotation, tilt, and zoom
- Automatic backend switching based on performance needs

### Asset Visualization
- **Pins**: Color-coded by risk level with pulsing animations
- **Flows**: Great-circle arcs showing capital movement
- **Clustering**: Automatic clustering for high-density areas
- **Accessibility**: Full VoiceOver support

### Filtering System
- **Asset Classes**: Currency, Crypto, Bond, Commodity, Stablecoin
- **Regions**: Global, Africa, Latin America, Asia Pacific, EMEA, MENA, Europe, North America
- **Risk Levels**: Low, Medium, High, Extreme
- **Time Range**: Dynamic filtering based on timeline position

### Timeline Engine
- Play/pause controls with smooth animation
- Haptic feedback on timeline ticks
- Configurable playback speed
- Date range scrubbing

## Performance

The app automatically switches between rendering backends based on data load:
- **SwiftUI Map**: Used for ≤300 pins and ≤20 flows (previews, small datasets)
- **MKMapView**: Used for larger datasets (default for production)

Performance targets:
- ≥45 FPS on iPhone 14 Pro (Release build)
- <120ms response time for pin taps
- Graceful degradation for high data volumes

## Testing

Run the test suite with ⌘+U in Xcode:

- **Unit Tests**: Core business logic and calculations
- **UI Tests**: Basic user interactions and accessibility
- **Performance Tests**: Load time and responsiveness

## Architecture

The app follows a clean architecture pattern:
- **Models**: Pure data structures with business logic
- **Services**: Repository pattern with Combine publishers
- **Map**: Pluggable rendering backends
- **UI**: SwiftUI views with proper state management

## Future Enhancements

- **Firestore Integration**: Real-time data updates
- **Advanced Analytics**: Trend analysis and predictions
- **Custom Themes**: User-customizable visual styles
- **Export Features**: Data export and sharing
- **Offline Support**: Cached data for offline viewing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.