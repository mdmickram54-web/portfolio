# Healthcare Objects & Data Model

## 📊 Complete Salesforce Objects Used in eFax Components System

This document outlines all Salesforce objects integrated in the eFax Components system, demonstrating a complete healthcare patient support program lifecycle from enrollment to maintenance.

---

## 🏥 Healthcare Process Flow

```
PATIENT ENROLLMENT → CARE MANAGEMENT → SUPPORT PROGRAMS → MAINTENANCE & FOLLOW-UP
```

### Phase 1: Patient Enrollment
**Objects:** CareProgramEnrollee, CareProgram

### Phase 2: Care & Authorization Management
**Objects:** CarePreauth, CoverageBenefit, PatientMedicationDosage

### Phase 3: Support Programs
**Objects:** J_Copay__c, J_Charitable__c (Patient Assistance Programs)

### Phase 4: Case Management & Appeals
**Objects:** Case, Appeal__c

### Phase 5: Fax Management & Communication
**Objects:** Sent_Fax__c, Received_Fax__c, ContentDocument, ContentDocumentLink

---

## 📋 Detailed Object Specifications

### 1. **CareProgramEnrollee** ⭐ (Core Object)
**Purpose:** Represents the patient enrolled in care programs

**Key Fields:**
- `Id` - Primary key
- `Name` - Patient name
- `CareProgram` - Reference to care program
- `CareProgram.Fax__c` - Care program fax number
- Additional enrollment details

**Role in System:**
- Central hub for all patient data
- Links to all related care management records
- Used in: getEnrolleeId(), getEnrolleeName()
- **Process Stage:** Enrollment

**Healthcare Context:**
- Represents patient actively enrolled in managed care
- Tracks multiple concurrent programs
- Maintains compliance and eligibility

---

### 2. **CareProgram**
**Purpose:** Defines the care program structure and settings

**Key Fields:**
- `Id` - Program identifier
- `Fax__c` - Program's fax number for outbound communication
- Program details, guidelines, contact info

**Role in System:**
- Provides program-level fax numbers
- Used in: getCpFaxNum()
- Stores program contact information

**Healthcare Context:**
- Represents insurance plans, managed care organizations
- Program-level settings for care delivery
- Compliance and billing information

---

### 3. **Case** 📞
**Purpose:** Tracks patient inquiries, issues, and support requests

**Key Fields:**
- `Id` - Case identifier
- `Care_Program_Enrollee__c` - Reference to patient
- `AE_PQC__c` - Used in Received_Fax__c queries
- `ContactId` - Associated contact
- `Status` - Open, Closed, Escalated
- Case details, priority, resolution

**Role in System:**
- Represents patient support tickets and inquiries
- Links to CareProgramEnrollee for resolution
- Stores received faxes related to cases
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Patient service requests
- Prescription issues
- Coverage inquiries
- Prior authorization follow-ups
- **Process Stage:** Case Management

---

### 4. **CoverageBenefit** 💊
**Purpose:** Defines insurance coverage and benefits for patients

**Key Fields:**
- `Id` - Benefit identifier
- `Care_Program_Enrollee__c` - Reference to patient
- `BenefitName` - Type of benefit
- `EffectiveDate`, `ExpirationDate` - Coverage period
- Coverage details, copay amounts, formulary

**Role in System:**
- Tracks patient's active benefits
- Links to CareProgramEnrollee
- Used for benefit inquiries
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Insurance coverage details
- Drug formulary benefits
- Copay/coinsurance amounts
- Prior authorization requirements
- **Process Stage:** Care Management

---

### 5. **PatientMedicationDosage** 💉
**Purpose:** Tracks medication prescriptions and dosing information

**Key Fields:**
- `Id` - Medication record identifier
- `Care_Program_Enrollee_Name__c` - Reference to patient
- `Prescribing_Physician__c` - Doctor prescribing medication
- `Prescribing_Physician__r.Fax` - **Provider fax number** ⭐
- `Specialty_Pharmacy__c` - Pharmacy dispensing medication
- `Specialty_Pharmacy__r.Fax` - **Pharmacy fax number** ⭐
- `Medication`, `Dosage`, `Frequency` - Prescription details
- `StartDate`, `EndDate` - Prescription period

**Role in System:**
- Primary source for provider and pharmacy fax numbers
- Links prescribing physician and specialty pharmacy
- Used in: getFaxNum(), getPharFax()
- **Critical for fax routing**

**Healthcare Context:**
- Prescription management
- Medication adherence tracking
- Pharmacy coordination
- Prior authorization for specialty drugs
- **Process Stage:** Care Management & Maintenance

---

### 6. **CarePreauth** (Prior Authorization) ✅
**Purpose:** Manages prior authorization requests for medical treatments

**Key Fields:**
- `Id` - Authorization identifier
- `Care_Program_Enrollee__c` - Reference to patient
- `AuthorizationStatus` - Approved, Denied, Pending
- `ServiceType` - Type of service authorized
- `AuthorizationNumber` - Unique auth number
- `EffectiveDate`, `ExpirationDate` - Authorization validity

**Role in System:**
- Tracks authorization status for treatments
- Links to CareProgramEnrollee
- Used for communication about approval/denial
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Prior authorization management
- Treatment approval tracking
- Appeal documentation
- **Process Stage:** Care Management

---

### 7. **Appeal__c** 🔄
**Purpose:** Manages patient appeals for denied claims or coverage

**Key Fields:**
- `Id` - Appeal identifier
- `Authorization__c` - Reference to related authorization
- `Authorization__r.Care_Program_Enrollee__c` - Patient reference
- `AppealStatus` - Pending, Approved, Denied
- `AppealReason` - Reason for appeal
- `DecisionDate` - When decision was made
- Appeal details, supporting documents

**Role in System:**
- Tracks appeal processes
- Links through Authorization to CareProgramEnrollee
- Used for appeal documentation and communication
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Coverage appeals
- Service denial appeals
- Claims disputes
- **Process Stage:** Appeals & Dispute Resolution

---

### 8. **J_Copay__c** 💰
**Purpose:** Copayment assistance program tracking

**Key Fields:**
- `Id` - Copay program record identifier
- `Care_Program_Enrollee__c` - Reference to patient
- `CopayAmount` - Amount of copay assistance
- `ApprovalStatus` - Approved, Pending, Denied
- `EffectiveDate`, `ExpirationDate` - Program period
- Eligibility information

**Role in System:**
- Tracks copay assistance programs
- Links to CareProgramEnrollee
- Used for patient support program communications
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Patient assistance programs (PAP)
- Copay support for patients with financial hardship
- Medication affordability programs
- **Process Stage:** Patient Support Programs

---

### 9. **J_Charitable__c** (PAP/TPAP) 🤝
**Purpose:** Charitable assistance and patient assistance programs

**Key Fields:**
- `Id` - Program record identifier
- `Care_Program_Enrollee__c` - Reference to patient
- `PAP_TPAP__c` - Program type designation
- `ApprovalStatus` - Approved, Pending, Denied
- `BenefitAmount` - Amount of assistance provided
- `EffectiveDate`, `ExpirationDate` - Program validity
- Program eligibility and requirements

**Role in System:**
- Tracks charitable assistance programs
- Links to CareProgramEnrollee
- Used for patient support program communications
- Used in: getEnrolleeId(), getRecFaxFiles()

**Healthcare Context:**
- Third-party assistance programs (TPAP)
- Manufacturer copay cards
- Foundation-based assistance
- **Process Stage:** Patient Support Programs

---

### 10. **Received_Fax__c** 📥
**Purpose:** Tracks incoming faxes related to patient care

**Key Fields:**
- `Id` - Fax record identifier
- `Care_Program_Enrollee__c` - Associated patient
- `AE_PQC__c` - Case reference
- `Coverage_Benefit__c` - Benefit reference
- `Prior_Authorization__c` - Authorization reference
- `Appeal__c` - Appeal reference
- `Copay__c` - Copay program reference
- `PAP_TPAP__c` - Charitable program reference
- `Fax_Description__c` - Fax content description
- `ReceivedDate` - When fax received
- File attachments via ContentDocumentLink

**Role in System:**
- Central repository for incoming faxes
- Links to multiple objects for context
- Files queried using: getRecFaxFiles()
- Primary source for "Received Fax Files" tab in LWC

**Healthcare Context:**
- Prior authorization approvals/denials
- Coverage inquiries responses
- Appeal documentation
- Pharmacy coordination faxes
- **Process Stage:** All stages - ongoing communication

---

### 11. **Sent_Fax__c** 📤
**Purpose:** Tracks outgoing faxes sent from the system

**Key Fields:**
- `Id` - Sent fax record identifier
- `Fax_Number__c` - Recipient fax number
- `Fax_Id__c` - eFax API identifier
- `Send_Date_Time__c` - When fax was sent
- `Delivery_Date_Time__c` - When fax was delivered
- `Organisation_Fax_number__c` - Sender's fax number
- `To__c` - Recipient type (Provider/Pharmacy/Other)
- `Care_Program_Enrollee__c` - Patient reference
- `AE_PQC__c` - Case reference
- `Coverage_Benefit__c` - Benefit reference
- `Prior_Authorization__c` - Authorization reference
- `Appeal__c` - Appeal reference
- `Copay__c` - Copay program reference
- `PAP_TPAP__c` - Charitable program reference
- Linked files via ContentDocumentLink

**Role in System:**
- Audit trail of all outbound faxes
- Created by: saveFax()
- Links to all related healthcare objects
- Tracks delivery status

**Healthcare Context:**
- Documentation sent to providers
- Prior authorization requests
- Appeal documentation
- Pharmacy coordination
- **Process Stage:** All stages - outbound communication

---

### 12. **ContentDocument & ContentDocumentLink** 📎
**Purpose:** File management and document linking

**Key Fields:**

**ContentDocument:**
- `Id` - Document identifier
- `Title` - Document name
- `ContentSize` - File size in bytes
- `FileType` - File extension (PDF, DOCX, etc.)
- `CreatedDate` - When document created

**ContentDocumentLink:**
- `ContentDocumentId` - Reference to document
- `LinkedEntityId` - Parent record (Case, Received_Fax__c, etc.)
- `ShareType` - Visibility type (V=Viewer, C=Collaborator)

**Role in System:**
- Stores attachments and documents
- Links files to case records
- Links files to sent/received fax records
- Queried by: getRelatedFiles(), getRecFaxFiles()
- Files selected for: sendFax()

**Healthcare Context:**
- Medical documentation storage
- Prescription images
- Prior auth requests/approvals
- Appeal documentation
- Insurance forms
- Patient records
- **Process Stage:** Document management across all stages

---

## 🔄 Data Relationships

### Relationship Diagram

```
CareProgramEnrollee (Center Hub)
    ↓
    ├─→ CareProgram (Program settings)
    ├─→ CoverageBenefit (Insurance coverage)
    ├─→ PatientMedicationDosage (Rx details)
    │   ├─→ Prescribing_Physician (Provider fax)
    │   └─→ Specialty_Pharmacy (Pharmacy fax)
    ├─→ Case (Support tickets)
    ├─→ CarePreauth (Prior authorizations)
    ├─→ Appeal__c (Appeals)
    ├─→ J_Copay__c (Copay assistance)
    ├─→ J_Charitable__c (Charitable assistance)
    ├─→ Received_Fax__c (Incoming faxes)
    │   └─→ ContentDocument (Attachments)
    └─→ Sent_Fax__c (Outgoing faxes)
        └─→ ContentDocument (Attachments)
```

---

## 🏥 Complete Healthcare Patient Support Process

### Stage 1: Enrollment (CareProgramEnrollee, CareProgram)
```
New Patient → Enroll in Care Program → Assign Coverage
```

### Stage 2: Care Management (CoverageBenefit, PatientMedicationDosage, CarePreauth)
```
Define Coverage → Get Medication Prescription → Request Prior Auth
```

### Stage 3: Medication & Pharmacy Management (PatientMedicationDosage)
```
Prescribe Medication → Route to Specialty Pharmacy → Coordinate with Provider
```

### Stage 4: Patient Support Programs (J_Copay__c, J_Charitable__c)
```
Patient Needs Help → Apply for Copay Assistance → Enroll in PAP/TPAP
```

### Stage 5: Case Management (Case)
```
Patient Inquiry → Create Support Ticket → Track Resolution
```

### Stage 6: Appeals & Disputes (Appeal__c)
```
Deny Claim → Patient Files Appeal → Document & Communicate
```

### Stage 7: Communication & Documentation (Sent_Fax__c, Received_Fax__c)
```
Compose Fax → Send to Provider/Pharmacy → Track Receipt
Receive Response → Store Documentation → Link to Records
```

### Stage 8: Ongoing Maintenance (All objects)
```
Monitor Coverage Expiry → Review Medication Changes → Update Programs
```

---

## 📊 Object Usage Summary

| Object | Usage Count | Primary Function | Healthcare Stage |
|--------|-----------|-----------------|-----------------|
| CareProgramEnrollee | 8/8 methods | Patient hub | All stages |
| CareProgram | 1 method | Program settings | Enrollment |
| Case | 2 methods | Support tracking | Case Management |
| CoverageBenefit | 2 methods | Insurance coverage | Care Management |
| PatientMedicationDosage | 2 methods | **Fax routing** | Medication Management |
| CarePreauth | 2 methods | Authorization tracking | Care Management |
| Appeal__c | 2 methods | Appeal tracking | Appeals |
| J_Copay__c | 2 methods | Copay assistance | Support Programs |
| J_Charitable__c | 2 methods | Charitable assistance | Support Programs |
| Received_Fax__c | 1 method | Incoming docs | Communication |
| Sent_Fax__c | 1 method | Outgoing docs | Communication |
| ContentDocument | 2 methods | File storage | Documentation |

---

## 🎯 Key Features by Stage

### ✅ Patient Enrollment
- Create CareProgramEnrollee records
- Assign care programs
- Set up coverage benefits

### ✅ Care Management
- Track coverage benefits
- Manage prescriptions
- Request prior authorizations
- Coordinate with providers

### ✅ Medication Management
- Store prescription details
- Link to prescribing physicians
- Connect to specialty pharmacies
- Manage dosing information

### ✅ Patient Support Programs
- Enroll in copay assistance
- Track charitable assistance
- Monitor program eligibility
- Manage program renewals

### ✅ Case Management
- Log patient inquiries
- Track support tickets
- Manage resolutions
- Document interactions

### ✅ Appeals & Disputes
- Create appeal records
- Track appeal status
- Store supporting documentation
- Manage decision dates

### ✅ Communication Management
- Send faxes to providers/pharmacies
- Receive and store incoming faxes
- Attach documentation
- Track delivery status

### ✅ Ongoing Maintenance
- Monitor expiring coverages
- Update medication prescriptions
- Review program eligibility
- Manage renewals and changes

---

## 💡 Why This Object Model is Powerful

1. **Holistic Patient View** - All care information centralized around CareProgramEnrollee
2. **Multi-Channel Communication** - Support programs, cases, and fax management integrated
3. **Compliance Ready** - Tracks all interactions and authorizations
4. **Scalable** - Supports multiple programs, benefits, and medications per patient
5. **Audit Trail** - Complete history of decisions and communications
6. **Real-World** - Reflects actual healthcare business processes

---

## 🚀 Use Cases Enabled by This Model

✅ **Prior Authorization** - CarePreauth → Sent_Fax__c to Provider  
✅ **Prescription Management** - PatientMedicationDosage → Route to Pharmacy  
✅ **Appeals Management** - Appeal__c → Document storage → Sent_Fax__c  
✅ **Patient Assistance** - J_Copay__c/J_Charitable__c → Eligibility tracking  
✅ **Case Resolution** - Case → Support ticket → Documentation  
✅ **Compliance** - Received_Fax__c → Historical records → Audit trail  
✅ **Multi-Program Support** - Single patient → Multiple programs tracked  

---

## 📈 Business Value

This comprehensive object model enables:
- **Faster** case and appeal resolution
- **Better** patient support and engagement
- **Cleaner** provider and pharmacy coordination
- **Compliant** documentation and communication
- **Scalable** support for thousands of patients
- **Reportable** metrics on program effectiveness

---

## 🔐 Security & Access

All objects enforce:
- Field-level security (FLS)
- Object-level security
- Record-level security (via sharing)
- Audit trail logging
- Data encryption
- HIPAA compliance considerations

---

**This object model represents a complete, enterprise-grade healthcare patient support ecosystem!**

---

*Document Version: 1.0*  
*Last Updated: July 21, 2026*  
*Author: Mohamed Mickram*
