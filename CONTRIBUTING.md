# Contributing to Web Builder

Thank you for your interest in contributing to Web Builder! This document provides guidelines and instructions for contributing.

## 🎯 Ways to Contribute

- 🐛 Report bugs
- 💡 Suggest new features
- 📝 Improve documentation
- 🔧 Submit pull requests
- ⭐ Star the repository

## 🐛 Reporting Bugs

Before creating a bug report:

1. Check if the bug has already been reported
2. Ensure you're using the latest version
3. Collect relevant information:
   - Flutter version
   - Browser and version
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable

## 💡 Feature Requests

We welcome feature suggestions! Please:

1. Check if the feature has been requested
2. Describe the problem it solves
3. Provide use cases
4. Suggest potential implementation approaches

## 🔧 Development Setup

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/web-builder.git
   ```

3. Create a feature branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. Make your changes

5. Test thoroughly:
   ```bash
   flutter test
   flutter run -d chrome
   ```

6. Commit with clear messages:
   ```bash
   git commit -m "feat: add new component type"
   ```

7. Push and create a pull request

## 📝 Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable names
- Add comments for complex logic
- Write tests for new features

## 🧪 Testing

- Write unit tests for models and services
- Write widget tests for UI components
- Ensure all tests pass before submitting PR

## 📦 Commit Message Format

We follow [Conventional Commits](https://www.conventionalcommits.org/):

```
type(scope): subject

body (optional)

footer (optional)
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

Examples:
```
feat(canvas): add grid snap functionality
fix(ai-chat): resolve message ordering issue
docs(readme): update setup instructions
```

## 🎨 UI/UX Guidelines

- Follow Material Design 3 principles
- Ensure responsive design
- Maintain accessibility standards
- Test on multiple browsers

## ✅ Pull Request Checklist

Before submitting:

- [ ] Code follows project style guidelines
- [ ] All tests pass
- [ ] New tests added for new features
- [ ] Documentation updated if needed
- [ ] Commit messages follow convention
- [ ] No merge conflicts
- [ ] Screenshots added for UI changes

## 🤝 Code Review Process

1. Submit PR with clear description
2. Address reviewer feedback
3. Update PR as needed
4. Wait for approval
5. PR will be merged by maintainer

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Thank You!

Every contribution helps make Web Builder better. We appreciate your effort!
