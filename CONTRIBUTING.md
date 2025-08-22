# Contributing to FrontierMetrix

Thank you for your interest in contributing to FrontierMetrix! This document provides guidelines and best practices for contributors.

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- pnpm 8+
- Git
- Basic knowledge of React, TypeScript, and Next.js

### Development Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/your-username/FrontierMetrixWeb.git
   cd FrontierMetrixWeb
   ```

2. **Install dependencies**
   ```bash
   pnpm install
   ```

3. **Set up environment variables**
   ```bash
   cp apps/web/env.example apps/web/.env.local
   # Edit .env.local with your configuration
   ```

4. **Start development server**
   ```bash
   pnpm dev
   ```

## 📝 Development Guidelines

### Code Style

- **TypeScript**: Use strict mode, prefer interfaces over types
- **React**: Use functional components with hooks, prefer composition over inheritance
- **Naming**: Use descriptive names, follow camelCase for variables and PascalCase for components
- **Comments**: Document complex logic, avoid obvious comments

### File Organization

```
src/
├── components/          # Reusable UI components
│   ├── ui/            # Base UI components (shadcn/ui)
│   ├── cards/         # Card components
│   ├── charts/        # Chart components
│   └── layout/        # Layout components
├── hooks/              # Custom React hooks
├── lib/                # Utilities and configurations
├── server/             # Server actions
└── app/                # Next.js App Router pages
```

### Component Guidelines

- **Props**: Use TypeScript interfaces for prop definitions
- **State**: Prefer local state for UI state, global state for app state
- **Styling**: Use Tailwind CSS classes, avoid inline styles
- **Accessibility**: Include ARIA labels, keyboard navigation support

### Example Component Structure

```tsx
import React from 'react';
import { cn } from '@/lib/utils';

interface ComponentProps {
  title: string;
  className?: string;
  children?: React.ReactNode;
}

export function Component({ title, className, children }: ComponentProps) {
  return (
    <div className={cn("base-classes", className)}>
      <h2 className="text-lg font-semibold">{title}</h2>
      {children}
    </div>
  );
}
```

## 🧪 Testing

### Writing Tests

- **Coverage**: Aim for 80%+ test coverage
- **Naming**: Use descriptive test names that explain the expected behavior
- **Structure**: Follow AAA pattern (Arrange, Act, Assert)
- **Mocking**: Mock external dependencies and APIs

### Test Structure

```tsx
import { render, screen } from '@testing-library/react';
import { Component } from '@/components/Component';

describe('Component', () => {
  it('renders title correctly', () => {
    render(<Component title="Test Title" />);
    expect(screen.getByText('Test Title')).toBeInTheDocument();
  });

  it('applies custom className', () => {
    render(<Component title="Test" className="custom-class" />);
    expect(screen.getByText('Test').parentElement).toHaveClass('custom-class');
  });
});
```

### Running Tests

```bash
# Run all tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Run tests with coverage
pnpm test:coverage

# Run specific test file
pnpm test Component.test.tsx
```

## 🔧 Code Quality

### Pre-commit Checks

Before committing, ensure:

1. **Type checking passes**
   ```bash
   pnpm typecheck
   ```

2. **Linting passes**
   ```bash
   pnpm lint
   ```

3. **Tests pass**
   ```bash
   pnpm test
   ```

4. **Build succeeds**
   ```bash
   pnpm build
   ```

### ESLint Rules

- No unused variables
- No explicit `any` types
- Prefer `const` over `let`
- Use template literals over string concatenation

## 🚀 Feature Development

### Adding New Features

1. **Create a feature branch**
   ```bash
   git checkout -b feature/feature-name
   ```

2. **Implement the feature**
   - Follow the established patterns
   - Add appropriate tests
   - Update documentation

3. **Test thoroughly**
   - Run all tests
   - Test in different browsers
   - Test responsive behavior

4. **Create a pull request**
   - Use descriptive title and description
   - Link related issues
   - Request review from maintainers

### Feature Flags

Use feature flags for new features:

```tsx
import { hasFlag } from '@/lib/flags';

if (hasFlag('newFeature')) {
  // New feature code
}
```

Add flags to `lib/flags.ts` and document in README.

## 🐛 Bug Reports

### Before Reporting

1. Check existing issues
2. Try to reproduce the bug
3. Check browser console for errors
4. Verify environment setup

### Bug Report Template

```markdown
**Bug Description**
Brief description of the issue

**Steps to Reproduce**
1. Go to...
2. Click on...
3. See error...

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- OS: [e.g., macOS 14.0]
- Browser: [e.g., Chrome 120]
- Node.js: [e.g., 18.17.0]

**Additional Context**
Screenshots, logs, etc.
```

## 📚 Documentation

### Code Documentation

- **Functions**: Document complex functions with JSDoc
- **Components**: Include usage examples in component files
- **Types**: Document complex TypeScript types

### Example JSDoc

```tsx
/**
 * Generates market insights based on asset data
 * @param assetIds - Array of asset symbols to analyze
 * @returns Promise resolving to insight data
 */
export async function generateInsight(assetIds: string[]): Promise<Insight> {
  // Implementation
}
```

## 🔄 Pull Request Process

### PR Guidelines

1. **Title**: Use conventional commit format
   - `feat: add new dashboard widget`
   - `fix: resolve asset price display issue`
   - `docs: update API documentation`

2. **Description**: Include
   - What the PR does
   - Why the change is needed
   - How to test the changes
   - Screenshots (if UI changes)

3. **Size**: Keep PRs focused and manageable
   - Prefer multiple small PRs over one large PR
   - Maximum ~500 lines of code per PR

### Review Process

1. **Self-review**: Review your own code before requesting review
2. **Address feedback**: Respond to review comments promptly
3. **Update PR**: Make requested changes and push updates
4. **Merge**: Once approved, maintainers will merge

## 🎯 Contribution Areas

### High Priority

- **Bug fixes**: Critical issues affecting core functionality
- **Performance**: Optimizations for data loading and rendering
- **Accessibility**: Improving keyboard navigation and screen reader support
- **Testing**: Increasing test coverage and quality

### Medium Priority

- **UI/UX improvements**: Better user experience and visual design
- **Documentation**: Improving code and user documentation
- **Code quality**: Refactoring and code organization

### Low Priority

- **New features**: Non-critical functionality additions
- **Styling**: Cosmetic improvements and theme variations

## 📞 Getting Help

### Questions and Discussion

- **GitHub Issues**: Use issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Code Review**: Ask questions in PR reviews

### Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [React Documentation](https://react.dev)
- [TypeScript Handbook](https://www.typescriptlang.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)

## 🙏 Recognition

Contributors will be recognized in:

- GitHub contributors list
- Project documentation
- Release notes
- Community acknowledgments

---

Thank you for contributing to FrontierMetrix! Your work helps make frontier markets more accessible and transparent.
