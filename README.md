# FrontierMetrix Web App

A macro trading intelligence platform focused on frontier and emerging markets, providing real-time insights on currencies, commodities, bonds, and stablecoins.

## 🚀 Quick Start

### Prerequisites

- Node.js 18+ 
- pnpm 8+
- Firebase project (optional, for full functionality)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd FrontierMetrixWeb
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Set up environment variables**
   ```bash
   cp apps/web/env.example apps/web/.env.local
   ```
   
   Edit `.env.local` with your configuration:
   - Firebase credentials (for data persistence)
   - NextAuth configuration
   - Google OAuth (optional)

4. **Start development server**
   ```bash
   pnpm dev
   ```
   
   Open [http://localhost:3000](http://localhost:3000) in your browser.

## 🏗️ Project Structure

```
FrontierMetrixWeb/
├── apps/
│   └── web/                    # Main Next.js application
│       ├── src/
│       │   ├── app/           # App Router pages
│       │   ├── components/    # React components
│       │   ├── hooks/         # Custom React hooks
│       │   ├── lib/           # Utilities and configurations
│       │   └── server/        # Server actions
│       ├── scripts/           # Build and seed scripts
│       └── tests/             # Test files
├── packages/
│   └── config/                # Shared configurations
└── pnpm-workspace.yaml        # Monorepo configuration
```

## 🛠️ Available Scripts

### Development
- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm start` - Start production server

### Quality Assurance
- `pnpm typecheck` - Run TypeScript type checking
- `pnpm lint` - Run ESLint
- `pnpm test` - Run tests
- `pnpm test:coverage` - Run tests with coverage

### Data Management
- `pnpm seed` - Seed Firestore with sample data (requires Firebase config)

## 🔧 Configuration

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `NEXTAUTH_URL` | NextAuth callback URL | Yes |
| `NEXTAUTH_SECRET` | NextAuth secret key | Yes |
| `NEXT_PUBLIC_FIREBASE_*` | Firebase configuration | No* |
| `GOOGLE_CLIENT_ID` | Google OAuth client ID | No |
| `GOOGLE_CLIENT_SECRET` | Google OAuth client secret | No |

*Required for data persistence and real-time features

### Feature Flags

Control feature availability via `NEXT_PUBLIC_FM_FLAGS`:

```bash
# Enable specific features
NEXT_PUBLIC_FM_FLAGS=alerts,news,charts

# Available flags: alerts, news, charts
```

## 🗄️ Firebase Setup

1. **Create a Firebase project** at [console.firebase.google.com](https://console.firebase.google.com)

2. **Enable services:**
   - Firestore Database
   - Authentication (Google + Email)
   - Storage (optional)

3. **Configure security rules:**
   - Copy `firestore.rules` to your Firebase project
   - Deploy rules via Firebase CLI

4. **Set environment variables:**
   ```bash
   NEXT_PUBLIC_FIREBASE_API_KEY=your_api_key
   NEXT_PUBLIC_FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
   NEXT_PUBLIC_FIREBASE_PROJECT_ID=your_project_id
   # ... other Firebase config
   ```

5. **Seed data (optional):**
   ```bash
   pnpm seed
   ```

## 🧪 Testing

The project uses Vitest and React Testing Library:

```bash
# Run all tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run tests with UI
pnpm test:ui

# Generate coverage report
pnpm test:coverage
```

## 📦 Deployment

### Vercel (Recommended)

1. Connect your GitHub repository to Vercel
2. Set environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Manual Deployment

1. Build the application:
   ```bash
   pnpm build
   ```

2. Deploy the `apps/web/.next` folder to your hosting provider

## 🚧 Development Status

- ✅ **MVP Core**: Authentication, Dashboard, Assets, Countries
- ✅ **Data Layer**: Firebase integration, Server Actions
- ✅ **UI Components**: Responsive design, Dark mode
- 🔄 **In Progress**: Advanced alerts, News ingestion
- 📋 **Planned**: AI insights, Email notifications, Premium features

## 🤝 Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development guidelines.

## 📄 License

This project is proprietary software. All rights reserved.

## 🆘 Support

For questions or issues:
1. Check the [documentation](./docs/)
2. Search existing [issues](../../issues)
3. Create a new issue with detailed information

---

**FrontierMetrix** - Intelligence layer for frontier markets
