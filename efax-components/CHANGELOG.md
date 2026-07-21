# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2023-09-21

### Initial Release

#### Added
- **eFax Lightning Web Component (sendFax)**
  - Support for multiple recipient types (Provider, Pharmacy, Other)
  - Dynamic fax number retrieval
  - File selection interface
  - Integration with eFax API for fax transmission
  - Toast notifications for user feedback

- **Apex Controller (sendFaxLwc.cls)**
  - Enrollee ID resolution from multiple object types
  - Fax number retrieval (Provider, Pharmacy, Care Program)
  - Related file queries
  - Received fax file queries
  - Fax sending and tracking
  - Sent fax record creation and management

- **Supported Objects**
  - CareProgramEnrollee
  - Case
  - CoverageBenefit
  - CarePreauth
  - Appeal__c
  - J_Copay__c
  - J_Charitable__c

#### Features
- Real-time fax number population based on recipient type
- Multiple file selection support
- File validation
- Navigation to record detail page after successful send
- Success and error notifications
- Caching for improved performance
- Support for both related files and received fax files
- Care program fax number display

#### Security
- Implemented "with sharing" for data access control
- Field-level security enforcement
- Input validation and sanitization

#### Documentation
- Comprehensive README.md
- Implementation guide with setup instructions
- Technical notes for developers
- Troubleshooting guide

---

## Future Releases

### [1.1.0] - Planned
- Fax delivery tracking
- Template cover pages
- Batch fax sending
- Enhanced logging and monitoring

### [1.2.0] - Planned
- Scheduled fax sending
- Retry logic for failed sends
- Multi-language support
- Advanced analytics and reporting

---

**Note:** Version numbers follow [Semantic Versioning](https://semver.org/)
