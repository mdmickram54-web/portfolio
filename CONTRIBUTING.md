# Contributing to eFax Components

Thank you for your interest in the eFax Components project! This document provides guidelines and instructions for contributing.

## 📋 Code of Conduct

- Be respectful and professional
- Provide constructive feedback
- Help create a welcoming community
- Report issues responsibly

## 🤝 How to Contribute

### 1. Reporting Issues

If you find a bug or have a suggestion:

1. **Check existing issues** to avoid duplicates
2. **Create a new issue** with:
   - Clear title describing the problem
   - Detailed description of the issue
   - Steps to reproduce (for bugs)
   - Expected vs actual behavior
   - Your environment (Salesforce version, browser, etc.)

**Example Issue Title:**
```
[BUG] Fax numbers not populating when selecting Provider recipient
```

### 2. Requesting Features

Have a great idea? Submit a feature request:

1. **Use the issue template** and label as `enhancement`
2. **Describe the feature** clearly
3. **Explain the use case** and benefits
4. **Provide examples** if applicable

**Example Feature Request:**
```
[FEATURE] Add fax delivery status tracking in real-time
```

### 3. Code Contributions

Before submitting code changes:

#### Prerequisites
- Familiarity with Salesforce development
- Understanding of Lightning Web Components
- Knowledge of Apex programming
- Git version control experience

#### Process

1. **Fork the repository**
   ```bash
   git clone https://github.com/YOUR-USERNAME/portfolio.git
   cd portfolio
   ```

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   # or for bug fixes
   git checkout -b bugfix/issue-description
   ```

3. **Make your changes**
   - Follow code standards (see below)
   - Write clear, descriptive commit messages
   - Add comments for complex logic
   - Keep commits atomic and focused

4. **Test thoroughly**
   - Test in a Salesforce sandbox
   - Verify no breaking changes
   - Test with multiple object types
   - Check error scenarios

5. **Submit a Pull Request**
   - Compare against the `main` branch
   - Fill out the PR template completely
   - Reference related issues
   - Describe your changes clearly
   - List any breaking changes

## 📝 Code Standards

### Apex Code Style

```apex
/**
 * @description       : Brief description of class
 * @author            : Your Name
 * @group             : Component/Feature Name
 * @last modified on  : MM-DD-YYYY
 */
public with sharing class YourClassName {

    @AuraEnabled(cacheable = true)
    public static String methodName(Id recordId) {
        try {
            // Implementation
            return result;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
```

**Rules:**
- Use `with sharing` for security
- Add JSDoc comments for all public methods
- Use meaningful variable names
- Limit methods to single responsibility
- Use `AuraHandledException` for LWC errors
- Implement proper error handling
- Optimize SOQL queries

### Lightning Web Component Style

```javascript
import { LightningElement, wire, api, track } from "lwc";
import someMethod from '@salesforce/apex/ClassName.methodName';

/**
 * LWC component description
 * @author Your Name
 */
export default class ComponentName extends LightningElement {

    @api recordId;
    @track data = [];
    
    @wire(someMethod, { recordId: '$recordId' })
    wiredMethod({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            console.error('Error:', error);
        }
    }

    handleClick() {
        // Implementation
    }
}
```

**Rules:**
- Use descriptive component and method names
- Add JSDoc comments
- Use `@track` for reactive properties
- Use `@wire` for Apex method calls
- Implement error handling
- Use SLDS classes for styling
- Keep components focused and reusable

### HTML Templates

```html
<template>
    <!-- Use meaningful comments -->
    <lightning-card title="Component Title" icon-name="custom:icon">
        <!-- Use SLDS spacing utilities -->
        <div class="slds-p-around_medium">
            <!-- Descriptive labels -->
            <lightning-input 
                label="Field Label"
                value={fieldValue}
                onchange={handleChange}
            ></lightning-input>
        </div>
    </lightning-card>
</template>
```

**Rules:**
- Use SLDS components and utilities
- Add aria labels for accessibility
- Use meaningful variable names
- Properly structure HTML
- Use conditional rendering efficiently

## 🧪 Testing Requirements

Before submitting PR, ensure:

- ✅ Code compiles without errors
- ✅ Tested in Salesforce sandbox
- ✅ No console errors in browser
- ✅ Works with multiple object types
- ✅ Error scenarios handled
- ✅ Performance is acceptable
- ✅ Security considerations reviewed

## 📚 Documentation

When contributing, update documentation:

- **README.md** - If adding features
- **TECHNICAL_NOTES.md** - If changing architecture
- **Code comments** - For complex logic
- **Commit messages** - Clear and descriptive

### Commit Message Format

```
[TYPE] Brief description under 50 characters

Detailed explanation of changes if needed.
Keep lines under 72 characters.

Fixes #123 (if applicable)
```

**Types:**
- `[FEATURE]` - New functionality
- `[BUGFIX]` - Bug fixes
- `[DOCS]` - Documentation updates
- `[REFACTOR]` - Code reorganization
- `[PERF]` - Performance improvements
- `[TEST]` - Testing additions

## ✅ Pull Request Checklist

Before submitting, verify:

- [ ] Fork updated with latest main branch
- [ ] Feature branch created
- [ ] Code follows style guidelines
- [ ] Comments added for complex logic
- [ ] No console errors or warnings
- [ ] Tested in sandbox
- [ ] Tests pass
- [ ] Documentation updated
- [ ] Commits are atomic and meaningful
- [ ] PR description is clear and complete
- [ ] Related issues referenced
- [ ] No sensitive data in code

## 🔍 Review Process

1. **Automated checks**
   - Code compiles successfully
   - No obvious security issues
   - Style guidelines verified

2. **Code review**
   - Functionality verified
   - Code quality assessed
   - Best practices checked
   - Security reviewed

3. **Approval and merge**
   - Minimum 1 approval required
   - All conversations resolved
   - Commits squashed if needed
   - Merged to main branch

## 📖 Resources

- [Salesforce Developer Docs](https://developer.salesforce.com/docs)
- [Lightning Web Components Guide](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [Apex Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta)
- [eFax API Documentation](https://www.efax.com/api-docs)

## ❓ Questions?

- Check existing documentation
- Review similar code in the project
- Open a discussion issue
- Contact: mdmickram54@gmail.com

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License. See [LICENSE](./LICENSE) file for details.

## 🙏 Thank You

Thank you for contributing to make eFax Components better! Your efforts help improve the project and the community.

---

**Last Updated:** September 2023  
**Maintained By:** Mohamed Mickram
