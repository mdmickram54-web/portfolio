# Technical Notes - eFax Components

## Architecture Overview

### Component Structure

```
SendFax (LWC)
├── Apex Controller (sendFaxLwc)
│   ├── Data Retrieval Layer
│   ├── Business Logic Layer
│   └── eFax Integration Layer
└── UI Layer
    ├── File Selection
    ├── Recipient Selection
    └── Submission Handler
```

## Data Flow

### Sending a Fax

1. **User Interaction:**
   - Select recipient type (Provider/Pharmacy/Other)
   - Select files to send
   - Click Send button

2. **Component Processing:**
   ```javascript
   handleSendClick() {
     // Validate inputs
     // Determine fax number
     // Call Apex method saveFax()
   }
   ```

3. **Apex Processing:**
   ```apex
   saveFax() {
     // Call sendFax() → eFax API
     // Get faxId response
     // Create Sent_Fax__c record
     // Link files to record
     // Return success message
   }
   ```

4. **Post-Send:**
   - Toast notification displayed
   - User navigated back to record
   - Sent_Fax__c record created with status tracking

## Object Type Handling

The component intelligently handles multiple object types:

```apex
Schema.SObjectType objectType = recordId.getSobjectType();

if (objectType == Schema.CareProgramEnrollee.SObjectType) {
    // Direct lookup
}
else if (objectType == Schema.Case.SObjectType) {
    // Navigate through relationship
    Case → Care_Program_Enrollee__c
}
else if (objectType == Schema.CoverageBenefit.SObjectType) {
    // Navigate through relationship
    CoverageBenefit → Care_Program_Enrollee__c
}
// ... and so on
```

## Key Implementation Details

### 1. Enrollee Resolution

The `getEnrolleeId()` method resolves any input record to a Care Program Enrollee:
- Direct if already CareProgramEnrollee
- Via relationship lookup for Case, CoverageBenefit, etc.
- Returns consistent ID for all subsequent queries

### 2. Dynamic Fax Retrieval

```apex
// Provider Fax
PatientMedicationDosage → Prescribing_Physician__r.Fax

// Pharmacy Fax
PatientMedicationDosage → Specialty_Pharmacy__r.Fax

// Care Program Fax
CareProgramEnrollee.CareProgram → Fax__c
```

### 3. File Management

Two types of files supported:

**Related Files:**
- Files attached directly to the parent record
- Via ContentDocumentLink
- Queried from ContentDocument

**Received Fax Files:**
- Files from historical faxes
- Linked to Received_Fax__c records
- Traverses: Received_Fax__c → ContentDocumentLink → ContentDocument

### 4. eFax Integration

Integration with eFax API:

```apex
EFaxCalloutService.sendFax(
    destinations,  // Array of recipients
    documents,     // Base64-encoded file content
    faxOptions     // Resolution, cover page, CSID
)
```

Returns: `faxId` for tracking

## Database Queries

### Query Optimization

**Enrollee Name Query:**
```apex
SELECT id, name FROM CareProgramEnrollee WHERE id = :recordId
Cost: ~1 query
```

**Related Files Query:**
```apex
SELECT ContentDocumentId FROM ContentDocumentLink 
WHERE LinkedEntityId = :recordId
Cost: ~2 queries (link + document)
```

**Received Fax Files Query:**
```apex
SELECT Id FROM Received_Fax__c 
WHERE Care_Program_Enrollee__c = :recordId
// For each Received_Fax__c:
SELECT ContentDocumentId FROM ContentDocumentLink
WHERE LinkedEntityId = :receivedFaxId
Cost: ~N+1 queries (N = received faxes)
```

### Caching Strategy

Cacheable Apex methods improve performance:
- `getEnrolleeName()` - Cached by recordId
- `getFaxNum()` - Cached by recordId
- `getPharFax()` - Cached by recordId
- `getCpFaxNum()` - Cached by recordId
- `getRelatedFiles()` - Cached by recordId
- `getRecFaxFiles()` - Cached by recordId

Cache invalidation occurs on:
- Manual page refresh
- Record update
- Cache timeout (default 15 minutes)

## Error Handling

### Apex Error Handling

```apex
try {
    // SOQL query
    // File processing
    // eFax API call
} catch (Exception e) {
    throw new AuraHandledException(e.getMessage());
}
```

### JavaScript Error Handling

```javascript
.then((result) => {
    if (result.startsWith('Error')) {
        // Handle error
        console.error(result);
    } else {
        // Success
    }
})
.catch((error) => {
    console.error('Error:', error);
});
```

### User Feedback

```javascript
showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,  // 'success', 'error', 'warning', 'info'
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
}
```

## Security Considerations

### 1. Sharing Model

```apex
public with sharing class sendFaxLwc
```
- Enforces org-wide defaults
- Respects sharing rules
- Users only access records they can view

### 2. Field-Level Security

Aura-enabled methods inherit FLS:
- Only visible fields returned
- CRUD checks enforced
- No bypass of security

### 3. Input Validation

- Fax number format validation
- File type restrictions (PDF)
- File size limits
- Maximum file count (typically 9)

## Performance Metrics

### Expected Load Times

| Operation | Time | Notes |
|-----------|------|-------|
| Component Load | <100ms | With caching |
| Fax Number Retrieval | 200-300ms | First call, cached after |
| File List Load | 300-500ms | Depends on file count |
| Send Fax | 1-2s | API call + record creation |

### Governor Limits

- **SOQL Queries:** ~10 per transaction (well under 100 limit)
- **Apex CPU Time:** <500ms per transaction
- **API Calls:** 1 per fax send
- **DML Operations:** 2-3 per fax send

## Future Enhancement Opportunities

1. **Fax Templates:** Pre-built cover pages
2. **Batch Sending:** Process multiple faxes
3. **Scheduled Sends:** Send at specific times
4. **Delivery Tracking:** Real-time status updates
5. **Retry Logic:** Automatic retry on failure
6. **Audit Trail:** Complete fax history
7. **Multi-language:** Localization support
8. **Advanced Logging:** Enhanced debug output

## Common Gotchas

### 1. Relationship Names

**Issue:** Code assumes specific relationship names
**Solution:** Verify field names match your org

```apex
// Update this if different
Case.Care_Program_Enrollee__c
```

### 2. File Type Filtering

**Issue:** Non-PDF files might be displayed
**Solution:** Check file type in queries if needed

```apex
WHERE ContentDocument.FileType = 'PDF'
```

### 3. Fax Number Format

**Issue:** API rejects invalid formats
**Solution:** Validate before sending

```apex
private Boolean isValidPhoneNumber(String num) {
    num = num.replaceAll('\\D','');
    return num.length() >= 10;
}
```

### 4. API Rate Limiting

**Issue:** eFax API might throttle requests
**Solution:** Implement retry logic with exponential backoff

## Deployment Checklist

- [ ] Apex classes deployed and tested
- [ ] LWC component deployed
- [ ] Custom fields created
- [ ] Object relationships configured
- [ ] Field-level security configured
- [ ] Remote site settings configured
- [ ] eFax credentials configured
- [ ] Component added to record pages
- [ ] User testing completed
- [ ] Documentation reviewed
- [ ] Monitoring/logging configured

---

**Version:** 1.0
**Last Updated:** September 2023
