/**
 * @description       : Main Apex controller for eFax Lightning Web Component
 * @author            : Mickram
 * @group             : eFax System
 * @last modified on  : 09-21-2023
 * 
**/
public with sharing class sendFaxLwc{

    @AuraEnabled(cacheable = true)
    public static string getEnrolleeId(Id recordId){
        try {
            Schema.SObjectType objectType = recordId.getSobjectType();

            if (objectType == Schema.CareProgramEnrollee.SObjectType) {
                return recordId;
            } 
            else if (objectType == Schema.Case.SObjectType) {
                Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case WHERE id = :recordId LIMIT 1];
                return relatedCase.Care_Program_Enrollee__c;
            } 
            else if (objectType == Schema.CoverageBenefit.SObjectType) {
                CoverageBenefit relatedCB = [SELECT id, Care_Program_Enrollee__c FROM CoverageBenefit WHERE id = :recordId LIMIT 1];
                return relatedCB.Care_Program_Enrollee__c;
            }
            else if (objectType == Schema.CarePreauth.SObjectType) {
                CarePreauth relatedPriAuth = [SELECT id, Care_Program_Enrollee__c FROM CarePreauth WHERE id = :recordId LIMIT 1];
                return relatedPriAuth.Care_Program_Enrollee__c;
            }
            else if (objectType == Schema.Appeal__c.SObjectType) {
                Appeal__c relatedAppeal = [SELECT id, Authorization__r.Care_Program_Enrollee__c FROM Appeal__c WHERE id = :recordId LIMIT 1];
                return relatedAppeal.Authorization__r.Care_Program_Enrollee__c;
            }
            else if (objectType == Schema.J_Copay__c.SObjectType) {
                J_Copay__c relatedCopay = [SELECT id, Care_Program_Enrollee__c FROM J_Copay__c WHERE id = :recordId LIMIT 1];
                return relatedCopay.Care_Program_Enrollee__c;
            }
            else if (objectType == Schema.J_Charitable__c.SObjectType) {
                J_Charitable__c relatedPAP = [SELECT id, Care_Program_Enrollee__c FROM J_Charitable__c WHERE id = :recordId LIMIT 1];
                return relatedPAP.Care_Program_Enrollee__c;
            }
            else {
                return recordId;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled (cacheable = true)
    public static string getEnrolleeName(id recordId){
        string enrolleeName;
        
        Schema.SObjectType objectType = recordId.getSobjectType();
        if (objectType == Schema.Case.SObjectType) {
            Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case WHERE id = :recordId LIMIT 1];
            recordId = relatedCase.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CoverageBenefit.SObjectType) {
            CoverageBenefit relatedCB = [SELECT id, Care_Program_Enrollee__c FROM CoverageBenefit WHERE id = :recordId LIMIT 1];
            recordId = relatedCB.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CarePreauth.SObjectType) {
                CarePreauth relatedPriAuth = [SELECT id, Care_Program_Enrollee__c FROM CarePreauth WHERE id = :recordId LIMIT 1];
                recordId = relatedPriAuth.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.Appeal__c.SObjectType) {
                Appeal__c relatedAppeal = [SELECT id, Authorization__r.Care_Program_Enrollee__c FROM Appeal__c WHERE id = :recordId LIMIT 1];
                recordId = relatedAppeal.Authorization__r.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Copay__c.SObjectType) {
                J_Copay__c relatedCopay = [SELECT id, Care_Program_Enrollee__c FROM J_Copay__c WHERE id = :recordId LIMIT 1];
                recordId = relatedCopay.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Charitable__c.SObjectType) {
                J_Charitable__c relatedPAP = [SELECT id, Care_Program_Enrollee__c FROM J_Charitable__c WHERE id = :recordId LIMIT 1];
                recordId = relatedPAP.Care_Program_Enrollee__c;
            }
        CareProgramEnrollee cpe= [select id, name from CareProgramEnrollee where id =:recordId];
            enrolleeName = cpe.Name;
            system.debug('Enrollee Name'+cpe.Name);
        return enrolleeName;
        
    }
    
    @AuraEnabled (cacheable = true)
    public static string getCpFaxNum(id recordId){
        string cpFaxNum;
        
        Schema.SObjectType objectType = recordId.getSobjectType();
        if (objectType == Schema.Case.SObjectType) {
            Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case WHERE id = :recordId LIMIT 1];
            recordId = relatedCase.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CoverageBenefit.SObjectType) {
            CoverageBenefit relatedCB = [SELECT id, Care_Program_Enrollee__c FROM CoverageBenefit WHERE id = :recordId LIMIT 1];
            recordId = relatedCB.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CarePreauth.SObjectType) {
                CarePreauth relatedPriAuth = [SELECT id, Care_Program_Enrollee__c FROM CarePreauth WHERE id = :recordId LIMIT 1];
                recordId = relatedPriAuth.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.Appeal__c.SObjectType) {
                Appeal__c relatedAppeal = [SELECT id, Authorization__r.Care_Program_Enrollee__c FROM Appeal__c WHERE id = :recordId LIMIT 1];
                recordId = relatedAppeal.Authorization__r.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Copay__c.SObjectType) {
                J_Copay__c relatedCopay = [SELECT id, Care_Program_Enrollee__c FROM J_Copay__c WHERE id = :recordId LIMIT 1];
                recordId = relatedCopay.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Charitable__c.SObjectType) {
                J_Charitable__c relatedPAP = [SELECT id, Care_Program_Enrollee__c FROM J_Charitable__c WHERE id = :recordId LIMIT 1];
                recordId = relatedPAP.Care_Program_Enrollee__c;
            }
        CareProgramEnrollee cpe1= [select id, name, CareProgram.Fax__c from CareProgramEnrollee where id =:recordId];
            cpFaxNum = cpe1.CareProgram.Fax__c;
            system.debug('Fax'+cpFaxNum);
        return cpFaxNum;
        
    }
    
    @AuraEnabled (cacheable = true)
    public static string getFaxNum(Id recordId){
        string faxNum; 
        
       Schema.SObjectType objectType = recordId.getSobjectType();
        if (objectType == Schema.Case.SObjectType) {
            Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case WHERE id = :recordId LIMIT 1];
            recordId = relatedCase.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CoverageBenefit.SObjectType) {
            CoverageBenefit relatedCB = [SELECT id, Care_Program_Enrollee__c FROM CoverageBenefit WHERE id = :recordId LIMIT 1];
            recordId = relatedCB.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CarePreauth.SObjectType) {
                CarePreauth relatedPriAuth = [SELECT id, Care_Program_Enrollee__c FROM CarePreauth WHERE id = :recordId LIMIT 1];
                recordId = relatedPriAuth.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.Appeal__c.SObjectType) {
                Appeal__c relatedAppeal = [SELECT id, Authorization__r.Care_Program_Enrollee__c FROM Appeal__c WHERE id = :recordId LIMIT 1];
                recordId = relatedAppeal.Authorization__r.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Copay__c.SObjectType) {
                J_Copay__c relatedCopay = [SELECT id, Care_Program_Enrollee__c FROM J_Copay__c WHERE id = :recordId LIMIT 1];
                recordId = relatedCopay.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Charitable__c.SObjectType) {
                J_Charitable__c relatedPAP = [SELECT id, Care_Program_Enrollee__c FROM J_Charitable__c WHERE id = :recordId LIMIT 1];
                recordId = relatedPAP.Care_Program_Enrollee__c;
            }
    	PatientMedicationDosage dosage = [select id,Prescribing_Physician__r.Fax, Prescribing_Physician__c, Specialty_Pharmacy__c from PatientMedicationDosage where Care_Program_Enrollee_Name__c =:recordId];
        	faxNum = dosage.Prescribing_Physician__r.Fax;
        return faxNum;
        
    }
    
    @AuraEnabled (cacheable = true)
    public static string getPharFax(id recordId){
        
        string pharFax;
        
        Schema.SObjectType objectType = recordId.getSobjectType();
        if (objectType == Schema.Case.SObjectType) {
            Case relatedCase = [SELECT id, Care_Program_Enrollee__c FROM Case WHERE id = :recordId LIMIT 1];
            recordId = relatedCase.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CoverageBenefit.SObjectType) {
            CoverageBenefit relatedCB = [SELECT id, Care_Program_Enrollee__c FROM CoverageBenefit WHERE id = :recordId LIMIT 1];
            recordId = relatedCB.Care_Program_Enrollee__c;
        }
        else if (objectType == Schema.CarePreauth.SObjectType) {
                CarePreauth relatedPriAuth = [SELECT id, Care_Program_Enrollee__c FROM CarePreauth WHERE id = :recordId LIMIT 1];
                recordId = relatedPriAuth.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.Appeal__c.SObjectType) {
                Appeal__c relatedAppeal = [SELECT id, Authorization__r.Care_Program_Enrollee__c FROM Appeal__c WHERE id = :recordId LIMIT 1];
                recordId = relatedAppeal.Authorization__r.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Copay__c.SObjectType) {
                J_Copay__c relatedCopay = [SELECT id, Care_Program_Enrollee__c FROM J_Copay__c WHERE id = :recordId LIMIT 1];
                recordId = relatedCopay.Care_Program_Enrollee__c;
            }
        else if (objectType == Schema.J_Charitable__c.SObjectType) {
                J_Charitable__c relatedPAP = [SELECT id, Care_Program_Enrollee__c FROM J_Charitable__c WHERE id = :recordId LIMIT 1];
                recordId = relatedPAP.Care_Program_Enrollee__c;
            }
    PatientMedicationDosage dosage = [select id,Prescribing_Physician__r.Fax, Prescribing_Physician__c, Specialty_Pharmacy__r.Fax from PatientMedicationDosage where Care_Program_Enrollee_Name__c =:recordId];
        pharFax = dosage.Specialty_Pharmacy__r.Fax;
		system.debug('Pharma Fax'+pharFax);
        return pharFax;
        
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentDocument> getRelatedFiles(Id recordId) {
        List<ContentDocumentLink> links = [
            SELECT ContentDocumentId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];

        Set<Id> contentDocumentIds = new Set<Id>();
        for (ContentDocumentLink link : links) {
            contentDocumentIds.add(link.ContentDocumentId);
        }

        List<ContentDocument> files = [
            SELECT Id, Title, ContentSize, FileType
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];

        return files;
    }

    @AuraEnabled(cacheable = true)
    public static List<ContentDocument> getRecFaxFiles(Id recordId) {
        Set<Id> contentDocumentIds = new Set<Id>();
        
        Schema.SObjectType objectType = recordId.getSobjectType();
		String query;
        if (objectType == Schema.CareProgramEnrollee.SObjectType) {
         query = 'SELECT Id FROM Received_Fax__c WHERE Care_Program_Enrollee__c = :recordId';
        }
        else if (objectType == Schema.Case.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE AE_PQC__c = :recordId';
        }
        else if (objectType == Schema.CoverageBenefit.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE Coverage_Benefit__c = :recordId';
        }
        else if (objectType == Schema.CarePreauth.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE Prior_Authorization__c = :recordId';
        }
        else if (objectType == Schema.Appeal__c.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE Appeal__c = :recordId';
        }
        else if (objectType == Schema.J_Copay__c.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE Copay__c = :recordId';
        }
        else if (objectType == Schema.J_Charitable__c.SObjectType) {
            query = 'SELECT Id FROM Received_Fax__c WHERE PAP_TPAP__c = :recordId';
        }
        
        List<Received_Fax__c> receivedFaxes = Database.query(query);

        for (Received_Fax__c recFax : receivedFaxes) {
            List<ContentDocumentLink> documentLinks = [
                SELECT ContentDocumentId
                FROM ContentDocumentLink
                WHERE LinkedEntityId = :recFax.Id
            ];

            for (ContentDocumentLink link : documentLinks) {
                contentDocumentIds.add(link.ContentDocumentId);
            }
        }

        List<ContentDocument> faxFiles = [
            SELECT Id, Title, ContentSize, FileType
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];

        for (ContentDocument file : faxFiles) {
            System.debug('File Id: ' + file.Id);
            System.debug('File Title: ' + file.Title);
            System.debug('File ContentSize: ' + file.ContentSize);
            System.debug('File FileType: ' + file.FileType);
        }
        return faxFiles;
    }
 
    @AuraEnabled
    public static String sendFax(String faxNumber, List<Id> contentDocumentIds){
        List<EFaxCalloutService.Destination> destinations = new List<EFaxCalloutService.Destination>();
        List<EFaxCalloutService.Document> documents = new List<EFaxCalloutService.Document>();
        EFaxCalloutService.Destination destination = new EFaxCalloutService.Destination();

        destination.to_name = ''; 
        destination.to_company = ''; 
        destination.fax_number = faxNumber;
        destinations.add(destination);

        EFaxCalloutService.FaxOptions faxOptions = new EFaxCalloutService.FaxOptions();
        faxOptions.image_resolution = 'FINE';
        faxOptions.include_cover_page = false;
        faxOptions.custom_CSID = '13456781278';
        
        for(ContentVersion cv : [select Id,VersionData,FileType from Contentversion where ContentDocumentId=:contentDocumentIds]){
            EFaxCalloutService.Document document = new EFaxCalloutService.Document();
            document.document_type = cv.FileType;
            document.document_content = EncodingUtil.base64Encode(cv.VersionData);
            documents.add(document);
        }

        return EFaxCalloutService.sendFax(destinations, documents, faxOptions);
    }
    
    @AuraEnabled
    public static String saveFax(String faxNumber, List<Id> selectedFiles, Id recordId, DateTime sendDateTime, DateTime deliveryDateTime,
                                 String orgFaxNum, String to) {
        
        try {
            String faxId = sendFax(faxNumber, selectedFiles);

            Sent_Fax__c sentFax = new Sent_Fax__c(
                Fax_Number__c = faxNumber,
                Fax_Id__c = faxId,
                Send_Date_Time__c = sendDateTime,
                Delivery_Date_Time__c = deliveryDateTime,
                Organisation_Fax_number__c = orgFaxNum,
                To__c = to
            );

            Schema.SObjectType objectType = recordId.getSobjectType();
            if(objectType == Schema.CareProgramEnrollee.SObjectType){
                sentFax.Care_Program_Enrollee__c = recordId;
            }
			else if(objectType == Schema.Case.SObjectType){
                sentFax.AE_PQC__c = recordId;
            }
			else if(objectType == Schema.CoverageBenefit.SObjectType){
                sentFax.Coverage_Benefit__c = recordId;
            }
            else if(objectType == Schema.CarePreauth.SObjectType){
                sentFax.Prior_Authorization__c = recordId;
            }
            else if(objectType == Schema.Appeal__c.SObjectType){
                sentFax.Appeal__c = recordId;
            }
            else if(objectType == Schema.J_Copay__c.SObjectType){
                sentFax.Copay__c = recordId;
            }
            else if(objectType == Schema.J_Charitable__c.SObjectType){
                sentFax.PAP_TPAP__c = recordId;
            }
            insert sentFax;

            List<ContentDocumentLink> fileLinks = new List<ContentDocumentLink>();
            for (Id fileId : selectedFiles) {
                ContentDocumentLink link = new ContentDocumentLink(
                    ContentDocumentId = fileId,
                    LinkedEntityId = sentFax.Id,
                    ShareType = 'V'
                );
                fileLinks.add(link);
            }
            insert fileLinks;

            return 'Fax saved successfully.';
        } catch (Exception e) {
            return 'Error saving fax: ' + e.getMessage();
        }
    }
}
