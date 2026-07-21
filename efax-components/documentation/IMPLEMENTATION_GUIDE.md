# eFax Components - Implementation Guide

## Overview

This guide provides step-by-step instructions for implementing the eFax Lightning Web Component system in your Salesforce organization.

## Prerequisites

Before starting implementation, ensure you have:

1. **Salesforce Admin or Developer Access**
   - Ability to deploy code
   - Permission to create custom fields and objects
   - Access to Change Sets or Salesforce CLI

2. **Required Custom Objects**
   - `CareProgramEnrollee` (or equivalent)
   - `Received_Fax__c`
   - `Sent_Fax__c`
   - `PatientMedicationDosage`
   - `Appeal__c`
   - `J_Copay__c`
   - `J_Charitable__c`

3. **Custom Fields**
   - `Sent_Fax__c` fields:
     - `Fax_Number__c` (Text)
     - `Fax_Id__c` (Text)
     - `Send_Date_Time__c` (DateTime)
     - `Delivery_Date_Time__c` (DateTime)
     - `Organisation_Fax_number__c` (Text)
     - `To__c` (Text)
     - `Care_Program_Enrollee__c` (Lookup to CareProgramEnrollee)
     - `AE_PQC__c` (Lookup to Case)
     - `Coverage_Benefit__c` (Lookup to CoverageBenefit)
     - `Prior_Authorization__c` (Lookup to CarePreauth)
     - `Appeal__c` (Lookup to Appeal__c)
     - `Copay__c` (Lookup to J_Copay__c)
     - `PAP_TPAP__c` (Lookup to J_Charitable__c)

   - `Received_Fax__c` fields:
     - `Care_Program_Enrollee__c` (Lookup)
     - `AE_PQC__c` (Lookup to Case)
     - `Coverage_Benefit__c` (Lookup)
     - `Prior_Authorization__c` (Lookup)
     - `Appeal__c` (Lookup)
     - `Copay__c` (Lookup)
     - `PAP_TPAP__c` (Lookup)

   - `CareProgramEnrollee` fields:
     - `CareProgram.Fax__c` (Fax number of Care Program)

4. **eFax Service Integration**
   - `EFaxCalloutService` class already implemented
   - API credentials configured
   - Remote site settings configured

## Installation Steps

### Step 1: Deploy Apex Classes

#### Option A: Using Salesforce CLI

```bash
# Clone the repository
git clone <your-repo-url>
cd efax-components

# Authenticate to your org
sf org login web -a MyOrg

# Deploy code
sf project deploy start -o MyOrg
```

#### Option B: Manual Deployment

1. Open Salesforce Developer Console
2. Go to **File → New → Apex Class**
3. Copy contents of `sendFaxLwc.cls`
4. Save and ensure no compilation errors
5. Repeat for `SendFaxCtrl.cls` if using legacy Visualforce pages

### Step 2: Deploy Lightning Web Component

1. In your IDE (VS Code with Salesforce Extension):
   ```bash
   # Create LWC
   sf lightning generate component -n sendFax -d force-app/main/default/lwc
   ```

2. Copy the following files:
   - `sendFax.js` → component JavaScript
   - `sendFax.html` → component template
   - `sendFax.js-meta.xml` → component metadata

3. Deploy:
   ```bash
   sf project deploy start
   ```

### Step 3: Configure Object Relationships

1. Navigate to **Setup → Custom Objects & Fields**
2. For each custom object (Case, CoverageBenefit, etc.):
   - Ensure lookup fields to `CareProgramEnrollee` exist
   - Verify field names match those in Apex code

3. For `Received_Fax__c`:
   - Create lookup relationships to all related objects
   - Enable file attachments via ContentDocumentLink

### Step 4: Add Component to Record Pages

1. Navigate to a record page (e.g., Care Program Enrollee)
2. Click **Edit Page** (using Lightning App Builder)
3. Search for "sendFax" component
4. Drag to desired location on page
5. Configure properties if needed
6. Click **Save**
7. Activate the page

### Step 5: Test the Integration

1. **Basic Tests:**
   - Open a Care Program Enrollee record
   - Verify component displays
   - Check enrollee name appears correctly

2. **Fax Number Tests:**
   - Select "Provider" recipient
   - Verify provider fax number populates
   - Select "Pharmacy" recipient
   - Verify pharmacy fax number populates

3. **File Selection Tests:**
   - Check that files appear in both tabs
   - Select multiple files
   - Verify selection persists

4. **Send Tests:**
   - Select recipient and files
   - Click Send
   - Verify success message
   - Check `Sent_Fax__c` record created
   - Verify files linked to sent fax

## Configuration

### Update Field References

Before deployment, review and update the following in `sendFaxLwc.cls`:

```apex
// Update object references if different names used
else if (objectType == Schema.Case.SObjectType) {
    Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case ...];
    // Update field name if different
}
```

### Update eFax Settings

In `sendFaxLwc.cls`, update eFax configuration:

```apex
faxOptions.image_resolution = 'FINE'; // or 'STANDARD'
faxOptions.include_cover_page = false; // Set to true if needed
faxOptions.custom_CSID = '13456781278'; // Update with your CSID
```

### Security Configuration

1. **Field-Level Security:**
   - Grant read access to fax-related fields
   - Ensure users can access Sent_Fax__c

2. **Object Permissions:**
   - Allow Create/Read on Sent_Fax__c
   - Allow Read on all query objects

3. **Remote Site Settings:**
   ```
   Setup → Remote Site Settings
   Add: <Your eFax API endpoint>
   ```

## Troubleshooting

### Issue: Fax Numbers Not Populating

**Symptoms:** Fax input box empty after selecting recipient

**Solutions:**
1. Check Apex debug logs for query errors
2. Verify `PatientMedicationDosage` lookup field name
3. Confirm field relationships exist and are populated
4. Check user permissions on related objects

### Issue: Files Not Appearing

**Symptoms:** No files shown in either tab

**Solutions:**
1. Verify files are attached to correct parent records
2. Check ContentDocumentLink relationships
3. Ensure files are PDF format (if filtering applied)
4. Check user has read access to files

### Issue: Send Failures

**Symptoms:** Error message after clicking Send

**Solutions:**
1. Review browser console for errors
2. Check Apex debug logs for exceptions
3. Verify fax number format (10-11 digits, numbers only)
4. Confirm eFax API credentials are valid
5. Check organization has available API calls

### Issue: Component Not Appearing on Page

**Symptoms:** LWC not visible after adding to page

**Solutions:**
1. Verify component deployed successfully
2. Check that page targets match component targets:
   - `lightning__RecordPage`
   - `lightning__RecordAction`
3. Ensure user has permission to view component
4. Try refreshing browser cache
5. Verify component metadata has correct API version

## Performance Optimization

### Caching

The component uses `@AuraEnabled(cacheable = true)` for:
- Enrollee data
- Fax numbers
- File lists

Cached data remains valid until explicitly invalidated.

### Query Optimization

1. **Related Files Query:**
   ```apex
   // Uses indexed field for faster retrieval
   WHERE LinkedEntityId = :recordId
   ```

2. **Fax Number Query:**
   ```apex
   // Minimal fields selected
   SELECT id, name, CareProgram.Fax__c FROM CareProgramEnrollee
   ```

### Best Practices

1. **Limit File Selections:** Consider limiting to 9 files per send (eFax standard)
2. **File Size:** Typically limit total size to 20MB
3. **Batch Operations:** For high-volume faxing, implement batch apex

## Monitoring & Logging

### Enable Debug Logs

1. **Setup → Debug Logs**
2. Add your user
3. Set level to DEBUG
4. Check logs after sending faxes

### Monitor Sent Faxes

1. Create report on `Sent_Fax__c` object
2. Filter by date range
3. Monitor delivery status
4. Track recipients and file counts

## Maintenance

### Regular Updates

1. **Review eFax API Changes:** Check for updates to EFaxCalloutService
2. **Update Field References:** If object structure changes
3. **Monitor Error Logs:** Review apex logs weekly

### Backup Strategy

1. Regularly export sent fax records
2. Archive old fax data per compliance requirements
3. Maintain version history in source control

## Support & Documentation

### Additional Resources

- [Salesforce LWC Documentation](https://developer.salesforce.com/docs/component-library/documentation/en/lwc)
- [eFax API Documentation](https://www.efax.com/api-docs)
- [Salesforce Apex Documentation](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta)

### Getting Help

1. Check debug logs for specific error messages
2. Review Salesforce release notes for API changes
3. Contact eFax support for integration issues
4. Reach out to Salesforce developer community

---

**Last Updated:** September 2023
**Author:** Mickram
