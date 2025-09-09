# FrontierMetrix

A 3D globe-based financial asset visualization web application built with Next.js, React, and Three.js.

## Features

- **3D Globe Visualization**: Interactive 3D globe using Three.js with smooth camera controls (rotate/tilt/zoom)
- **Asset Pins**: Interactive asset pins with pulsing risk badges and hover effects
- **Capital Flow Arcs**: Great-circle polylines with arch height and gradient styling by magnitude
- **Real-time Filtering**: Filter by asset class, region, risk level, and time window
- **Timeline Controls**: Play/pause timeline with scrubbing and smooth animation
- **Performance Optimized**: Efficient rendering with WebGL and Three.js
- **Responsive Design**: Works on desktop and mobile devices

## Requirements

- Node.js 18+
- npm or pnpm
- Modern web browser with WebGL support

## Quick Start

1. **Install dependencies**:
   ```bash
   cd apps/web
   npm install
   ```

2. **Start the development server**:
   ```bash
   npm run dev
   ```

3. **Open your browser** and navigate to `http://localhost:3000/globe`

The app will load with a 3D globe showing financial assets from around the world. Click on any asset pin to view details, use the filter controls to customize the view, and control the timeline to see how data changes over time.

## Project Structure

```
apps/web/
├── src/
│   ├── app/
│   │   ├── api/globe/
│   │   │   ├── assets/route.ts      # API endpoint for asset data
│   │   │   └── flows/route.ts       # API endpoint for flow data
│   │   └── globe/
│   │       └── page.tsx             # Main globe page
│   ├── components/
│   │   └── globe/
│   │       ├── GlobeView.tsx        # 3D globe component
│   │       ├── GlobeFilters.tsx     # Filter controls
│   │       ├── GlobeTimeline.tsx    # Timeline controls
│   │       └── AssetInfoPanel.tsx   # Asset detail panel
│   ├── lib/
│   │   ├── types/
│   │   │   └── globe.ts             # TypeScript types
│   │   └── services/
│   │       └── globeData.ts         # Data service
│   └── components/layout/
│       └── SideNav.tsx              # Navigation (updated)
└── package.json
```

## Key Components

### 3D Globe
- Uses Three.js for WebGL-based 3D rendering
- Smooth camera controls with OrbitControls
- Real-time asset and flow visualization
- Responsive design for different screen sizes

### Asset Visualization
- **Pins**: Color-coded by risk level with pulsing animations
- **Flows**: Great-circle arcs showing capital movement
- **Hover Effects**: Interactive labels and tooltips
- **Click Handlers**: Asset selection and detail viewing

### Filtering System
- **Asset Classes**: Currency, Crypto, Bond, Commodity, Stablecoin
- **Regions**: Global, Africa, Latin America, Asia Pacific, EMEA, MENA, Europe, North America
- **Risk Levels**: Low, Medium, High, Extreme
- **Time Range**: Dynamic filtering based on timeline position

### Timeline Engine
- Play/pause controls with smooth animation
- Date range scrubbing with visual feedback
- Real-time data filtering based on selected date
- Configurable playback speed

## Technology Stack

- **Frontend**: Next.js 14, React 18, TypeScript
- **3D Graphics**: Three.js, @react-three/fiber, @react-three/drei
- **Styling**: Tailwind CSS
- **State Management**: React hooks and context
- **API**: Next.js API routes

## Performance

- **WebGL Rendering**: Hardware-accelerated 3D graphics
- **Efficient Updates**: Only re-render when data changes
- **Memory Management**: Proper cleanup of Three.js objects
- **Responsive Design**: Optimized for different screen sizes

## Development

### Running the Development Server

```bash
cd apps/web
npm run dev
```

### Building for Production

```bash
npm run build
npm start
```

### Testing

```bash
npm run test
```

## API Endpoints

- `GET /api/globe/assets` - Returns sample asset data
- `GET /api/globe/flows` - Returns sample flow data

## Future Enhancements

- **Real-time Data**: Integration with live financial data APIs
- **Advanced Analytics**: Trend analysis and predictions
- **Custom Themes**: User-customizable visual styles
- **Export Features**: Data export and sharing
- **Mobile Optimization**: Enhanced mobile experience
- **WebGL Optimizations**: Further performance improvements

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.