# eFax Components - Salesforce Lightning Web Components

## Overview

This project contains a comprehensive Salesforce eFax system built with Lightning Web Components (LWC) that enables users to send faxes to providers and pharmacies directly from various Salesforce objects.

## Features

✨ **Key Features:**
- Send faxes to providers and pharmacies
- Support for multiple Salesforce object types (Care Program Enrollee, Case, Coverage Benefit, Care Preauth, Appeal, Copay, Charitable)
- Dynamic fax number retrieval based on recipient type
- File selection and management (Related Files and Received Fax Files)
- File upload validation
- Success notifications and error handling
- Integration with eFax APIs for fax transmission

## Project Structure

```
efax-components/
├── apex/
│   ├── sendFaxLwc.cls              # Main Apex controller for LWC
│   └── SendFaxCtrl.cls             # Legacy Visualforce controller
├── lwc/
│   └── sendFax/
│       ���── sendFax.js              # Main LWC component logic
│       ├── sendFax.html            # Component template
│       └── sendFax.js-meta.xml     # Component metadata
├── flows/
│   ├── Check_Duplicate_Fax_Number_on_Care_Program.flow
│   └── Notify_Team_Member_from_Care_Program.flow
└── documentation/
    └── IMPLEMENTATION_GUIDE.md
```

## Components

### Apex Classes

#### `sendFaxLwc.cls`
Main Apex controller handling:
- Enrollee ID retrieval from various object types
- Enrollee name fetching
- Fax number retrieval (Provider, Pharmacy, Care Program)
- Related file queries
- Received fax file queries
- Fax sending and tracking

**Key Methods:**
- `getEnrolleeId(Id recordId)` - Resolves record ID to Care Program Enrollee
- `getEnrolleeName(Id recordId)` - Retrieves enrollee name
- `getFaxNum(Id recordId)` - Gets provider fax number
- `getPharFax(Id recordId)` - Gets pharmacy fax number
- `getCpFaxNum(Id recordId)` - Gets care program fax number
- `getRelatedFiles(Id recordId)` - Retrieves related documents
- `getRecFaxFiles(Id recordId)` - Retrieves received fax documents
- `saveFax()` - Saves sent fax record and links documents

#### `SendFaxCtrl.cls`
Legacy Visualforce controller (reference)

### Lightning Web Component

#### `sendFax`
Interactive component for fax sending with:
- Recipient selection (Provider, Pharmacy, Other)
- Dynamic fax number display and input
- File selection from related records
- File selection from received faxes
- Send functionality
- Success notifications

**Key Features:**
- Real-time fax number population based on recipient type
- Multiple file selection support
- File validation
- Navigation to record detail page after successful send
- Toast notifications for user feedback

### Flows

1. **Check_Duplicate_Fax_Number_on_Care_Program** - Validates duplicate fax numbers
2. **Notify_Team_Member_from_Care_Program** - Sends team notifications

## Setup Instructions

### Prerequisites
- Salesforce Org with Lightning Experience enabled
- eFax Integration configured
- Custom objects: `Received_Fax__c`, `Sent_Fax__c`, `CareProgramEnrollee`

### Installation

1. **Deploy Apex Classes:**
   - Copy `sendFaxLwc.cls` to your org
   - Update custom field references as needed

2. **Deploy LWC Component:**
   - Create new LWC named `sendFax`
   - Deploy HTML, JS, and metadata files

3. **Configure Custom Objects:**
   - Ensure required custom fields exist on Sent_Fax__c
   - Configure relationships to relevant objects

4. **Add to Record Pages:**
   - Edit relevant record pages
   - Add sendFax component
   - Configure visibility as needed

## Usage

1. Navigate to a supported record (Case, Care Program Enrollee, etc.)
2. Access the Send Fax component
3. Select recipient type (Provider/Pharmacy/Other)
4. Fax number auto-populates based on selection
5. Select files from Related Files or Received Fax Files
6. Click "Send"
7. Component navigates back to record on success

## Supported Objects

- Care Program Enrollee
- Case
- Coverage Benefit
- Care Preauth
- Appeal
- J_Copay__c
- J_Charitable__c

## Error Handling

- Validates fax number format
- Checks for selected files
- Validates recipient selection
- Provides user-friendly error messages via toast notifications

## API Integration

The component integrates with `EFaxCalloutService` for:
- Sending faxes via eFax API
- Setting fax options (resolution, cover page, CSID)
- Handling document encoding

## Security Considerations

- Uses `with sharing` keyword for data access control
- Validates user permissions through Salesforce security
- Implements proper error handling without exposing sensitive data

## Future Enhancements

- [ ] Fax delivery tracking
- [ ] Template cover pages
- [ ] Batch fax sending
- [ ] Fax history and archival
- [ ] Advanced scheduling
- [ ] Multi-language support

## Troubleshooting

### Fax numbers not populating
- Verify Apex method permissions
- Check related record relationships
- Validate field references

### Files not appearing
- Confirm file permissions
- Check ContentDocumentLink relationships
- Verify PDF file type filtering

### Send failures
- Review eFax service credentials
- Check API request format
- Verify fax number format (10-11 digits)

## Performance Notes

- Uses cacheable Apex methods for improved performance
- Implements lazy loading for file lists
- Optimized SOQL queries with targeted field selection

## Author

**Mickram**  
Salesforce Developer

## License

Private - Portfolio Project

---

**Last Updated:** September 2023