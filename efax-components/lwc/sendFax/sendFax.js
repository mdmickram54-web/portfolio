import { LightningElement, wire, api, track} from "lwc";
import enrolleerecord from '@salesforce/apex/sendFaxLwc.getEnrolleeName';
import relatedFiles from '@salesforce/apex/sendFaxLwc.getRelatedFiles';
import { NavigationMixin } from "lightning/navigation";
import getFaxNumber from '@salesforce/apex/sendFaxLwc.getFaxNum';
import getPharFax from '@salesforce/apex/sendFaxLwc.getPharFax';
import getRecFaxFiles from '@salesforce/apex/sendFaxLwc.getRecFaxFiles';
import saveFax from '@salesforce/apex/sendFaxLwc.saveFax';
import getCpFaxNum from '@salesforce/apex/sendFaxLwc.getCpFaxNum';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class SendFax extends NavigationMixin(LightningElement) {

  @api recordId;
  @track enrolleeName;
  @track selectedValue = '';
  @track inputValue;
  @track showInputBox = false;
  @track pharFax;
  @track faxNum;
  @track relatedFiles;
  @track getRecFaxFiles;
  @track selectedFileIds = [];
  @track cpFaxNum;
  
    
  @wire(getCpFaxNum, { recordId: "$recordId" })
  wiredCpFaxNum({ error, data }) {
      if (data) {
          this.cpFaxNum = data;
      } else if (error) {
          console.error("Error fetching CP Fax Number:", error);
      }
  }

    @wire(getRecFaxFiles, { recordId: '$recordId' })
    wiredgetRecFaxFiles({ error, data }) {
        if (data) {
            this.getRecFaxFiles = data;
        } else if (error) {
            console.error('Error fetching related files:', error);
        }
    }

    @wire(relatedFiles, { recordId: '$recordId' })
    wiredRelatedFiles({ error, data }) {
        if (data) {
            this.relatedFiles = data;
        } else if (error) {
            console.error('Error fetching related files:', error);
        }
    }

    handleChange(event) {
      this.selectedValue = event.detail.value;

      console.dir("Selected Value:", this.selectedValue);
      
      if (this.selectedValue === "pharmacy") {
          this.retrievePharFax();
          this.selectedValue = event.detail.value;
        this.showInputBox = this.selectedValue === 'pharmacy';

      } else if (this.selectedValue === "provider") {
        this.selectedValue = event.detail.value;
          this.retrieveProviderFaxNumber();
          this.showInputBox = this.selectedValue === 'provider';
      } else {
          this.inputValue = '';
      }
  }

  retrievePharFax() {
      getPharFax({ recordId: this.recordId })
          .then((result) => {
              this.pharFax = result;
              this.inputValue = this.pharFax;
              console.log("Pharmacy Fax Number:", this.pharFax);
          })
          .catch((error) => {
              console.error("Error fetching pharmacy fax number:", error);
          });
  } 

  retrieveProviderFaxNumber() {
      getFaxNumber({ recordId: this.recordId })
          .then((result) => {
              this.faxNum = result;
              this.inputValue = this.faxNum;
              console.dir("Provider Fax Number:", this.faxNum);
          })
          .catch((error) => {
              console.error("Error fetching provider fax number:", error);
          });
  }
  
  @wire(enrolleerecord, {recordId: '$recordId'}) 
  async currentrecord() {
    enrolleerecord({recordId: this.recordId})
    .then(result => {
    this.enrolleeName = result;
    console.dir('data',result);
    console.dir('recordValues',this.enrolleeName);
     })
   .catch(error => {
     });
  }

  @track value = '--Please Select--';

  get options() {
    return [
             { label: 'Provider', value: 'provider' },
             { label: 'Pharmacy', value: 'pharmacy' },
             { label: 'Other', value: 'other' },
           ];
  }

  handleFileSelection(event) {
    const contentDocumentId = event.target.dataset.fileid;
    if (event.target.checked) {
      console.log("Content Doc Id:"+ contentDocumentId);
        this.selectedFileIds.push(contentDocumentId);
    } else {
        const index = this.selectedFileIds.indexOf(contentDocumentId);
        if (index !== -1) {
            this.selectedFileIds.splice(index, 1);
        }
    }

    console.log("Selected File IDs:", this.selectedFileIds);
  }

  openFileInNewTab(event) {
    event.preventDefault();
    const contentDocumentId = event.target.dataset.fileid;

    if (contentDocumentId) {
        const fileUrl = `/lightning/r/ContentDocument/${contentDocumentId}/view`;
        window.open(fileUrl, '_blank');
    }
  }

  handleFileSelectionFax(event) {
    const contentDocumentId = event.target.dataset.fileid;
    if (event.target.checked) {
        this.selectedFileIds.push(contentDocumentId);
    } else {
        const index = this.selectedFileIds.indexOf(contentDocumentId);
        if (index !== -1) {
            this.selectedFileIds.splice(index, 1);
        }
    }

    console.dir("Selected File IDs:", this.selectedFileIds);
  }

  handleSendClick() {
    this.selectedValue = this.selectedValue || '';
    this.inputValue = this.inputValue || '';
    this.pharFax = this.pharFax || '';
    this.faxNum = this.faxNum || '';

    if (this.selectedValue && this.selectedFileIds.length > 0) {
        let faxNumber;
        
        if (this.selectedValue === 'pharmacy') {
            faxNumber = this.pharFax;
        } else if (this.selectedValue === 'provider') {
            faxNumber = this.faxNum;
        } else {
            faxNumber = this.inputValue;
        }
        
        if (!faxNumber) {
            console.error('Fax number is missing.');
            return;
        }

        const currentDateTime = new Date().toISOString();
        const assignOrgFax = this.cpFaxNum;
        const toValue = this.selectedValue;

        saveFax({ 
            faxNumber, 
            selectedFiles: this.selectedFileIds, 
            recordId: this.recordId,
            sendDateTime: currentDateTime,
            deliveryDateTime: currentDateTime,
            status: 'Sent',
            orgFaxNum: assignOrgFax,
            to: toValue
        })
        .then(result => {
            if (result.startsWith('Error')) {
                console.error(result);
            } else {
                console.dir('Fax saved:', result);

                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'CareProgramEnrollee',
                        actionName: 'view',
                    },
                });

                this.showToast('Success', 'Fax has been sent successfully.', 'success');
            }
        })
        .catch(error => {
            console.error('Error saving fax details:', error);
        });
    } else {
        console.error('Selected files or value is missing.');
        console.dir('Selected Value:', this.selectedValue);
        console.dir('Selected File IDs:', this.selectedFileIds);
    }
  }

  showToast(title, message, variant) {
    const event = new ShowToastEvent({
        title: title,
        message: message,
        variant: variant,
        mode: 'dismissable'
    });

    this.dispatchEvent(event);
  }
}
