
/*Common messgaes*/



WPMAssessmentStatus=
{

Draft:5653,
Submitted:5654,
Clarified: 5655,
Recommended:5656,
Clarification_Sought_by_HD:5657,
Approved:5658,
Clarification_Sought_by_JKN: 5659
    };

WPM_DeductionMade_AssessmentStatusList=
{

     Draft                        : 5653,
    Submitted                    : 5654,
    Clarified                    : 5655,
    Recommended                  : 5656,
    Clarification_Sought_by_HD   : 5657,
    Approved                     : 5658,
    Clarification_Sought_by_JKN  : 5659
};
BERApplicationStatusValue = {
Acknowledged:               2634,
Applied:	                2632,
Approved:	                2641,
Cancelled:	                2633,
ClarificationSoughtByHD:	2636,
ClarificationSoughtByJOHN:	5600,
ClarificationSoughtByMoH:	5601,
ClarifiedByApplicant:	    2637,
ClarifiedByHD:	            5602,
ClarifiedByJOHN:            5603,
Completed:                  2639,
Finalized: 	                2640,
New:                        2631,
Recommended:	            2638,
RejectedByHD:	            2635,
RejectedByJOHN:	            5604,
RejectedByMoH:	            5605,
Resubmitted:	            5597,
SavedByJOHN:	            4593,
SavedByMOH:	                4592
};

SERVICE = {
        FEMS : 1,
        BEMS : 2,
        CLS : 3,
        LLS : 4,
        HWMS : 5,
        FMS : 6,
        BER : 7,
        QAP : 8,
        SP : 9,
        SR : 10,
        VM : 11,
        TPC : 12,
        FIN : 13,
        DED : 14,
        WPM : 15,
        EOD : 16,
        HSIP : 17,
        UM : 18,
        HD : 19,
        VRC : 20,
        WebPortal : 21,
        GM : 22,
        Reports : 23,
        Mob : 24,
        ThreeR : 26,
        IAQ : 27,
        Energy : 28,
        General : 1501
        };

Positions = {

    JohnPosition: 2840,
    HospitalDirector:2837,
    JKN: 5912
};

KeyChangeTimeOut = {
    TimeOut: 250,
};

Messages = {
    PASSWORD_CHANGED: "Password Changed Successfully!",
    // Delete related messages
    DELETE_CONFIRMATION: "Do you want to delete the record ",
    MULTIPLE_DELETE_CONFIRMATION: "Record(s) selected for deletion.  Do you want to proceed?",
    NO_RECORDS_TO_SAVE: "There are no records to save",

    SELECT_ATLEAST_ONE_RECORD: "Please select atleast one record to delete.",
    CAN_NOT_DELETE_ALL_RECORDS: "Sorry!. You cannot delete all record(s).",
    FILE_UPLOADED_SUCCESS: "File uploaded successfully.",
    SEARCH_GRID_DELETE_CONFIRMATION: "Are you sure you want to delete? ",
    SEARCH_GRID_CANCEL_CONFIRMATION: "Are you sure you want to cancel? ",
    Reset_TabAlert_CONFIRMATION: " Are you sure you want to Reset All the Tab(s)?",
    Reset_Alert_CONFIRMATION: " Are you sure you want to Reset All the Fields?",
    Unblock_Alert_CONFIRMATION:"Are you sure you want to Unblock Selected Records",

    //CLS_SERVICE_CONFIRMATION: "Entered Record(s) will be lose.  Do you want to proceed?",
    CLS_SERVICE_CONFIRMATION: "The changes you made will be lost! Do you want to continue?",
    //SAVE_FIRST_TAB: " details must be saved before entering additional information.",
    SAVE_FIRST_TAB: "Save the details before moving on to next screen!",
    SAVE_FIRST_TABALERT: "Save the details before moving on to Other!",
    SAVE_FIRSTTAB_TABALERT: "Save the Assessment details before moving on to Other!",
    // Get Related Messages
    FAILED_TO_LOAD: "Failed to load data! ",
    UNBLOCKED_SUCCESSFULLY: "Uer unblocked successfully",

    /* Valid Post Code */
    FMS_PC: ["Please enter valid post code"],


    //Caption Message
    EXPORT_TO_PDF: "Export to PDF",
    EXPORT_TO_EXCEL: "Export to Excel",
    EXPORT_TO_CSV: "Export to CSV",

    // Error Messages 
    CLOSE_BTN_ERROR_MESSAGE_FOR_POPUP: ["Some fields are incorrect or have not been filled in. Please delete to remove newly added fields or fill in the details to save."],
    ALL_FIELDS_MANDATORY: 'All fields are mandatory. Please enter details in existing row',
    CORRECT_ABOVE_ERRORS: 'Please correct above errors to continue!',
    INVALID_INPUT_MESSAGE: "Some fields are incorrect or have not been filled in. Please correct this to proceed.",
    StandardTaskLGrid_OneRow_MIn: "Standard Tast Details should contain atleast one record.",

    NO_RECORDS_TO_DISPLAY: "No Records to Display",
    EMPTY_RECORD: "No records to display",
    PAGE_GRID_ROWLIST: [5, 10, 20, 50],
    PAGE_GRID_ROWNUM_DEFAULT: 10,
    EDIT_NOT_ALLOWED: "Edit is not allowed if record status is Inactive",
    USER_REGISTERED_SUCESSFULLY: "User(s) Registered Sucessfully",
    SUBMIT_MESSAGE: "Are you sure you want to ",
    Delete_Message: "Are you sure you want to delete",
    SR_REMOVAL_CONFIRMATION: "Are you sure you want to submit BER without Service Request No. ?",
    DATE_TIME12HRS_FORMAT: "d-M-Y h:i A",
    DATE_TIME24HRS_FORMAT: "d-M-Y H:i",
    DATE_FORMAT: "d-M-Y",
    WPM_ALERT_MESSAGE: "Are you sure you want to replace existing data?",
    WORK_GROUP_CODE_UNIQUE: ["Work Group Code should be unique"],
    WORK_GROUP_DESCRIPTION_UNIQUE: ["Work Group Description should be unique"],
    ENTER_VALUES_EXISTING_ROW: "Please enter values in existing row",
    COMMON_FAILURE_MESSAGE: function (response) {
        var isDevelopmentMode = $('#hdnDevelopmentMode').val();
        var errorMessage = '';
        var commonErrorMessage = 'An error occurred while processing your request';
        if (response == null || response == 0)// || !isTestingMode
        {
            errorMessage = commonErrorMessage;
        }
        else {
            if (isDevelopmentMode != '1') {
                errorMessage = commonErrorMessage;
            }
            else {
                if (response.responseJSON != null && response.responseJSON.ReturnMessage != null && response.responseJSON.ReturnMessage.length > 0) {
                    errorMessage = response.responseJSON.ReturnMessage[0];
                }
                else {
                    errorMessage = commonErrorMessage;
                }
            }
        }
        return errorMessage;
    },
    PLZ_ATTACH_FILE: "Please Attach File!",
    FILE_NAME_UNIQUE: "Please enter unique File Name.",
    ATTACH_FILE_ALERT: "Technical Support Letter Details must be saved before entering additional information",
    NO_RECORD_FOUND: "Sorry!. No Records Found",
    Cannot_Delete_All_Rows: "Sorry!. You cannot delete all rows",
    //Page vice Messages
    Contractor_Vendor_Mst_ALERT_MESSAGE: "Contractor and Vendor Master details must be Saved before entering additional information",
    GM_Location_Mst_Delete_ALERT_MESSAGE: "Location code  already in use and cannot be deleted.",
    DUPLICATE_PARAMETER_ALERT: ['Selected Parameter already exists'],
    DUPLICATE_SubInspectionArea_ALERT: ['Sub Inspection Area should be unique'],
    INVALID_EXISTINGROW_MESSAGE: "Please enter value(s) in existing row",
    GM_Location_Mst_Delete_ALERT_MESSAGE: "Location code  already in use and cannot be deleted.",
    Delete_ALERT_MESSAGE: "Location code  already in use and cannot be deleted.",
    TestParameter_Delete_ALERT_MESSAGE: "Test Type  already in use and cannot be deleted.",
    GM_AssetGroup_Mst_Delete_ALERT_MESSAGE: "Record cannot be deleted as it is referred in another record.",
    PAGE_NUMBER_ALERT_MESSAGE: "Please Enter Valid Page Number.",
    GM_LLS_LicenseTypeMaster_Duplication_ALERT_MESSAGE: "License Type Code already exist",

    HWMS_WeighingScaleMaster_Duplication_ALERT_MESSAGE: "Weighing Scale No already exist",
    HWMS_TracingofConSignment_SavefirstTabFields: "Tracing of Consignment must be saved berore entering additional information",
    HWMS_TracingofConSignment_SaveBlobMethod: "Trying saveBlob method ...",
    HWMS_TracingofConSignment_SaveBlobSucceeded: "SaveBlob succeeded",
    HWMS_TracingofConSignment_SaveBlobFailed: "SaveBlob method failed with the following exception:",
    HWMS_TracingofConSignment_NotSupported: "Not supported",
    HWMS_TracingofConSignment_DownloadLinkWithSimulatedClick: "Trying download link method with simulated click ...",
    HWMS_TracingofConSignment_DownloadLinkSucceeded: "Download link method with simulated click succeeded.",
    HWMS_TracingofConSignment_DownloadLinkFailed: "Download link method with simulated click failed with the following exception:",
    HWMS_TracingofConSignment_DownloadLinkWithWindowlocation: "Trying download link method with window.location ...",
    HWMS_TracingofConSignment_DownloadLinkWindowlocationSucceeded: "Download link method with window.location succeeded.",
    HWMS_TracingofConSignment_DownloadLinkWindowlocationFailed: "Download link method with window.location failed with the following exception:",
    HWMS_TracingofConSignment_SavingArraybuffer: "No methods worked for saving the arraybuffer, using last resort window.open",
    HWMS_TracingofConSignment_RequestFailed: "Request failed with status: ",
    HWMS_TracingofConSignment_NoRecordsByMonthAndWasteType: "No matching records for the selected Month and Waste Type",
    HWMS_TracingofConSignment_FileTypeAndNameRequired: "File Type and File Name is Required!",
    HWMS_TracingofConSignment_FileTypeRequired: "File Type is Required!",
    HWMS_TracingofConSignment_FileNameRequired: "File Name is Required!",
    BER_RemarksMandatory: "Remarks is mandatory",

    FMS_ManpowerNorms_HospitalCategory_Alert_Message: "Please save Hospital Profile data before saving Manpower Norms.",
    FMS_ContractorandVendorMaster_Delete_ALERT_MESSAGE: "SSM Registration Code already in use and cannot be deleted.",
    INITIAL_INCIDENT_DELETE_NOTIFICATION: "Report had been sent.This record is not allowed to delete!",
    LLS_TrolleyNo_Mst_Delete_ALERT_MESSAGE: "Trolley No. already in use and cannot be deleted.",

    //Gm Linene Item Details Messages
    GM_LinenItemDetails_Alert_Message: "Please select Color!",
    GM_StdTaskDetails_TaskCode_Alert_Message: "Please Enter Different Task Code",
    //FMS_OtherPlanner_TypeOfPlanner_Alert_Message: "Same Type Of Planner",
    GM_StdTaskDetails_TaskCode_Duplicate_Alert_Message: "Same TaskCode could not be repeated",
    FMS_OtherPlanner_TypeOfPlanner_Alert_Message: ["Same Type Of Planner could not be repeated"],
    QAP_Indicator_greater_ALERT: ["Indicator Standard should be greater than zero."],
    QAP_Indicator_max_ALERT: ["Indicator Standard should be maximum 100%."],
    Comman_Searchgrid_Delete_ALERT: "Are you sure you want to delete ",
    Comman_Searchgrid_alreadyUsed_ALERT: "This {0} already in use and cannot be deleted.",
    FMS_CompanyStaffMaster_Delete_Failed_Alert: "Staff Master already in use and cannot be deleted.",
    GM_LovMaster_Exist_Alert: "Selected Field Code already added",
    GM_LovMasterValue_Exist_Alert: "Selected Field Value already added",
    GM_LovMasterSortNo_Exist_Alert: "Selected Sort No already added",
    GM_ASSET_INFO_DELETE: "Record cannot be deleted as it is referred in another record",
    GM_ASSET_INFO_EDIT: "Record cannot be edited as it is referred in another record",
    ASSET_STANDARIZATION_MESSAGE: "Selected Manufacturer, Make, Brand and Model combination is already refered.cannot be edited.",
    //Gm HWMS Item Master Message
    GM_HWMS_ItemMaster_Alert_Company: "Please select Company",
    GM_HWMS_ItemMaster_Alert_WasteCategory: "Please select Waste Category",
    GM_HWMS_ItemMaster_Alert_WasteType: "Please select Waste Type",
    GM_Workingcal_Save_ALERT: "Working calendar for year {0} for {1} is not created. Please save to create working calendar.",
    GM_AddButton_BeforeSavingRecord: "Please click on the add button before saving the record.",
    GM_FilesizeLessthan8MB: "File size must be less than 8 MB",
    GM_ManufacturerRequiredToSelectMake: "Manufacturer is required to select Make",
    GM_ManufacturerRequiredToSelectBrand: "Manufacturer and Make is required to select Brand",
    GM_ManufacturerRequiredToSelectModel: "Manufacturer and Brand is required to select Model",
    GM_PleaseUploadPDFFile: "Please upload Pdf file",
    FMS_Workingcal_Save_ALERT: "Working calendar is not defined in general master.",
    WPM_FormB_Save_ALERT: "Hospital Monthly Report Form A  is not defined.",
    FMS_ManpowerNorms_Position_Alert_Message: ['Manpower required to be updated for few more position in next page(s).'],
    STATE_CODE_CONFIRMATION: "Current Changes will reflect only for future Year. Do you wish to continue?",
    // FMS Standard Operating Procedures
    FMS_SOP_Service_Exist_Message: "Record(s) for selected service already exist. Please go to edit mode and attach files for the selected service",
    Edit_Different_Service_Message: " Other Services Records Cannot not be Edited .",
    /*Asset MEssage*/
    Asset_AssetRegister_LAR_ALERT: ['Local Authorised Representative - Contractor/Vendor Code should be unique.'],
    Asset_AssetRegister_TPS_ALERT: ['3rd Party Service Provider - Contractor/Vendor Code should be unique.'],
    Asset_AssetRegister_RI_ALERT: ['Fill valid RI planner data.'],
    Asset_AssetRegister_CALB_ALERT: ['Fill valid Calibration planner data.'],
    Asset_AssetRegister_PPM_ALERT: ['Fill valid PPM planner data.'],
    Asset_Accesories_Repeat_ALERT: ['Serial No. already exist.'],
    Asset_ServingArea_Repeat_ALERT: ['Entered User Location Code already exist.'],
    Asset_InventoryAsset_Repeat_ALERT: ['Entered Inventory Type Code  already exist.'],
    Asset_AssetRegister_PrimaryDetail_Alert: ['Assets added newly can be authorized upon VVF approval.'],
    Asset_AssetRegister_PrimaryDetail_Alert_Building: ['Assets added newly can be authorized upon VVF approval.'],
    Asset_AssetRegister_PrimaryDetail_Alert_Land: ['Assets added newly can be authorized upon VVF approval.'],
    Asset_AssetRegister_Task_UNIQUE: ['Task Code should be unique.'],
    ALL_New_FIELDS_MANDATORY: ['Some fields are mandatory. Please enter details in existing row'],
    CAN_NOT_DELETE_ALLPPM_RECORDS: "Sorry!. You cannot delete all PPM Planner record(s).",
    CAN_NOT_DELETE_ALLCALB_RECORDS: "Sorry!. You cannot delete all Calibration Planner record(s).",
    //FEMS & BEMS - Transaction - Service Work (Unscheduled & Others)
    EMS_Transaction_ServiceWork_Details: "Service work details must be Saved before entering additional information",
    EMS_FilesizeLessthan20MB: "Total Files size must be less than 20MB",
    EMS_Filealreadyuploded: "This file already uploaded.",
    EMS_Differentfile: "is already entered.  Please enter different file Name",
    EMS_FILE: "File name",
    EMS_sevicework: "Service Work",
    EMS_Assessment_details: "Assessment details must be Saved before entering additional information",
    EMS_Save_Assessment: "Please save Assessment before proceeding this",
    EMS_Partsrequired_BeforeProcessing: "Please save Assessment and make Parts Required Yes before proceeding this",
    EMS_PartReplacement: "Part Replacement details must be Saved before entering additional information",
    EMS_ActivityCreated: "Activity must be Created in Assesment - Repair Status before entering additional information",
    /*End*/

    // FEMS & BEMS - Spare Part Stock Register
    EMS_SparePartInfo_Required: "Spare Part / Stock Register details must be Saved before entering additional information",

    /*FMS*/
    FMS_AttachmentTab_Alert_Msg: "Contractor and Vendor Master details must be saved before entering additional information",
    /*End*/
    GM_CommonDocumentUpload_CompanyRequired: "Please select Company Name before selecting Hospital Name",
    WP_Status_Alert_Msg: "Application for Permit to Work details must be saved before entering additional information",
    TRANINIG_DETAILS_EFFECTIVE: ['Please Enter overall effectiveness (%) Less Than or equal 100.'],    

    //PPM Register - GM - FEMS & BEMS

    GM_HEPPM_VersionAndEffectiveDateValidation: "Version & Effective Date should be greater than previous Version & Effective Date.",
    GM_HEPPM_ValidationNotZero: "Version should not be 0.",
    GM_HEPPM_VersionValidation: "Version should be greater than previous Version.",
    GM_HEPPM_EffectiveDateValidation: "Effective Date should be greater than previous Effective Date.",

    /* FMS - Project Details */
    FMS_PD_Project_Cost: "Project Cost / Estimated Cost (RM) should be grater than Zero",
    FMS_PD_Project_Duration_Month: "Project Duration (Months)  should be grater than Zero",
    FMS_PD_EOT_Duration: "EOT Duration (Days) should be grater than zero",
    FMS_PD_EOT_Date_List: "EOT Date should be grater than previous EOT Date",
    FMS_PD_EOT_Date: "EOT Date should be grater than Project Completion Date",

    /*FMS - NCR Analysis - Start*/
    FMS_NCRANALYSIS_EXIST: "Record with same NCR No already exist",
    FMS_NcrAnalysis_SearchGridEdit: "Verified records cannot be Edited",
    /*FMS - NCR Analysis - End*/

    /*Testing And Commissioing*/
    TANDC_ASSET_ALert: ['New Type Code Request is Available Only When TAndC Type is Asset '],
    /*Testing And Commissioing*/

    /*CLS - Equipment - Start*/
    CLS_Equipment_RepairDate: ["Repair End Date should be greater than Repair Start Date"],
    CLS_Equipment_RepairCheck: ["Repair Start Date should be greater than previous Repair End Date"],
    /*CLS - Equipment - End*/
    CLSUserAreaMst_Validation1: "No. of Hand Washing Facility should be greater than zero.",
    CLSUserAreaMst_Validation2: "Cleanable Area sqm should be greater than zero.",
    CLSUserAreaMst_Validation3: "Toilet List should contain atleast one record",
    CLSUserAreaMst_Validation4: "Please select Type, Details and Cubicle before proceed.",
    CLSUserAreaMst_Validation5: "User Area Details must be saved before entering additional information",
    CLSUserAreaMst_Validation6: "VariationStatus List should contain atleast one record",
    CLSUserAreaMst_Validation7: "Please enter details to save",

    /*CLS - MonthlyStockRegister - Start*/
    CLS_MonthlyStockRegister_AlreadyAddedOrExist: "User Area Code already added/exist.",
    CLS_MonthlyStockRegister_CannotDeleteAllExistingEnergyMeter: "Sorry! You cannot delete all rows from existing Energy Meter.",
    CLS_MonthlyStockRegister_DeleteConfirmation: "Are you sure do you want to delete?",
    CLS_MonthlyStockRegister_OutlesserOrEqual: "Out should be lesser then or equal to In ",
    CLS_MonthlyStockRegister_GirdSingleRow: "Gird must has single row",
    CLS_MonthlyStockRegister_SelectConsortiaCompany: "Please Select Consortia Company !",
    CLS_MonthlyStockRegister_PleaseUploadCSVFile: "Please upload csv file",
    CLS_MonthlyStockRegister_UploadedSuccessfullyItemCodesCentralstockNotUploaded: "Uploaded Successfully. Item Codes not in Central stock are not uploaded. ",
    CLS_MonthlyStockRegister_UploadedInvalidData: "Uploaded data are invalid format. ",
    CLS_MonthlyStockRegister_FilesizeMoreThen: "File size is more then",

    /*CLS - MonthlyStockRegister - End*/

    /*FMS - Other Planner- start*/
    FMS_OtherPlanner_Del: "Submitted/Approved records cannot be deleted",
    FMS_OtherPlanner_Edit: "Approved records cannot be edited",
    FMS_OtherPlanner_Approve: "No planners are available for approval",
    FMS_OtherPlanner_ApproveMinimum: "At least select one Approved check box to proceed with Approved button",
    FMS_OtherPlanner_ApproveClick: "No records available for Approval",
    FMS_OtherPlanner_AllRecordsAdded: "Records already added for all Types Of Planner",
    /*FMS - Other Planner - End*/
    /* Report Validation Messages */
    Report_Date_Validation: "To Date should be greater than From Date",
    Report_Month_Validation: "To Month should be greater than From Month",
    Report_Year_Validation: "To Year should be greater than From Year",
    Report_Period_Validation: "To Period should be greater than From Period",
    Report_Year_FromDt_Validation: "From Date should match the selected Year",
    Report_Year_ToDt_Validation: "To Date should match the selected Year",
    Report_FromDt_Required: "From date is required",
    Report_ToDt_Required: "To date is required",
    /* Report Validation Messages */
    /*FEMS- Data Error form*/
    DATAERRORFORM_SUBMIT_CONFIRMATION: "Upon Submit the Data Error Form and respective DVO2 will be locked for editing.  Do you want to proceed?",
    /*FEMS- Data Error form*/
    /*lls- Linen Compliance Test*/
    Linencode_DoesNot_Exists: "There is no laundryCode for current Hospital.",
    LinenComplianceTest_Popup_NoRecord: "No Record is found for given value.",
    LinenCode_Fetch_Check: "Please Select Document Date, Material, Linen Standard and Hospital.",
    LinenComplianceTest_AttachTab_Alert: "Linen Compliance Test Details must be saved before entering additional information.",
    LinenComplianceTest_GridDelete_Alert: "Transaction closed for this month.",
    /*lls- Linen Compliance Test*/
    DUPLICATE_FILENAME: "Duplicate File Name",
    /* LLS - User Department/Area Details Starts */
    LLS_LinenCodeAlready_Exists: ["Entered Linen Code Already Exists."],
    //Asset_InventoryAsset_Repeat_ALERT: ['Entered Inventory Type Code  already exist.'],
    /* LLS - User Department/Area Details Starts */

    /* CLS JI Reschedule*/
    CLS_JIReschedule_Validate1: "Please correct above errors to continue",
    CLS_JIReschedule_Validate2: "Please Select Reason",
    CLS_JIReschedule_Validate3: "Please Select Reschedule Date",
    CLS_JIReschedule_Validate4: "Please UnSelect Reschedule Date Reason",
    CLS_JIReschedule_Validate5:"Please select atleast one row for rescheduling",

    /** CLS Joint Inspection shedule start**/
    CLS_JISchedule_AddRow: "Please enter values in exist row",
    CLS_JISchedule_ErrorMsg1: "Some fields are incorrect or have not been filled in. Please correct this to proceed",
    CLS_JISchedule_ErrorMsg2: "Choose any active hospital and company representative field.",
    CLS_JISchedule_ErrorMsg21: "Choose any active hospital representative field.",
    CLS_JISchedule_ErrorMsg22: "Choose any active company representative field.",
    CLS_JISchedule_ErrorMsg3: "Choose any active hospital and company representative field.",
    CLS_JISchedule_ErrorMsg4: "Record with same User Area Code already exist/added",
    CLS_JISchedule_ErrorMsg5: "No records found this ",
    CLS_JISchedule_ErrorMsg6: "No records available for previous month. ",
    /** CLS Joint Inspection shedule End**/

    /** CLS Periodic work record **/
    CLS_PeriodicWorkRecord_Validate1: "Both Not Carried Out and Not to Schedule cannot have the value 0.",
    CLS_PeriodicWorkRecord_Validate2: "Both Not Carried Out and Not to Schedule cannot have the value 1.",
    CLS_PeriodicWorkRecord_Validate3: "Please enter values in Activity Description and Not To Schedule values should be 1 or Not Carried Out values should be 1 in the Periodic Work Monthly tab.",
    CLS_PeriodicWorkRecord_Validate4: "This User Location Code and Activity Description combination already exists",
    CLS_PeriodicWorkRecord_Validate5: "Please enter values in exist Any One The Tabs To Proceed",
    /** CLS Periodic work record **/


    /*** Linen Rejection at CCLS start ***/
    LLS_LinenRejection_RejectedCountInvalidMsg: "Rejected Quantity can not be greater than Received Quantity Value \"{0}\" for selected Linen Code",
    LLS_LinenRejection_TotalWeightValidationMsg: "Total Weight (Kg) cannot be zero.",
    LLS_LinenRejection_TotalBagValidationMsg: "Total Bag cannot be zero.",
    LLS_LinenRejection_RecordsValidation: "All values cannot be zero for selected linen code",
    LLS_LinenRejection_InvalidLinenCode: "Selected Linen Codes are Invalid.",
    /*** Linen Rejection at CCLS end ***/

    /*** CLS Daily cleaning schedule start ***/
    CLS_DailyCleaning_DateError1: "Prepared by date should be greater than user area service start date",
    CLS_DailyCleaning_DateError2: "Verified by date should be greater than user area service start date",
    CLS_DailyCleaning_DateError3: "Prepared by date and verified by date should be greater than user area service start date",
    /*** CLS Daily cleaning schedule end ***/

    /***  Linen Compliance Test ***/
    LLS_LinenCompilanceTest_FutureDateError: "Document Date should be less than or equal to Current Date.",
    /***  Linen Compliance Test ***/

    /***   Linen Condemnation Start ***/
    LLS_LinenCondemnation_DocDateRequired: "Please Choose Document Date before proceed.",
    LLS_USerAreaCodeRequired:["Valid User Department Code is required"], 
     LLS_HospitalRepRequired:["Valid Hospital Representative is required"], 
    /***   Linen Condemnation End ***/
   
    /**IWDR Error Messages Start ***/
    Facilityname_Already_Exist: "Details for the selected Facility name already added/exist",
    Cannot_Delete_RouteMaster_Details: "Sorry! You cannot delete all rows from existing Route Master details.",
    Select_Grid_before_delete: "Select Gridrow before you delete!",
    IWDR_DeleteConfirmation: "Are you sure do you want to delete?",
    iwdr_AddRow: "Please enter values in exist row",
    IWDR_Itemcode_Exist: "Record with same Item Code already exist/added",
    /**IWDR Error Messages End ***/

    HWMS_ScaleLic_ExpireDate_Greaterthan_PrevExpDate: "Expiry Date should be greater than Previous Expiry Date",
    /** CLS - WashingofContainersandReceptaclesScheduleGenerate **/
    CLS_ScheduleAlreadyGenerated: "Schedule already exists and cannot be generated",
    /** CLS - WashingofContainersandReceptaclesScheduleGenerate **/

    BER_ASSET_NO_REQUIRED: "Please select Nombor Aset",
    BER_REMARKS: "Please enter remarks (catatan)",
    BER_CHECKBOX: "Please tick minimum one check box",
     /***   SP- Energy Consumption ***/
    SP_Future_Energydetails_Message: "Energy details cannot be added for current or future period (month).",
    SP_Alreadyadded_EnergyConsumption_Message: "Energy Consumption details already added/exists for the selected month.",
    SP_Consumption_Completed_Message: "Consumption added for all the month of this year.",
    SP_Consumption_Attach_File_Alert: "Energy Consumption Details must be saved before entering additional information",
    /***   SP- Energy Consumption ***/
    /***   SP- Energy Apportioning Start***/
    SP_Apportioning_TypeEquipment_Exists: "Type of Equipment already exists.",
    /***   SP- Energy Apportioning End***/
    /***   SP- Energy Management Claims Start ***/
    SP_EnergyMgmtClaims_CannotdeleteAll: "Sorry! You cannot delete all rows from existing details.",
    SP_EnergyMgmtClaims_DeleteAll: "Sorry! You cannot delete all rows",
    SP_EnergyMgmtClaims_Atleastonerow: "Please select at least one row!",
    SP_EnergyMgmtClaims_ReceivedDateGreaterthanSubmissionDate: "Received Date should be greater than Submission Date",
    SP_EnergyMgmtClaims_EnergyConsumptionExist: "Energy consumption already added for the selected Item",
    SP_EnergyMgmtClaims_Attach_File_Alert: "Energy Management Claims must be saved before entering additional information",
    /***   SP- Energy Management Claims  End***/

    /********** Web Portal ****************/

    WEBPORTAL_Cancel: "You have unsaved changes on this page. Do you want to leave this page and discard your changes?",
    WEBPORTAL_ReportDetails_Back: "Report details must be saved before entering additional information.",
    WEBPORTAL_SelectedColumns_Back: 'Selected Columns details must be saved before entering additional information.',
    WEBPORTAL_FilterColumns_Back: "Filter details must be saved before entering additional information.",
    WEBPORTAL_DragAndDrop: "Please select one field at a time to move.",
    WEBPORTAL_EnterExistingField: "Please enter existing fields",
    WEBPORTAL_SelectDifferentColumn: "Please choose different columns to sort",
    WEBPORTAL_ValidDateEx: "Please enter a valid date ex: 07/Aug/2016",
    WEBPORTAL_AttachmentRestrictEdit: "Attachment can be Viewed / Added only in edit/View mode.",
    WEBPORTAL_OnlyPreviousTab: "Can navigate only to {0} tab",

    /********** Web Portal ****************/

    /*************SP - Energy Variable Details-Start****************/
    SP_EM_ValidEnergyType: " Valid Energy Variables Type required",
    SP_EM_EVD_MonthRestriction: "Energy Variable details cannot be added for current or future period(month)",
    /*************SP - Energy Variable Details-End****************/

    EOD_FEMS_ParameterMapping_SubSystemAssetNo: "Please select Category/System Name before proceed.",
    EOD_FEMS_ParameterMapping_Parameter: "Please select Category/System Name & Sub-System / Report before proceed.",

    DED_Generation_Submit: "Once Data is saved, changes cannot be performed in any of the Transaction for the selected Period. Do you want to Continue?",
    VRC_DATE_FORM_TO_COMPARISON: "Uploaded Date To should be greater than Uploaded Date From",

    /*************** EM CEM Report Generation - Start ****************/
    SP_EM_CEM_REPORT_EPHRPYear: "From Year should be less than or equal to To Year.",
    SP_EM_CEM_REPORT_EPHRPToYear: "Please choose To year greater than or equal to From Year.",
    SP_EM_CEM_REPORT_Month_Change: "Please choose From Month lesser than To Month.",

    /*************** EM CEM Report Generation - End ****************/

    WPM_Inspection_Not_Scheduled:"Inspection not scheduled for the selected week.",
    /********************** HSIP **********************************/
    Reset_Message: "Do you want to Reload the Data ?",
    Records_Of_RecyclableWaste_Grid_Min: "User Area List should contain atleast one record.",

}

//function AllowFetch(SearchKey, ControlId) {
//    if (SearchKey != undefined) {
//        if (SearchKey.length <= Fetch.Filter_Char_Length) {
//            $(ControlId).hide();
//            return true;
//        }
//    }
//    else {
//        $(ControlId).hide();
//        return true;
//    }
//}

$(document).on('shown.bs.modal', '.bootbox', function (e) {
    setTimeout(function () {
        angular.element($(".Pagination_Template_Page_No")).focus();
    }, 100);
});

function AllowFetch(SearchKey, ControlId, event) {

    if ((SearchKey == undefined || SearchKey == "" || SearchKey == '' || SearchKey == null) && (event != undefined && event.keyCode == 40)) {
        return false;
    }
    else if (SearchKey != undefined && SearchKey != "" && SearchKey != '' && SearchKey != null) {
        if (SearchKey.length <= Fetch.Filter_Char_Length) {
            $(ControlId).hide();
            return true;
        }
        else {
            return false;
        }

    }
    else {
        $(ControlId).hide();
        return true;
    }
}


/* Common Fetch */
Fetch = {
    Filter_Char_Length: 1, //2
    IsShowFilter_Textbox: false,
    Filter_Page_Index: 1,
    Filter_Page_Size: 5,
    GetLookup: function ($scope, NGCollection, PageSize, ControlId) {
        var objCollection = Enumerable.From(NGCollection).Select(function (x) { return { 'TotalRecords': x['TotalRecords'], 'LastPage': x['LastPage'], 'PageIndex': x['PageIndex'], 'PageSize': x['PageSize'] }; }).FirstOrDefault();
        $scope.Fetchcount = (objCollection.length / PageSize);
        $scope.Pagination = [];
        $scope.Pagination.totalRecords = objCollection.TotalRecords;
        $scope.LastPage = objCollection.LastPage;
        $scope.Pagination.LastPage = objCollection.LastPage;
        $scope.Pagination.currentPage = objCollection.PageIndex + 1;
        $scope.LastPage = objCollection.LastPage;
        var startIndex = ($scope.PageIndex * $scope.PageSize) - (Fetch.Filter_Page_Size - 1);
        var endIndex = ($scope.PageIndex * $scope.PageSize);
        if ($scope.PageIndex == $scope.LastPage) {
            $scope.Pagination.startIndex = startIndex;
            $scope.Pagination.endIndex = $scope.Pagination.totalRecords;
        }
        else {
            $scope.Pagination.startIndex = startIndex;
            $scope.Pagination.endIndex = endIndex;
        }
        $(ControlId).show();
    }
}

/* Common Detail Grid Pagination */
InitializeGrid = function ($scope, Service, CollectionInfo, Id) {
    $scope.ShowFirstPage = function () {
        Detail_Grid.Show_FirstPage($scope, CollectionInfo, Id);
    }
    $scope.ShowPreviousPage = function () {
        Detail_Grid.Show_Previous_Page($scope, CollectionInfo, Id);
    }
    $scope.ShowNextPage = function () {
        Detail_Grid.Show_Next_Page($scope, CollectionInfo, Id);
    }
    $scope.ShowLastPage = function () {
        Detail_Grid.Show_Last_Page($scope, CollectionInfo, Id);
    }
    $scope.SetPage = function () {
        if ($scope.totalPages < $scope.pageNumberDisplay || $scope.pageNumberDisplay == 0) {
            bootbox.alert(Messages.PAGE_NUMBER_ALERT_MESSAGE);
            return false;
        }
        else {
            Detail_Grid.Set_Page($scope, CollectionInfo, Id);
        }
    }
    $scope.pageSizeChanged = function () {
        Detail_Grid.Page_Index_Changed($scope, CollectionInfo, Id);
    }
}


Detail_Grid = {
    Page_List: [{ value: 5 }, { value: 10 }, { value: 20 }, { value: 50 }],
    Default_Page_Size: 5,
    Allow_User_Input_Per_Page: 10,
    User_Input_Confirm_Message: "The changes you made will be lost! Do you want to continue?",
    Error_Message: "Please save your changes to proceed further.",
    InjectLocalValues: function ($scope, OrginalCollection) {
        $scope.pageSize = Detail_Grid.Default_Page_Size;
        $scope.GridtotalRecords = 0;
        $scope.pageNumber = 1;
        $scope.totalPages = 0;
        $scope.pageNumberDisplay = 0;
        $scope.PageList = Detail_Grid.Page_List;
        $scope.IsAllowToPKValueZero = false;
    },
    Show_FirstPage: function ($scope, NGCollection, Pk_Id) {
        //************ Dirty Check Purpose *********************//
        var IsError = 0;
        if ($scope.pageNumber != 1) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            obj > 0 ? IsError = true : false;
            if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
                if (objCount == 0)
                    obj > 0 ? IsError = true : false;
            }
            else {
                objCount = 0;
            }
           
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            if (IsError) {
                var Conform = false;
                if ($scope.pageNumber != 1) {
                    if (!$scope.IsSkipFormDirty) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                $scope.pageNumber = 1;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);
                            }
                        });
                    } else {
                        $scope.pageNumber = 1;
                        $scope.FillDataToGrid($scope.pageNumber);
                        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        resetCancel($scope);
                    }
                    
                }
            }
            else {
                if (objCount > 0) {
                    var Conform = false;

                    if ($scope.pageNumber != 1) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                $scope.pageNumber = 1;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);
                            }
                        });
                    }
                } else {
                    if ($scope.pageNumber == 1)
                        return false;
                    $scope.pageNumber = 1;
                    Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id)
                }
            }
        }
    },
    Show_Previous_Page: function ($scope, NGCollection, Pk_Id) {
        //************ Dirty Check Purpose *********************//
        //var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
        //***************************************Error Block ************************************//

        var IsError = 0;
        if ($scope.pageNumber != 1) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
                if (objCount == 0)
                    obj > 0 ? IsError = true : false;
            }
            else {
                obj > 0 ? IsError = true : false;
                objCount = 0;
            }
         

            if (IsError) {
                var Conform = false;

                if ($scope.pageNumber != 1) {
                    if (!$scope.IsSkipFormDirty) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                $scope.pageNumber = --$scope.pageNumber;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);
                            }
                        });
                    } else {
                        $scope.pageNumber = --$scope.pageNumber;
                        $scope.FillDataToGrid($scope.pageNumber);
                        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        resetCancel($scope);
                    }
                    
                }
            } else {
                if (objCount > 0) {
                    var Conform = false;

                    if ($scope.pageNumber != 1) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                $scope.pageNumber = --$scope.pageNumber;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);
                            }
                        });
                    }
                } else {
                    if ($scope.pageNumber == 1)
                        return false;
                    $scope.pageNumber = --$scope.pageNumber;
                    Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id)
                }
            }
        }
    },
    Show_Next_Page: function ($scope, NGCollection, Pk_Id) {
        //************ Dirty Check Purpose *********************//
        var IsError = 0;
        if ($scope.pageNumber != $scope.totalPages) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
                if (objCount == 0)
                    obj > 0 ? IsError = true : false;
            }
            else {
                obj > 0 ? IsError = true : false;
                objCount = 0;
            }
           
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            if (IsError) {
                var Conform = false;
                if ($scope.pageNumber != $scope.totalPages) {
                    if (!$scope.IsSkipFormDirty){
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                if ($scope.pageNumber == $scope.totalPages)
                                    return false;
                                $scope.pageNumber = ++$scope.pageNumber;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);
                            }
                        });
                    } else {
                        if ($scope.pageNumber == $scope.totalPages)
                            return false;
                        $scope.pageNumber = ++$scope.pageNumber;
                        $scope.FillDataToGrid($scope.pageNumber);
                        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        resetCancel($scope);
                    }
                }
            } else {
                if (objCount > 0) {
                    var Conform = false;
                    if ($scope.pageNumber != $scope.totalPages) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                if ($scope.pageNumber == $scope.totalPages)
                                    return false;
                                $scope.pageNumber = ++$scope.pageNumber;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                resetCancel($scope);

                            }
                        });
                    }
                } else {
                    if ($scope.pageNumber == $scope.totalPages)
                        return false;
                    $scope.pageNumber = ++$scope.pageNumber;
                    Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id)
                }
            }
        }
    },
    Show_Last_Page: function ($scope, NGCollection, Pk_Id) {
        //************ Dirty Check Purpose *********************//
        var IsError = 0;
        if ($scope.pageNumber != $scope.totalPages) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);

            if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
                if (objCount == 0)
                    obj > 0 ? IsError = true : false;
            }
            else {
                obj > 0 ? IsError = true : false;
                objCount = 0;
            }
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            if (IsError) {
                var Conform = false;
                if ($scope.pageNumber != $scope.totalPages) {
                if(!$scope.IsSkipFormDirty){
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            $scope.pageNumber = $scope.totalPages;
                            $scope.FillDataToGrid($scope.pageNumber);
                            Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            resetCancel($scope);
                        }
                    });
                }else{
                            $scope.pageNumber = $scope.totalPages;
                            $scope.FillDataToGrid($scope.pageNumber);
                            Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            resetCancel($scope);
                    }
                
                }
            }
            else {
                if (objCount > 0) {
                    var Conform = false;
                    if ($scope.pageNumber != $scope.totalPages) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                $scope.pageNumber = $scope.totalPages;
                                $scope.FillDataToGrid($scope.pageNumber);
                                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            }
                        });
                    }
                } else {
                    if ($scope.pageNumber == $scope.totalPages)
                        return false;
                    $scope.pageNumber = $scope.totalPages;
                    Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                }
            }
        }
    },
    Display_Data: function ($scope, NGCollection) {
        $scope.pageNumberDisplay = $scope.pageNumber;
        $scope.firstRecord = (($scope.pageNumber - 1) * $scope.pageSize) + 1;
        if ((($scope.pageNumber) * $scope.pageSize) <= $scope.GridtotalRecords) {
            $scope.lastRecord = (($scope.pageNumber) * $scope.pageSize);
        }
        else {
            $scope.lastRecord = $scope.GridtotalRecords;
        }
        var firstRecordIndex = $scope.firstRecord - 1;
        var lastRecordIndex = $scope.lastRecord - 1;
        if ($scope.totalPages == 0) { //fix for when page load display records 1 of 1 in add mode
            $scope.totalPages = 1;
            $scope.firstRecord = 0;
        }
    },
    Set_Page: function ($scope, NGCollection, Pk_Id) {
        if ($scope.pageNumberDisplay < 1) {
            $scope.pageNumberDisplay = 1;
        }
        var IsError = 0;
        var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        var obj = Detail_Grid.IsDirty($scope, NGCollection);

        if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
        }
        else {
            obj > 0 ? IsError = true : false;
            objCount = 0;
        }

        if (IsError) {
            var Conform = false;
           
            if ($scope.pageNumberDisplay <= $scope.totalPages) {
                if (!$scope.IsSkipFormDirty) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            $scope.pageNumber = $scope.pageNumberDisplay;
                            $scope.FillDataToGrid($scope.pageNumber);
                            Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            resetCancel($scope);
                        }
                    });
                } else {
                    $scope.pageNumber = $scope.pageNumberDisplay;
                    $scope.FillDataToGrid($scope.pageNumber);
                    Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                    resetCancel($scope);
                }
            }
        }
        else {
            //check wheather the Row 
            $scope.pageNumber = $scope.pageNumberDisplay;
            //var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            if (objCount > 0) {
                var Conform = false;
                if ($scope.pageNumberDisplay <= $scope.totalPages) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            $scope.pageNumberDisplay = $scope.totalPages;
                            $scope.FillDataToGrid($scope.pageNumber);
                            Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        }
                    });
                }
            } else {
                if ($scope.pageNumberDisplay > $scope.totalPages) {
                    $scope.pageNumberDisplay = $scope.totalPages;
                }
                Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
            }
        }


    },
    Set_Pagination_Data: function ($scope, NGCollection, Pk_Id) {
        if (NGCollection != undefined && NGCollection != null) {
            if ($scope.pageNumber == 0) {
                $scope.pageNumber = 1;
            }
            $scope.GridtotalRecords = NGCollection.length;

            if ($scope.GridtotalRecords == 0) {
                return false;
            }
            if ($scope.GridtotalRecords % $scope.pageSize > 0)
                $scope.totalPages = Math.floor($scope.GridtotalRecords / $scope.pageSize) + 1;
            else
                $scope.totalPages = Math.floor($scope.GridtotalRecords / $scope.pageSize);

        }
    },
    Page_Index_Changed: function ($scope, NGCollection, Pk_Id) {
        $scope.pageNumber = 1;
        //************ Dirty Check Purpose *********************//
        var IsError = 0;
        var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        var obj = Detail_Grid.IsDirty($scope, NGCollection);

        if (!$scope.IsAllowToPKValueZero) { // This IsAllowToPKValueZero for some screen need's to add PK_Value 0
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
        }
        else {
            obj > 0 ? IsError = true : false;
            objCount = 0;
        }

        //***************************************Error Block ************************************//
        if (IsError) {
            var Conform = false;
            // if ($scope.GridtotalRecords % $scope.pageSize > 0) {
            if (!$scope.IsSkipFormDirty) {
                bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                    if (Conform) {
                        Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        resetCancel($scope);
                    }
                });
            } else {
                Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                resetCancel($scope);
            }
            
            //}
        } else {
            if (objCount > 0) {
                var Conform = false;
                //if ($scope.GridtotalRecords % $scope.pageSize > 0) {
                bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                    if (Conform) {
                        Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                        $scope.totalPages = Math.floor($scope.GridtotalRecords / $scope.pageSize) + 1
                        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        resetCancel($scope);
                    }
                });
                //}
            } else {
                $scope.totalPages = Math.floor($scope.GridtotalRecords / $scope.pageSize);
                $scope.totalPages = $scope.GridtotalRecords > 0 ? 1 : 0;
                Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
            }
        }
    },
    Validate_Input_User: function ($scope, NGCollection, Pk_Id) {
        var objTotalCount = (Enumerable.From(NGCollection).Where("$." + Pk_Id + " == 0").ToArray().length);
        return objTotalCount;
    },
    Get_Detail_Grid_Data: function ($scope, NGCollection, Pk_Id) {
        //$scope.$emit('myEvent', $scope.pageNumber);
        //$scope.FillDataToGrid("GetData");
        $scope.FillDataToGrid($scope.pageNumber);
        if (($scope.pageNumber * $scope.pageSize) > $scope.GridtotalRecords) {
            $scope.lastRecord = $scope.GridtotalRecords;
        }
        else {
            $scope.lastRecord = $scope.pageNumber * $scope.pageSize;
        }
        Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
    },
    Set_Page_Details: function ($scope, NGCollection, Pk_Id) {
        if ($scope.totalPages < $scope.pageNumberDisplay || $scope.pageNumberDisplay == 0) {

            setTimeout(function () {
                $(".btn btn-primary").focus();
            }, 300);
            bootbox.hideAll();
            bootbox.dialog({
                message: Messages.PAGE_NUMBER_ALERT_MESSAGE,
                onEscape: function () { },
                closeButton: true,
                buttons: {
                    success: {
                        label: "Ok",
                        className: "btn-primary Pagination_Template_Page_No",
                        callback: function (result) {
                            setTimeout(function () {
                                angular.element(document.getElementById("Id_PageNumber")).focus();
                            }, 100);
                        }

                    }
                }
            });

            return false;
        }
        else {
            Detail_Grid.Set_Page($scope, NGCollection, Pk_Id);
        }
    },
    IsDirty: function ($scope, NGCollection) {

        var forms = $('form');
        var controllerElement = document.querySelector('form');
        var maincontrollerScope = angular.element(controllerElement).scope();
        var forms = $('form');
        var _count = 0;
        var _count1 = 0;

        angular.forEach(forms, function (dataq, index) {
            var newValue = maincontrollerScope[dataq.name];
            _count1++;
            if (newValue) {
                if (newValue.$dirty) {
                    _count++;
                }
            }
            if (forms.length == _count1) {
                return _count;
            }
        });
        //resetCancel($scope);
        return _count;
    },
    Set_Collection: function ($scope, OrginalCollection) {
        $scope.Orginal = [];
        var obj = angular.copy(OrginalCollection);
        $scope.Orginal = obj;
    },
    ObjectComparer: function ($scope, CollectionA, CollectionB, Pk_Id) {

        var IsError = false;
        angular.forEach(CollectionA, function (value, key) {
            if (!IsError) {
                var objColumnCollection = Object.keys(CollectionA[0]);
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (i == 0) {
                        var Pk_Value = value[objColumnCollection[i]];
                    }
                    var objA = CollectionA.filter(function (Data) {
                        if (Data[Pk_Id] == Pk_Value) {
                            return Data;
                        };
                    });
                    var objB = CollectionB.filter(function (Data) {
                        if (Data[Pk_Id] == Pk_Value) {
                            return Data;
                        };
                    });
                    if (objA[0][objColumn] != objB[0][objColumn]) {
                        IsError = true;
                        return true; // error show because object's does not match.......
                    }
                }
            }
            else {
                return IsError;
            }
        });
        return IsError;
    },

    Set_Page_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {

        var currentScopeNameList = paramObject.SetPageList.split(',');
        //for example :  currentScopeNameList = "pageNumberDisplay,totalPages,pageNumber";SetPageList
        var pageNumberDisplay = $scope[currentScopeNameList[0]];
        var totalPages = $scope[currentScopeNameList[1]];
        var pageNumber = $scope[currentScopeNameList[2]];
        var scopeNameParamList = paramObject.ResetAllList;

        if (pageNumberDisplay < 1) {
            pageNumberDisplay = 1;
        }
        var IsError = 0;
        var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        var obj = Detail_Grid.IsDirty($scope, NGCollection);
        if (objCount == 0)
            obj > 0 ? IsError = true : false;
        if (IsError) {
            var Conform = false;
            if (pageNumberDisplay <= totalPages) {
                bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                    if (Conform) {
                        pageNumber = pageNumberDisplay;
                        $scope[currentScopeNameList[0]] = pageNumberDisplay;
                        $scope[currentScopeNameList[2]] = pageNumber;
                        $scope.FillDataToGrid(paramObject.FillDataParam);
                        //$scope[currentScopeNameList[0]] = pageNumberDisplay;
                        $scope[currentScopeNameList[1]] = totalPages;
                        //$scope[currentScopeNameList[2]] = pageNumber;
                        Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                        resetCancel($scope);
                    }
                });
            }
        }
        else {
            //check wheather the Row 
            pageNumber = pageNumberDisplay;
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            if (objCount > 0) {
                var Conform = false;
                if (pageNumberDisplay <= totalPages) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            pageNumberDisplay = totalPages;
                            $scope[currentScopeNameList[0]] = pageNumberDisplay;
                            $scope[currentScopeNameList[2]] = pageNumber;
                            $scope.FillDataToGrid(paramObject.FillDataParam);
                            //$scope[currentScopeNameList[0]] = pageNumberDisplay;
                            $scope[currentScopeNameList[1]] = totalPages;
                            //$scope[currentScopeNameList[2]] = pageNumber;
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                        }
                    });
                }
            } else {
                if (pageNumberDisplay > totalPages) {
                    pageNumberDisplay = totalPages;
                }
                $scope[currentScopeNameList[0]] = pageNumberDisplay;
                $scope[currentScopeNameList[1]] = totalPages;
                $scope[currentScopeNameList[2]] = pageNumber;
                Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject);
                //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
            }
        }
    },
    Set_Page_Details_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        var currentScopeNameList = paramObject.SetPageDetailList.split(','); // --> pageNumberDisplay,totalPages
        var pageNumberDisplay = $scope[currentScopeNameList[0]];
        var totalPages = $scope[currentScopeNameList[1]];
        var scopeNameParamList = paramObject.ResetAllList;

        if (totalPages < pageNumberDisplay || pageNumberDisplay == 0) {
            setTimeout(function () {
                $(".btn btn-primary").focus();
            }, 300);
            bootbox.dialog({
                message: Messages.PAGE_NUMBER_ALERT_MESSAGE,
                onEscape: function () { },
                closeButton: true,
                buttons: {
                    success: {
                        label: "Ok",
                        className: "btn-primary Pagination_Template_Page_No",
                        callback: function (result) {
                            setTimeout(function () {
                                angular.element(document.getElementById("Id_PageNumber")).focus();
                            }, 100);
                        }

                    }
                }
            });
            return false;
        }
        else {
            Detail_Grid.Set_Page_Dynamic($scope, NGCollection, Pk_Id, paramObject);
        }
    },
    Page_Index_Changed_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        //for example : PageIndexList = "pageSize,pageNumber,GridtotalRecords,totalPages";
        var currentScopeNameList = paramObject.PageIndexList.split(',');
        var pageSize = $scope[currentScopeNameList[0]];
        var pageNumber = $scope[currentScopeNameList[1]];
        var GridtotalRecords = $scope[currentScopeNameList[2]];
        var totalPages = $scope[currentScopeNameList[3]];
        var scopeNameParamList = paramObject.ResetAllList;
        pageNumber = 1;
        //************ Dirty Check Purpose *********************//
        var IsError = 0;
        var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        var obj = Detail_Grid.IsDirty($scope, NGCollection);
        if (objCount == 0)
            obj > 0 ? IsError = true : false;
        //***************************************Error Block ************************************//
        if (IsError) {
            var Conform = false;
            if (GridtotalRecords % pageSize > 0) {
                bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                    if (Conform) {
                        $scope[currentScopeNameList[0]] = pageSize;
                        $scope[currentScopeNameList[1]] = pageNumber;
                        $scope[currentScopeNameList[2]] = GridtotalRecords;
                        $scope[currentScopeNameList[3]] = totalPages;
                        //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                        Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject)
                        //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                        Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                        resetCancel($scope);
                    }
                });
            }
        } else {
            if (objCount > 0) {
                var Conform = false;
                if (GridtotalRecords % pageSize > 0) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                            $scope[currentScopeNameList[0]] = pageSize;
                            $scope[currentScopeNameList[1]] = pageNumber;
                            $scope[currentScopeNameList[2]] = GridtotalRecords;
                            Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject)
                            totalPages = Math.floor(GridtotalRecords / pageSize) + 1
                            $scope[currentScopeNameList[3]] = totalPages;
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            resetCancel($scope);
                        }
                    });
                }
            } else {
                totalPages = Math.floor(GridtotalRecords / pageSize);
                totalPages = GridtotalRecords > 0 ? 1 : 0;
                $scope[currentScopeNameList[0]] = pageSize;
                $scope[currentScopeNameList[1]] = pageNumber;
                $scope[currentScopeNameList[2]] = GridtotalRecords;
                $scope[currentScopeNameList[3]] = totalPages;
                Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject)
                //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
            }
        }
    },
    Display_Data_Dynamic: function ($scope, NGCollection, scopeNameParamList) {
        //for example : var scopeNameParamList = "pageSize,pageNumber,pageNumberDisplay,GridtotalRecords,firstRecord,lastRecord,totalPages";
        var scopeNameList = scopeNameParamList.split(',');
        var param1, param2, param3, param4, param5, param6, param7;
        param1 = scopeNameList[0];
        param2 = scopeNameList[1];
        param3 = scopeNameList[2];
        param4 = scopeNameList[3];
        param5 = scopeNameList[4];
        param6 = scopeNameList[5];
        param7 = scopeNameList[6];

        var pageSize = $scope[param1];
        var pageNumber = $scope[param2];
        var pageNumberDisplay = $scope[param3];
        var GridtotalRecords = $scope[param4];
        var firstRecord = $scope[param5];
        var lastRecord = $scope[param6];
        var totalPages = $scope[param7];

        pageNumberDisplay = pageNumber;
        firstRecord = ((pageNumber - 1) * pageSize) + 1;
        if (((pageNumber) * pageSize) <= GridtotalRecords) {
            lastRecord = ((pageNumber) * pageSize);
        }
        else {
            lastRecord = GridtotalRecords;
        }
        var firstRecordIndex = firstRecord - 1;
        var lastRecordIndex = lastRecord - 1;
        if (totalPages == 0) { //fix for when page load display records 1 of 1 in add mode
            totalPages = 1;
            firstRecord = 0;
        }
        $scope[param1] = pageSize;
        $scope[param2] = pageNumber;
        $scope[param3] = pageNumberDisplay;
        $scope[param4] = GridtotalRecords;
        $scope[param5] = firstRecord;
        $scope[param6] = lastRecord;
        $scope[param7] = totalPages;
    },
    Show_FirstPage_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        //************ Dirty Check Purpose *********************//
        var pageNumber = $scope[paramObject.FirstPageList];// --> $scope.pageNumber
        var IsError = 0;
        if (pageNumber != 1) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            obj > 0 ? IsError = true : false;
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            var scopeNameParamList = paramObject.ResetAllList;

            if (IsError) {
                var Conform = false;
                if (pageNumber != 1) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            pageNumber = 1;
                            $scope[paramObject.FirstPageList] = pageNumber;
                            $scope.FillDataToGrid(paramObject.FillDataParam);
                            //$scope[paramObject.FirstPageList] = pageNumber;
                            //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            resetCancel($scope);
                        }
                    });
                }
            }
            else {
                if (objCount > 0) {
                    var Conform = false;
                    if (pageNumber != 1) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                pageNumber = 1;
                                $scope[paramObject.FirstPageList] = pageNumber;
                                $scope.FillDataToGrid(paramObject.FillDataParam);
                                //$scope.FillDataToGrid(pageNumber);
                                //$scope[paramObject.FirstPageList] = pageNumber;
                                //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                                resetCancel($scope);
                            }
                        });
                    }
                } else {
                    if (pageNumber == 1)
                        return false;
                    pageNumber = 1;
                    $scope[paramObject.FirstPageList] = pageNumber;
                    Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject)
                }
            }
        }
    },
    Show_Previous_Page_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        //************ Dirty Check Purpose *********************//
        //var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
        //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
        //***************************************Error Block ************************************//
        var pageNumber = $scope[paramObject.FirstPageList];// --> $scope.pageNumber
        var scopeNameParamList = paramObject.ResetAllList;

        var IsError = 0;
        if (pageNumber != 1) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
            if (IsError) {
                var Conform = false;

                if (pageNumber != 1) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            pageNumber = --pageNumber;
                            $scope[paramObject.FirstPageList] = pageNumber;
                            $scope.FillDataToGrid(paramObject.FillDataParam);
                            //$scope.FillDataToGrid(pageNumber);
                            //$scope[paramObject.FirstPageList] = pageNumber;
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            resetCancel($scope);
                        }
                    });
                }
            } else {
                if (objCount > 0) {
                    var Conform = false;

                    if (pageNumber != 1) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                pageNumber = --pageNumber;
                                $scope[paramObject.FirstPageList] = pageNumber;
                                $scope.FillDataToGrid(paramObject.FillDataParam);
                                //$scope.FillDataToGrid(pageNumber);
                                //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                //$scope[paramObject.FirstPageList] = pageNumber;
                                Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                                resetCancel($scope);
                            }
                        });
                    }
                } else {
                    if (pageNumber == 1)
                        return false;
                    pageNumber = --pageNumber;
                    //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id)
                    $scope[paramObject.FirstPageList] = pageNumber;
                    Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject)
                }
            }
        }
    },
    Show_Next_Page_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        //************ Dirty Check Purpose *********************//
        var currentScopeNameList = paramObject.NextPageList.split(','); // --> pageNumber, totalPages
        var pageNumber = $scope[currentScopeNameList[0]];
        var totalPages = $scope[currentScopeNameList[1]];
        var scopeNameParamList = paramObject.ResetAllList;

        var IsError = 0;
        if (pageNumber != totalPages) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            if (IsError) {
                var Conform = false;
                if (pageNumber != totalPages) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            if (pageNumber == totalPages)
                                return false;
                            pageNumber = ++pageNumber;
                            $scope[currentScopeNameList[0]] = pageNumber;
                            $scope.FillDataToGrid(paramObject.FillDataParam);
                            //$scope.FillDataToGrid(pageNumber);
                            //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            //$scope[currentScopeNameList[0]] = pageNumber;
                            $scope[currentScopeNameList[1]] = totalPages;
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            resetCancel($scope);
                        }
                    });
                }
            } else {
                if (objCount > 0) {
                    var Conform = false;
                    if (pageNumber != totalPages) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                if (pageNumber == totalPages)
                                    return false;
                                pageNumber = ++pageNumber;
                                $scope[currentScopeNameList[0]] = pageNumber;
                                $scope.FillDataToGrid(paramObject.FillDataParam);
                                //$scope.FillDataToGrid(pageNumber);
                                //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                //$scope[currentScopeNameList[0]] = pageNumber;
                                $scope[currentScopeNameList[1]] = totalPages;
                                Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                                resetCancel($scope);
                            }
                        });
                    }
                } else {
                    if (pageNumber == totalPages)
                        return false;
                    pageNumber = ++pageNumber;
                    //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id)
                    $scope[currentScopeNameList[0]] = pageNumber;
                    $scope[currentScopeNameList[1]] = totalPages;
                    Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject);
                }
            }
        }
    },
    Show_Last_Page_Dynamic: function ($scope, NGCollection, Pk_Id, paramObject) {
        //************ Dirty Check Purpose *********************//
        var currentScopeNameList = paramObject.NextPageList.split(','); // --> pageNumber, totalPages
        var pageNumber = $scope[currentScopeNameList[0]];
        var totalPages = $scope[currentScopeNameList[1]];
        var scopeNameParamList = paramObject.ResetAllList;

        var IsError = 0;
        if (pageNumber != totalPages) {
            var objCount = Detail_Grid.Validate_Input_User($scope, NGCollection, Pk_Id);
            var obj = Detail_Grid.IsDirty($scope, NGCollection);
            if (objCount == 0)
                obj > 0 ? IsError = true : false;
            //var IsError = Detail_Grid.ObjectComparer($scope, $scope.Orginal, NGCollection, Pk_Id);
            //***************************************Error Block ************************************//
            if (IsError) {
                var Conform = false;
                if (pageNumber != totalPages) {
                    bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                        if (Conform) {
                            pageNumber = totalPages;
                            $scope[currentScopeNameList[0]] = pageNumber;
                            $scope.FillDataToGrid(paramObject.FillDataParam);
                            //$scope.FillDataToGrid(pageNumber);
                            //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                            //$scope[currentScopeNameList[0]] = pageNumber;
                            $scope[currentScopeNameList[1]] = totalPages;
                            Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            resetCancel($scope);
                        }
                    });
                }
            }
            else {
                if (objCount > 0) {
                    var Conform = false;

                    if (pageNumber != totalPages) {
                        bootbox.confirm(Detail_Grid.User_Input_Confirm_Message, function (Conform) {
                            if (Conform) {
                                pageNumber = totalPages;
                                $scope[currentScopeNameList[0]] = pageNumber;
                                $scope.FillDataToGrid(paramObject.FillDataParam);
                                //$scope.FillDataToGrid(pageNumber);
                                //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
                                //$scope[currentScopeNameList[0]] = pageNumber;
                                $scope[currentScopeNameList[1]] = totalPages;
                                Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
                            }
                        });
                    }
                } else {
                    if (pageNumber == totalPages)
                        return false;
                    pageNumber = totalPages;
                    //Detail_Grid.Get_Detail_Grid_Data($scope, NGCollection, Pk_Id);
                    $scope[currentScopeNameList[0]] = pageNumber;
                    $scope[currentScopeNameList[1]] = totalPages;
                    Detail_Grid.Get_Detail_Grid_Data_Dynamic($scope, NGCollection, paramObject);
                }
            }
        }
    },
    Get_Detail_Grid_Data_Dynamic: function ($scope, NGCollection, paramObject) {
        var currectScopeNameList = paramObject.GetGridDataList;
        //for example :  currectScopeNameList = "pageSize,pageNumber,GridtotalRecords,lastRecord";
        var scopeNameList = currectScopeNameList.split(',');
        var pageSize = $scope[scopeNameList[0]];
        var pageNumber = $scope[scopeNameList[1]];
        var GridtotalRecords = $scope[scopeNameList[2]];
        var lastRecord = $scope[scopeNameList[3]];

        $scope.FillDataToGrid(paramObject.FillDataParam);
        if ((pageNumber * pageSize) > GridtotalRecords) {
            lastRecord = GridtotalRecords;
        }
        else {
            lastRecord = pageNumber * pageSize;
        }
        $scope[scopeNameList[0]] = pageSize;
        $scope[scopeNameList[1]] = pageNumber;
        $scope[scopeNameList[2]] = GridtotalRecords;
        $scope[scopeNameList[3]] = lastRecord;
        var scopeNameParamList = paramObject.ResetAllList;
        //Select_Grid.Reset_All_Chk($scope, NGCollection); // these methods comes from Common
        Select_Grid.Reset_All_Chk_Dynamic($scope, NGCollection, scopeNameParamList, paramObject.gridId);
    },


};


/* Common Select All */
Select_Grid = {
    SelectAll: function ($scope, NGCollection) {
        var objTotalCount = (Enumerable.From(NGCollection).ToArray().length);
        var objColumnCollection = Object.keys(NGCollection[0]);
        var _objIsRowDisabled = "IsRowDisabled";
        var _IsBreak = false;
        var objIsRowDisabled = false;
        angular.forEach(NGCollection, function (value, key) {
            if (!$scope.isAllSelected && key != objTotalCount && objTotalCount > 0) {
                $scope.requiredFields = NGCollection;;
                console.log($scope.requiredFields.required)
                // When Selected False Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("Required") != null) {
                        value[objColumnCollection[i]] = false;
                    }

                    if (objColumnCollection[i].match("IsRowDisabled") != null && _IsBreak != true) {
                        objIsRowDisabled = true;
                        _IsBreak = true;
                        break;
                    }
                }
                if (objIsRowDisabled) {
                    if (value[_objIsRowDisabled] == true) {
                        value.IsDeleted = false;
                        $('#del_' + key).removeClass('bgDelete');
                        $('#FileUploaddel_' + key).removeClass('bgDelete');
                        $('#delPartReplacement_' + key).removeClass('bgDelete');
                        $('#delVehicle_' + key).removeClass('bgDelete');

                    }
                    else {
                        value.IsDeleted = !$scope.isAllSelected;
                        $('#del_' + key).addClass('bgDelete');
                        $('#FileUploaddel_' + key).addClass('bgDelete');
                        $('#delPartReplacement_' + key).addClass('bgDelete');
                        $('#delVehicle_' + key).removeClass('bgDelete');
                    }
                }
                else {
                    value.IsDeleted = !$scope.isAllSelected;
                    $('#del_' + key).addClass('bgDelete');
                    $('#FileUploaddel_' + key).addClass('bgDelete');
                    $('#delPartReplacement_' + key).addClass('bgDelete');
                    $('#delVehicle_' + key).addClass('bgDelete');
                }

            }
            else {
                value.IsDeleted = false;
                $('#del_' + key).removeClass('bgDelete');
                $('#FileUploaddel_' + key).removeClass('bgDelete');
                $('#delPartReplacement_' + key).removeClass('bgDelete');
                $('#delVehicle_' + key).removeClass('bgDelete');
                // When Selected True Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("ConditionalRequired") != null) {
                        value[objColumnCollection[i]] = false;
                    }
                    else if (objColumn.match("Required") != null) {
                        value[objColumnCollection[i]] = true;
                    }

                }
            }
        });
    },
    SelectAll_With_Ng_Model: function ($scope, NGCollection, Ng_Model, CssClassName) {
        var objTotalCount = (Enumerable.From(NGCollection).ToArray().length);
        var objColumnCollection = Object.keys(NGCollection[0]);
        var _objIsRowDisabled = "IsRowDisabled";
        var _IsBreak = false;
        var objIsRowDisabled = false;
        angular.forEach(NGCollection, function (value, key) {
            if (!Ng_Model && key != objTotalCount && objTotalCount > 0) {
                $scope.requiredFields = NGCollection;;
                console.log($scope.requiredFields.required)
                // When Selected False Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("Required") != null) {
                        value[objColumnCollection[i]] = false;
                    }
                    if (objColumnCollection[i].match("IsRowDisabled") != null && _IsBreak != true) {
                        objIsRowDisabled = true;
                        _IsBreak = true;
                        break;
                    }
                }
                if (objIsRowDisabled) {
                    if (value[_objIsRowDisabled] == true) {
                        value.IsDeleted = false;
                        //$('#del_' + key).removeClass('bgDelete');
                        //$('#FileUploaddel_' + key).removeClass('bgDelete');
                        $(CssClassName + key).removeClass('bgDelete');
                    }
                    else {
                        value.IsDeleted = !$scope.isAllSelected;
                        //$('#del_' + key).addClass('bgDelete');
                        //$('#FileUploaddel_' + key).addClass('bgDelete');
                        $(CssClassName + key).addClass('bgDelete');
                    }
                }
                else {
                    value.IsDeleted = !$scope.isAllSelected;
                    //$('#del_' + key).addClass('bgDelete');
                    //$('#FileUploaddel_' + key).addClass('bgDelete');
                    $(CssClassName + key).addClass('bgDelete');
                }

            }
            else {
                value.IsDeleted = false;
                //$('#del_' + key).removeClass('bgDelete');
                //$('#FileUploaddel_' + key).removeClass('bgDelete');
                $(CssClassName + key).removeClass('bgDelete');
                // When Selected True Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumn.match("Required") != null) {
                        value[objColumnCollection[i]] = true;
                    }
                }
            }
        });
    },
    SelectAllGridDetails_WithoutPagination: function ($scope, NGCollection, isSelectedAll) {
        var objTotalCount = (Enumerable.From(NGCollection).ToArray().length);
        var objColumnCollection = Object.keys(NGCollection[0]);
        var _objIsRowDisabled = "IsRowDisabled";
        var _IsBreak = false;
        var objIsRowDisabled = false;
        angular.forEach(NGCollection, function (value, key) {
            if (isSelectedAll && key != objTotalCount && objTotalCount > 0) {
                $scope.requiredFields = NGCollection;;

                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("Required") != null) {
                        value[objColumnCollection[i]] = false;
                    }
                    if (objColumnCollection[i].match("IsRowDisabled") != null && _IsBreak != true) {
                        objIsRowDisabled = isSelectedAll;
                        _IsBreak = true;
                        break;
                    }
                }
                if (objIsRowDisabled) {
                    if (value[_objIsRowDisabled] == true) {
                        value.IsDeleted = false;
                        $('#del_' + key).removeClass('bgDelete');
                        $('#FileUploaddel_' + key).removeClass('bgDelete');
                    }
                    else {
                        value.IsDeleted = isSelectedAll;
                        $('#del_' + key).addClass('bgDelete');
                        $('#FileUploaddel_' + key).addClass('bgDelete');
                    }
                }
                else {
                    value.IsDeleted = isSelectedAll;
                    $('#del_' + key).addClass('bgDelete');
                    $('#FileUploaddel_' + key).addClass('bgDelete');
                }

            }
            else {
                value.IsDeleted = false;
                $('#del_' + key).removeClass('bgDelete');
                $('#FileUploaddel_' + key).removeClass('bgDelete');
                // When Selected True Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];

                    if (objColumn.match("Required") != null) {
                        value[objColumnCollection[i]] = true;
                    }
                }
            }
        });
    },
    Reset_All_Items: function ($scope, NGCollection) {
        var objTotalCount = (Enumerable.From(NGCollection).ToArray().length);
        var objColumnCollection = Object.keys(NGCollection[0]);
        $scope.requiredFields = [];
        angular.forEach(NGCollection, function (value, key) {
            value.IsDeleted = false;
            $('#del_' + key).removeClass('bgDelete');
            $('#FileUploaddel_' + key).removeClass('bgDelete');
            for (var i = 0; i < objColumnCollection.length; i++) {
                var objColumn = objColumnCollection[i];
                value["IsDeleted"] = false;
            }
        });
    },
    Deselect_All: function ($scope, NgCollection) {
        var objColumnCollection = Object.keys(NgCollection[0]);
        var objIsRowDisabled = false;
        var _Condition = "";
        for (var i = 0; i < objColumnCollection.length; i++) {
            var objColumn = objColumnCollection[i];
            if (objColumnCollection[i].match("IsRowDisabled") != null) {
                objIsRowDisabled = true;
                _Condition = " && $.IsRowDisabled == false";
                break;
            }
        }
        var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
        if (objIsRowDisabled) {
            var objTotalCount = (Enumerable.From(NgCollection).Where("$.IsRowDisabled == false").ToArray().length);
        }
        else {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
        }
        if (objSelectedCount == objTotalCount) {
            $scope.isAllSelected = true;
        }
        else {
            $scope.isAllSelected = false;
        }
    },
    Deselect_All_Dynamic: function ($scope, NgCollection, paramScopeName) {
        var objColumnCollection = Object.keys(NgCollection[0]);
        var objIsRowDisabled = false;
        var _Condition = "";
        for (var i = 0; i < objColumnCollection.length; i++) {
            var objColumn = objColumnCollection[i];
            if (objColumnCollection[i].match("IsRowDisabled") != null) {
                objIsRowDisabled = true;
                _Condition = " && $.IsRowDisabled == false";
                break;
            }
        }
        var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
        if (objIsRowDisabled) {
            var objTotalCount = (Enumerable.From(NgCollection).Where("$.IsRowDisabled == false").ToArray().length);
        }
        else {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
        }
        if (objSelectedCount == objTotalCount) {
            $scope[paramScopeName] = true;
        }
        else {
            $scope[paramScopeName] = false;
        }
    },
    Deselect_All_Attachments: function ($scope, NgCollection, Ng_Model_Name) {
        var objColumnCollection = Object.keys(NgCollection[0]);
        var objIsRowDisabled = false;
        var _Condition = "";
        for (var i = 0; i < objColumnCollection.length; i++) {
            var objColumn = objColumnCollection[i];
            if (objColumnCollection[i].match("IsRowDisabled") != null) {
                objIsRowDisabled = true;
                _Condition = " && $.IsRowDisabled == false";
                break;
            }
        }
        var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
        if (objIsRowDisabled) {
            var objTotalCount = (Enumerable.From(NgCollection).Where("$.IsRowDisabled == false").ToArray().length);
        }
        else {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
        }
        if (objSelectedCount == objTotalCount) {
            $scope[Ng_Model_Name] = true;
        }
        else {
            $scope[Ng_Model_Name] = false;
        }
    },
    Validate_Ng_Grid_With_Out_Pagination: function (NgCollection, IsCheck) {
        if (IsCheck != false) {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (objSelectedCount == objTotalCount) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                return false;
            }
            else if (objSelectedCount > objTotalCount) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                return false;
            }

            return true;
        } else {
            return true;
        }
    },
    Validate_Ng_Grid: function ($scope, NgCollection, IsCheck, PK_Id) {
        if (IsCheck != false) {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
            var objEmptyRecordsCount = (Enumerable.From(NgCollection).Count("$. " + PK_Id + " == 0"));
            var gridTotalRecord = (PK_Id == "AttachId") ? $scope.GridtotalRecordsFile : $scope.GridtotalRecords;
            var isTrue = (PK_Id == "AttachId") ? $scope.IsAtttachmentSelected : $scope.isAllSelected;
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (isTrue) {
                if (objSelectedCount == (gridTotalRecord + objEmptyRecordsCount)) {
                    bootbox.alert("Sorry!. You cannot delete all rows");
                    return false;
                }
                //else if (objSelectedCount == objTotalCount) {// to navigate to previous page after deleting all records in current page
                //    if($scope.pageNumber == 1){
                //        $scope.pageNumber = 1;
                //    }
                //    else{
                //        $scope.pageNumber = $scope.pageNumber - 1;
                //    }
                //}
            }
            return true;
        } else {
            return true;
        }
    },
    Validate_Ng_Grid_Dynamic: function ($scope, NgCollection, IsCheck, PK_Id, param, totalCount) {
        var isAllSelected = $scope[param];
        var GridtotalRecords = $scope[totalCount];
        if (IsCheck != false) {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
            var objEmptyRecordsCount = (Enumerable.From(NgCollection).Count("$. " + PK_Id + " == 0"));
            var gridTotalRecord = GridtotalRecords;
            var isTrue = isAllSelected;
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (isTrue) {

                if (totalCount == '' && objSelectedCount == objTotalCount) {
                    bootbox.alert("Sorry!. You cannot delete all rows");
                    return false;
                }
                else if (objSelectedCount == (gridTotalRecord + objEmptyRecordsCount)) {
                    bootbox.alert("Sorry!. You cannot delete all rows");
                    return false;
                }
                //else if (objSelectedCount == objTotalCount) {// to navigate to previous page after deleting all records in current page
                //    if($scope.pageNumber == 1){
                //        $scope.pageNumber = 1;
                //    }
                //    else{
                //        $scope.pageNumber = $scope.pageNumber - 1;
                //    }
                //}
            }
            return true;
        } else {
            return true;
        }
    },
    Validate_Ng_GridAtachment: function (NgCollection, IsCheck) {
        if (IsCheck != false) {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (objSelectedCount == objTotalCount) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                return false;
            }
            else if (objSelectedCount > objTotalCount) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                return false;
            }
            return true;
        } else {
            return true;
        }

    },
    DeleteAll_Ng_Grid: function (NgCollection, IsCheck, TotalRecords) { //NgCollection- Collection of object's ,TotalRecords - No of table records.
        if (IsCheck != false) {
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (objSelectedCount == TotalRecords) {
                bootbox.alert("Sorry!. You cannot delete all rows");
                return false;
            }
            return true;
        } else {
            return true;
        }

    },
    Reset_All_Chk: function ($scope, NgCollection) {
        $scope.isAllSelected = false;
        angular.forEach(NgCollection, function (value, key) {
            if (value != null) {
                value.IsDeleted = false;
                $('#del_' + key).removeClass('bgDelete');
                $('#FileUploaddel_' + key).removeClass('bgDelete');
            }
        });
        if (($scope.pageNumber * $scope.pageSize) > $scope.GridtotalRecords) {
            $scope.lastRecord = $scope.GridtotalRecords;
        }
        else {
            $scope.lastRecord = $scope.pageNumber * $scope.pageSize;
        }
    },
    Navigate_Ng_Grid: function ($scope, NgCollection, IsCheck, PK_Id) {
        if (IsCheck != false) {
            var objTotalCount = (Enumerable.From(NgCollection).ToArray().length);
            var objEmptyRecordsCount = (Enumerable.From(NgCollection).Count("$. " + PK_Id + " == 0"));
            var objSelectedCount = (Enumerable.From(NgCollection).Where("$.IsDeleted == true").ToArray().length);
            if (objTotalCount == objSelectedCount) {// to navigate to previous page after deleting all records in current page
                if ($scope.pageNumber == 1) {
                    $scope.pageNumber = 1;
                }
                else {
                    $scope.pageNumber = $scope.pageNumber - 1;
                }
            }
        }
    },
    SelectAllDynamic: function ($scope, NGCollection, paramScopeName, gridId) {
        var scopeNameValue = $scope[paramScopeName]; //$scope.isAllSelected 
        var objTotalCount = (Enumerable.From(NGCollection).ToArray().length);
        var objColumnCollection = Object.keys(NGCollection[0]);
        var _objIsRowDisabled = "IsRowDisabled";
        var _IsBreak = false;
        var objIsRowDisabled = false;
        angular.forEach(NGCollection, function (value, key) {
            if (!scopeNameValue && key != objTotalCount && objTotalCount > 0) {
                $scope.requiredFields = NGCollection;
                console.log($scope.requiredFields.required)
                // When Selected False Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("Required") != null) {
                        value[objColumnCollection[i]] = false;
                    }
                    if (objColumnCollection[i].match("IsRowDisabled") != null && _IsBreak != true) {
                        objIsRowDisabled = true;
                        _IsBreak = true;
                        break;
                    }
                }
                if (objIsRowDisabled) {
                    if (value[_objIsRowDisabled] == true) {
                        value.IsDeleted = false;
                        $(gridId + key).removeClass('bgDelete');
                    }
                    else {
                        value.IsDeleted = !scopeNameValue;
                        $(gridId + key).addClass('bgDelete');
                    }
                }
                else {
                    value.IsDeleted = !scopeNameValue;
                    $(gridId + key).addClass('bgDelete');
                    //$('#FileUploaddel_' + key).addClass('bgDelete');
                }
            }
            else {
                value.IsDeleted = false;
                $(gridId + key).removeClass('bgDelete');
                //$('#FileUploaddel_' + key).removeClass('bgDelete');
                // When Selected True Required Fields 
                for (var i = 0; i < objColumnCollection.length; i++) {
                    var objColumn = objColumnCollection[i];
                    if (objColumnCollection[i].match("ConditionalRequired") != null) {
                        value[objColumnCollection[i]] = false;
                    }
                    else if (objColumn.match("Required") != null) {
                        value[objColumnCollection[i]] = true;
                    }
                }
            }
            $scope[paramScopeName] = scopeNameValue;
        });
    },
    Reset_All_Chk_Dynamic: function ($scope, NgCollection, scopeNameParamList, gridId) {
        //for example : var scopeNameParamList = "isAllSelected,pageSize,pageNumber,GridtotalRecords,lastRecord";
        var scopeNameList = scopeNameParamList.split(',');
        var param1, param2, param3, param4, param5;
        param1 = scopeNameList[0];
        param2 = scopeNameList[1];
        param3 = scopeNameList[2];
        param4 = scopeNameList[3];
        param5 = scopeNameList[4];

        $scope[param1] = false; //$scope.isAllSelected = false;
        var pageSize = $scope[param2];
        var pageNumber = $scope[param3];
        var GridtotalRecords = $scope[param4];
        var lastRecord = $scope[param5];

        angular.forEach(NgCollection, function (value, key) {
            if (value != null) {
                value.IsDeleted = false;
                $(gridId + key).removeClass('bgDelete');
            }
        });
        if ((pageNumber * pageSize) > GridtotalRecords) {
            lastRecord = GridtotalRecords;
        }
        else {
            lastRecord = pageNumber * pageSize;
        }
        $scope[param2] = pageSize;
        $scope[param3] = pageNumber;
        $scope[param4] = GridtotalRecords;
        $scope[param5] = lastRecord;
    },
};

/*Common Actions */
Actions = {
    ADD: "ADD",
    EDIT: "EDIT",
    VIEW: "VIEW"
};

/* Message Status */
CURD_MESSAGE_STATUS = {
    //Save Success
    SS: 'SS',
    //Update Success
    US: 'US',
    // Delete Success
    DS: 'DS',
    // Save Failure
    SF: 'SF',
    // Update Failure
    UF: 'UF',
    // Delete Failure
    DF: 'DF',
    //Copy
    CS: 'CS',
    CF: 'CF',
    //Save Sucess -- User Registration
    RS: 'RS',
    //Mail Sent Successfully
    MS: 'MS',
    //Given Message Display
    MD: 'MD',
    //File Upload message
    FS: 'FS',
    //Email Send message
    ES: 'ES',
    //Authorized Succesfully
    AS: 'AS',
    //Rejected Succesfully
    RS: 'RS',
    // File Uploaded Successfully
    FUS: 'FUS',
    //Typecode deleted 
    TC: 'TC_Delete',
    //For Test paramter deletion
    TESTTYPE: 'TT',
    //AssetTypeCode GM
    ATC: 'ATC',
    //Record Already in Use, cannot delete in search grid
    RAU: 'RAU',
    //User unblocked successfully
    UUB: 'UUB',
    //Selected Role Already Exists
    SRE: 'SRE',
    //Selected User Already Exists
    SUE: 'SUE',
    //Selected Role Already Exists in 'To'
    SRET: 'SRET',
    //Selected User Already Exists in 'To'
    SUET: 'SUET',
    //User Already Added
    UAA: 'UAA',
    //Nothing to Add
    NA: 'NA',
    //No Data Found
    NDF: 'NDF',
    //Cannot add 'Cc'
    CACC: 'CACC',
    //Message Acknowledged
    MA: 'MA',
    //Password Changed
    PC: 'PC',
    //Date Import
    IM: 'IM',
    // rejected sucessfully
    RJS: 'RJS',
    // reqeusted sucessfully
    RJS: 'RQS',
    // Approved sucessfully
    RJS: 'APS'
}


function showMessage(record, Action) {

    $("#top-notifications").modal('show');
    switch (Action) {
        case CURD_MESSAGE_STATUS.PC:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Password Changed Successfully!");
            break;
        case CURD_MESSAGE_STATUS.UUB:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("The user has been unblocked successfully");
            break;
        case CURD_MESSAGE_STATUS.SS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Data saved successfully");
            break;
        case CURD_MESSAGE_STATUS.US:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Data saved successfully");
            break;
        case CURD_MESSAGE_STATUS.MS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Mail sent successfully");
            break;
        case CURD_MESSAGE_STATUS.DS:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').removeClass("glyphicon glyphicon-remove");
            $('#msg').addClass("fa fa-times");
            $('#msg').addClass("success");
            $('#hdr1').html("Record deleted successfully");
            break;
        case CURD_MESSAGE_STATUS.CNS:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').removeClass("glyphicon glyphicon-remove");
            $('#msg').addClass("fa fa-times");
            $('#msg').addClass("success");
            $('#hdr1').html("Record cancelled successfully");
            break;
        case CURD_MESSAGE_STATUS.CS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            // $("#data1").html("Record Copied");
            $('#hdr1').html("Data copied successfully");
            break;

        case CURD_MESSAGE_STATUS.SF:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            //$("#data1").html("Record could not be saved");
            $('#hdr1').html("Save Failure!");
            break;

        case CURD_MESSAGE_STATUS.UF:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            //$("#data1").html("Record could not be saved!");
            $('#hdr1').html("Save Failure!");
            break;

        case CURD_MESSAGE_STATUS.DF:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').removeClass("fa fa-times");
            $('#msg').addClass("glyphicon glyphicon-remove");
            // $("#data1").html("Record could not be deleted!"); //Delete Failure!
            //$('#hdr1').html("Record could not be deleted as it is in use!");
            $('#hdr1').html("Record cannot be deleted as it is referred in another record");
            break;

        case CURD_MESSAGE_STATUS.CF:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            // $("#data1").html("Record could not be Copied!");
            $('#hdr1').html("No records available for the previous year");
            break;

        case CURD_MESSAGE_STATUS.WM:
            $('#msg').addClass("warning");
            // $("#data1").html(record);
            $('#hdr1').html("Data not Processed!");
            break;

        case CURD_MESSAGE_STATUS.RS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");
            $('#hdr1').html("User(s) Registered Successfully");
            break;

        case CURD_MESSAGE_STATUS.MD:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            // $("#data1").html(record);
            $('#hdr1').html(record);
            break;
        case CURD_MESSAGE_STATUS.FS:
            $$('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");

            $('#hdr1').html("File Uploaded Successfully");
            break;
        case CURD_MESSAGE_STATUS.ES:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");
            $('#hdr1').html("Email Sent Successfully");
            break;
        case CURD_MESSAGE_STATUS.AS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");

            $('#hdr1').html("Authorized Successfully");
            break;
        case CURD_MESSAGE_STATUS.RS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");
            $('#hdr1').html("Rejected Successfully");
            break;

        case CURD_MESSAGE_STATUS.FUS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            //$("#data1").html("Record saved");
            $('#hdr1').html("Uploaded Successfully");
            break;
        case CURD_MESSAGE_STATUS.TESTTYPE:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Test Type  already in use and cannot be deleted.");
            break;
        case CURD_MESSAGE_STATUS.ATC:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("Record cannot be deleted as it is referred in another record");
            break;
        case CURD_MESSAGE_STATUS.RAU:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            //$('#hdr1').html("This Asset Type Code already in use and cannot be deleted.");
            $('#hdr1').html("This " + record + " already in use and cannot be deleted");
            break;
        case CURD_MESSAGE_STATUS.SUE:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>Selected User Already Exists");
            break;
        case CURD_MESSAGE_STATUS.SRE:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>Selected Role Already Exists");
            break;
        case CURD_MESSAGE_STATUS.SRET:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>Role Already Added in 'To/Cc' List");
            break;
        case CURD_MESSAGE_STATUS.SUET:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>User(s) Already Added in 'To/Cc' List");
            break;
        case CURD_MESSAGE_STATUS.UAA:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>User(s) Already Added");
            break;
        case CURD_MESSAGE_STATUS.NA:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>User(s) Not Selected");
            break;
        case CURD_MESSAGE_STATUS.NDF:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>No Data Found");
            break;
        case CURD_MESSAGE_STATUS.CACC:
            $('#msg').removeClass("fa fa-check"); //ERROR
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("<br>Cannot Save 'Cc' with 'To' as Empty");
            break;
        case CURD_MESSAGE_STATUS.MA:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("<br>Message Acknowledged");
            break;
        case CURD_MESSAGE_STATUS.IM:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            $('#msg').addClass("fa fa-check");
            $('#hdr1').html("Data Upload Successfully");
            break;

        case CURD_MESSAGE_STATUS.RJS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            // $('#msg').addClass("fa fa-check");
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("Rejected Successfully");
            break;
        case CURD_MESSAGE_STATUS.RQS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            // $('#msg').addClass("fa fa-check");
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("Requested Successfully");
            break;
        case CURD_MESSAGE_STATUS.APS:
            $('#msg').removeClass("fa fa-times"); //SUCCESS
            // $('#msg').addClass("fa fa-check");
            $('#msg').addClass("fa fa-times");
            $('#hdr1').html("Approved Successfully");
            break;
    }

    setTimeout(function () {
        $("#top-notifications").modal('hide');
    }, 1500);

    $('#myPleaseWait').modal('hide');
}


function ShowStatusMessage(Action) {
    var screenName = $("#menu").find("li.active:last").text();
    showMessage(screenName, Action);
}
//function IsDataSaved(){
//  var qs = window.location.href;
//    if (qs != null && qs.split('?').length > 1) {
//        qs = qs.split('?')[1].split('=');
//        if (qs[0] == 'op') {
//            switch (qs[1]) {
//                case 's':
//                  return  true;
//                    break;
//            } 
//        }
//     }
//}


function IsDataSaved() {
    var qs = window.location.href;
    //var href = $("#menu").find("li.active:last").find('a').attr('href').replace('/index', '');
    var href = $("#menu").find("li.active:last").find('a').attr('onclick').replace("MenuClickAlert('", '').replace("')", '').replace('/index', '');
    var hrefsplitUp = href.split("/");
    var hrefLength = hrefsplitUp.length;
    var controllerName = hrefsplitUp[hrefLength - 1];
    var isCookieAvailable = Cookies.get(controllerName);
    Cookies.remove(controllerName);
    if (isCookieAvailable != undefined) {
        return true;
    }
    else
        return false;
}



$.ShowMessage = function () {

    $('#myPleaseWait').modal('hide');
    $("#top-notifications").modal('show');
    setTimeout(function () {
        $("#top-notifications").modal('hide');
        $.ResetMessage();
    }, 5000);
}

$.SetMessage = function (headerText, bodyText) {
    if ((headerText != "" && headerText != null) || (bodyText != "" && !bodyText)) {
        $('#hdr1').html(headerText);
        $("#data1").html(bodyText);
    }
}

$.ResetMessage = function () {
    $('#hdr1').html('');
    $("#data1").html('');
}

/*on cancel click
    href  - Static
*/
function cancelClick(href, actionType) {
    //$('form').trigger('rescan.areYouSure');
    //$('form').trigger('checkform.areYouSure');
    //$('form').areYouSure({ 'addRemoveFieldsMarksDirty': true });

    var isDirty = $('form').hasClass('dirty');
    if (actionType.toUpperCase() !== Actions.VIEW && isDirty) {
        bootbox.dialog({
            message: "Record(s) not Saved/Updated. Do you want to continue?",
            onEscape: function () { },
            closeButton: true,
            buttons: {
                success: {
                    label: "Yes",
                    className: "btn-primary",
                    callback: function (result) {
                        if (result) {
                            window.location.href = href;
                        }
                    }

                },
                "No": {
                    className: "btn-grey",
                    callback: function () { }

                },
            }
        });
    }
    else {
        window.location.href = href;
    }
};

/*on cancel click
   href  - Dynamic
*/
function redirectToLandingScreen($scope) {
    //var href = $("#menu").find("li.active:last").find('a').attr('href').replace('/index', '');
    var href = $("#menu").find("li.active:last").find('a').attr('onclick').replace("MenuClickAlert('", '').replace("')", '').replace('/index', '');
    var forms = $('form');
    var _count = 0;
    var _count1 = 0;

    angular.forEach(forms, function (data, index) {
        $scope.$watch(data.name, function (form) {
            _count1++;
            if (form) {
                if (form.$dirty) {
                    _count++;
                    //alert("true");
                }
                //else{
                //alert("false");
                //}
            }
            if (forms.length == _count1) {
                if (_count > 0) {
                    bootbox.dialog({
                        message: "Record(s) not Saved/Updated. Do you want to continue?",
                        onEscape: function () { },
                        closeButton: true,
                        buttons: {
                            success: {
                                label: "Yes",
                                className: "btn-primary",
                                callback: function (result) {
                                    if (result) {
                                        //window.location.href = href;
                                        CheckMultipleTabs(href);
                                    }
                                }

                            },
                            "No": {
                                className: "btn-grey",
                                callback: function () { }

                            },
                        }
                    });
                }
                else {
                    //window.location.href = href;
                    CheckMultipleTabs(href);
                }
            }
        });

    });
}

function redirectToDashboard($scope) {
    //var href = $("#menu").find("li.active:last").find('a').attr('href').replace('/index', '');
    var href = $("#menu").find("li.active:last").find('a').attr('onclick').replace("MenuClickAlert('", '').replace("')", '').replace('/index', '');
    var forms = $('form');
    var _count = 0;
    var _count1 = 0;
    angular.forEach(forms, function (data, index) {
        $scope.$watch(data.name, function (form) {
            _count1++;
            if (form) {
                if (form.$dirty) {
                    _count++;
                    //alert("true");
                }
                //else{
                //alert("false");
                //}
            }
            if (forms.length == _count1) {
                if (_count > 0) {
                    bootbox.dialog({
                        message: "Record(s) not Saved/Updated. Do you want to continue?",
                        onEscape: function () { },
                        closeButton: true,
                        buttons: {
                            success: {
                                label: "Yes",
                                className: "btn-primary",
                                callback: function (result) {
                                    if (result) {
                                        //alert(href.split('/')[0]);
                                        //window.location.href = "/" + href.split('/')[1];
                                        var href1 = "/" + href.split('/')[1];
                                        CheckMultipleTabs(href1);
                                    }
                                }
                            },
                            "No": {
                                className: "btn-grey",
                                callback: function () { }

                            },
                        }
                    });
                }
                else {
                    //window.location.href = "/" + href.split('/')[1];
                    var href1 = "/" + href.split('/')[1];
                    CheckMultipleTabs(href1);
                }
            }
        });

    });
}
function reloadSameScreen($scope) {
    //var href = $("#menu").find("li.active:last").find('a').attr('href').replace('/index', '');
    //var href = $("#menu").find("li.active:last").find('a').attr('onclick').replace("MenuClickAlert('", '').replace("')", '').replace('/add', '');
    var forms = $('form');
    var _count = 0;
    var _count1 = 0;

    angular.forEach(forms, function (data, index) {
        var form = $scope[data.name];
        //$scope.$watch(data.name, function (form) {
        _count1++;
        if (form) {
            if (form.$dirty) {
                _count++;
                //alert("true");
            }
            //else{
            //alert("false");
            //}
        }
        if (forms.length == _count1) {
            if (_count > 0) {
                bootbox.dialog({
                    message: "Record(s) not Saved/Updated. Do you want to continue?",
                    onEscape: function () { },
                    closeButton: true,
                    buttons: {
                        success: {
                            label: "Yes",
                            className: "btn-primary",
                            callback: function (result) {
                                if (result) {
                                    window.location.reload(true);
                                }
                            }

                        },
                        "No": {
                            className: "btn-grey",
                            callback: function () { }

                        },
                    }
                });
            }
            else {
                window.location.reload(true);
            }
        }
        //});


    });
}

// For Service work unscheduled add new redirected from Service request screen.
function reloadServiceWorkScreen($scope) {
    var forms = $('form');
    var _count = 0;
    var _count1 = 0;

    angular.forEach(forms, function (data, index) {
        var form = $scope[data.name];
        //$scope.$watch(data.name, function (form) {
        _count1++;
        if (form) {
            if (form.$dirty) {
                _count++;
                //alert("true");
            }
            //else{
            //alert("false");
            //}
        }
        if (forms.length == _count1) {
            if (_count > 0) {
                bootbox.dialog({
                    message: "Record(s) not Saved/Updated. Do you want to continue?",
                    onEscape: function () { },
                    closeButton: true,
                    buttons: {
                        success: {
                            label: "Yes",
                            className: "btn-primary",
                            callback: function (result) {
                                if (result) {
                                    window.location.reload(true);
                                }
                            }

                        },
                        "No": {
                            className: "btn-grey",
                            callback: function () { }

                        },
                    }
                });
            }
            else {
                window.location.href = "/FEMS/ServiceWorkUnscheduled/Add";
            }
        }
        //});


    });
}

//Cancel Reset on success call back

function resetCancel($scope) {
    var forms = $('form');
    angular.forEach(forms, function (data, index) {
        //$scope.$watch(data.name, function (form) {
        var form = $scope[data.name];
        if (form) {
            if (form.$dirty) {
                form.$dirty = false;
                form.$invalid = true;
                form.$setPristine();
            }
        }
        //});

    });
}

/*
      Redirect To Landing screen on Save for Transcaction
*/
function redirectToLandingScreenOnSave() {
    //var href = $("#menu").find("li.active:last").find('a').attr('href').replace('/index', '');
    var href = $("#menu").find("li.active:last").find('a').attr('onclick').replace("MenuClickAlert('", '').replace("')", '').replace('/index', '');
    var hrefsplitUp = href.split("/");
    var hrefLength = hrefsplitUp.length;
    var controllerName = hrefsplitUp[hrefLength - 1];
    Cookies.set(controllerName, controllerName);
    href = href + "?op=s";
    window.location.href = href;
}
document.addEventListener('keydown', function (e) {
    e = e || event;
    if (e.keyCode == 9) {
        $(".UlFetch").hide();
    }
});

//document.addEventListener('contextmenu', function (ev) {
//    var htmlContent = [ev.target][0];
//    if ($(htmlContent).attr("href") != "#") {
//        $(htmlContent).attr("href", "#");
//    }
//    var menlink = $(htmlContent).attr("onclick");
//    if (menlink != undefined) {
//        var href = menlink.replace("MenuClickAlert('", '');
//        href = href.replace("')", '');
//        $(htmlContent).attr("href", href);
//        setTimeout(function () {
//            $(htmlContent).attr("href", "#");
//        });
//    }
//    return false;
//}, false);


//$(document).ready(function () {
//    companyIdMt = $('#CompanyId').val();
//    hospitalIdMt = $('#HospitalId').val();
//    serviceIdMt = $('#moduleServiceId').val();
//    //exportUrl = "/api/common/export" + "?companyIdInTab=" + companyId + "&hospitalIdInTab=" + hospitalId + "&serviceIdInTab=" + serviceId;

//    //companyIdStringMt = (companyId == undefined || companyId == null) ? "0" : companyId.toString();
//    //hospitalIdStringMt = (hospitalId == undefined || hospitalId == null) ? "0" : hospitalId.toString();
//    //serviceIdStringMt = (serviceId == undefined || serviceId == null) ? "0" : serviceId.toString();

//});

var ViewScreen = { FEMS_DAR: 663, BEMS_DAR: 664, FMS_DAR: 657, LLS_DAR: 660, CLS_DAR: 659, HWMS_DAR: 658, Summary_DAR: 662 };
var ViewScreenMenuId = [ 663,  664, 657,660, 659,658, 662];

function MenuClickAlert(href) {
    var ScreenId = parseInt($("#screenIdforDocument").val());
    if (localStorage) {
        var id = parseInt($("#screenIdforDocument").val());
        var sd = JSON.parse(localStorage.getItem('sessData')); //Getting localstorage data values.
        var dv = JSON.parse(localStorage.getItem('defaultData')); //Getting localstorage data values.
        if (sd != null) { // Set jqgrid search filter stored in localstorage.screens wise
            var objIndex = findIndex(sd, id);// sd.findIndex((obj => obj.MenuId == id));//Find index of specific object using findIndex method.
            if (objIndex > -1) {
                sd.splice(objIndex, 1);
                localStorage.setItem('sessData', JSON.stringify(sd));
            }
        }
        if (dv != null) { // Default jqgrid filter stored in localstorage.
            var objIndex = findIndex(dv, id);// dv.findIndex((obj => obj.MenuId == id));//Find index of specific object using findIndex method.
            if (objIndex > -1) {
                dv.splice(objIndex, 1);
                localStorage.setItem('defaultData', JSON.stringify(dv));
            }
        }
    }
    var val = window.event || $(window).click(function (val) { return val.event });
    if (val.ctrlKey == true || (val.which == 2 && val.target.tagName == "A")) {
        var htmlContent = [val.target][0];
        if ($(htmlContent).attr("href") != "#") {
            $(htmlContent).attr("href", "#");
        }
        var href = $([val.target][0]).attr("onclick").replace("MenuClickAlert('", '');
        href = href.replace("')", '');
        $(htmlContent).attr("href", href);
        setTimeout(function () {
            $(htmlContent).attr("href", "#");
        });
        return;
    }
    $('.UlFetch').hide();
    if (href != "#") {
        var forms = $('form');
        var controllerElement = document.querySelector('form');
        var maincontrollerScope = angular.element(controllerElement).scope();
        var forms = $('form');
        var _count = 0;
        var _count1 = 0;
        angular.forEach(forms, function (dataq, index) {
            var newValue = maincontrollerScope[dataq.name];
            _count1++;
            if (newValue) {
                if (newValue.$dirty) {
                    _count++;
                }
            }
            if (forms.length == _count1) {
                var ViewScreenCount = Enumerable.From(ViewScreenMenuId).Where("X=>X==" + ScreenId).Count();
                if (_count > 0 && ViewScreenCount==0) {
                    // MASTER_RESULT = false;
                    bootbox.dialog({
                        message: "You have unsaved changes on this page. Do you want to continue?",
                        //message: "Record(s) not Saved/Updated. Do you want to continue?",
                        onEscape: function () { },
                        closeButton: true,
                        buttons: {
                            success: {
                                label: "Yes",
                                className: "btn-primary",
                                callback: function (result) {
                                    if (result) {
                                        //MASTER_RESULT = true;
                                        //window.location.href = href;
                                        CheckMultipleTabs(href)
                                    }
                                }

                            },
                            "No": {
                                className: "btn-grey",
                                callback: function () {
                                    //MASTER_RESULT = false;
                                }
                            },
                        }
                    });
                }
                else {
                    // MASTER_RESULT = true;
                    //window.location.href = href;
                    CheckMultipleTabs(href)
                }
            }
        });
        if (forms.length == 0)
            // window.location.href = href;
            CheckMultipleTabs(href)
    }
}

function CheckMultipleTabs(href) {
    var companyIdMt = $('#CompanyId').val();
    var hospitalIdMt = $('#HospitalId').val();
    var serviceIdMt = $('#moduleServiceId').val();

    if (!(companyIdMt == undefined && hospitalIdMt == undefined && serviceIdMt == undefined)) {
        if (companyIdMt == "") companyIdMt = "0";
        if (hospitalIdMt == "") hospitalIdMt = "0";
        if (serviceIdMt == "") serviceIdMt = "0";
        var checkUrl = "/api/common/multipleTabCheck" + "?companyIdInTab=" + companyIdMt + "&hospitalIdInTab=" + hospitalIdMt + "&serviceIdInTab=" + serviceIdMt;
        var jqxhr = $.post(checkUrl, function () {
        })
      .done(function () {
          window.location.href = href;
      })
        .fail(function (obj) {
            if (obj.status == 409) {
                window.location.href = "/account/Logout";
            }
            else {
                window.location.href = "/home?r=mts";
            }
        })
    }
    else {
        window.location.href = href;
    }
}

function deleteRecordConfirmation(id, code, description, gridId) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = Messages.SEARCH_GRID_DELETE_CONFIRMATION + code + " - " + description + "?";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById(gridId)).scope().setdeleteid(id);
        }
    });
}

function TicketEdit(id, code, description, gridId) {

        angular.element(document.getElementById('gridTable')).scope().PopupShowEventCopy(id,code);
}
function TicketDelete(id, code, description, gridId) {
    var message = "Selected option will delete all file types for " + code + "." + " Confirm to proceed!";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById('gridTable')).scope().DeleteTickets(id);
        }
    });
    
}

function deleteRecordConfirmationwithchild(id, code, description, gridId, service) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = "Selected option will delete all file types for " + service + "." + " Confirm to proceed!";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById(gridId)).scope().setdeleteid(id);
        }
    });
}
function deleteRecordConfirmationVehicle(id, gridId, service) {
    var message = "Selected option will delete all license for vehicle no - " + service + "." + " Confirm to proceed!";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById(gridId)).scope().setdeleteid(id);
        }
    });
}
function deleteRecordConfirmationStockAdjustment(id, code, description, gridId, adjustmentDate) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }

    //var a = (adjustmentDate.substring(0, 10));
    //var year = adjustmentDate.getFullYear();
    //var month = adjustmentDate.getMonth() + 1;
    // var day = adjustmentDate.getDay();

    var adjustmentdate = new Date((parseInt(adjustmentDate.split(' ')[0].split('/')[2])),
                  (parseInt(adjustmentDate.split(' ')[0].split('/')[1]) - 1),
                 (parseInt(adjustmentDate.split(' ')[0].split('/')[0])));


    var year = adjustmentdate.getFullYear();
    var month = Computemonth(adjustmentdate.getMonth());
    var day = adjustmentdate.getDate();

    var _Date = day + "-" + month + '-' + year;


    var message = "Selected option will delete all Part No for " + _Date + "." + " Confirm to proceed!";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById(gridId)).scope().setdeleteid(id);
        }
    });
}

function deleteRecordConfirmationTreatmentFacilityDetails(id, code, description, gridId, WasteTypeLov) {
    if (code.length > 30) {
        code = code.substring(0, 30);
    }
    if (description.length > 30) {
        description = description.substring(0, 30) + '...';
    }
    var message = "Selected option will delete all file types for " + WasteTypeLov + "." + " Confirm to proceed!";
    bootbox.confirm(message, function (result) {
        if (result) {
            angular.element(document.getElementById(gridId)).scope().setdeleteid(id);
        }
    });
}

var Computemonth = function (month) {




    switch (month) {
        case 0:
            return 'Jan';

        case 1:
            return 'Feb';

        case 2:
            return 'Mar';

        case 3:
            return 'Apr';
        case 4:
            return 'May';

        case 5:
            return 'Jun';
        case 6:
            return 'Jul';

        case 7:
            return 'Aug';
        case 8:
            return 'Sep';

        case 9:
            return 'Oct';
        case 10:
            return 'Nov';

        case 11:
            return 'Dec';



    }
}

var ConvertDate = function (strDate) {

    if (strDate && strDate.trim()) {
        return new Date((parseInt(strDate.split(' ')[0].split('/')[2])), (parseInt(strDate.split(' ')[0].split('/')[1]) - 1), (parseInt(strDate.split(' ')[0].split('/')[0])));
    } else {
        return new Date();
    }
}

function findIndex(arrlst,id) {
    var index = -1;
    for (var i = 0; i < arrlst.length; i++) {
        if (arrlst[i].MenuId == id) {
            index = i;
            return index;
        }
    }
    return index;
}
