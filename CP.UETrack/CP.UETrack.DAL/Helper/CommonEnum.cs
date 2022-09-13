namespace CP.UETrack.DAL.Helper
{
    public enum LovEnum
    {
        Physical = 891,                  //lovkey='SamplingEnvironmentValue'
        Chemical = 892,                  //lovkey='SamplingEnvironmentValue'
        Biological = 893,                //lovkey='SamplingEnvironmentValue'
        Ventilation = 4524,              //lovkey='SamplingEnvironmentValue'

        Active = 413,                     //lovkey='StatusValue'
        Inactive = 414,                  //lovkey='StatusValue'

        SpecificationMin = 4526,         //lovkey='IAQParameterSpecification'
        SpecificationMax = 4527,         //lovkey='IAQParameterSpecification'
        SpecificationRange = 4528,       //lovkey='IAQParameterSpecification'

        RequirementMin = 340,             //lovkey='RequirementRangeValue'
        RequirementMax = 341,             //lovkey='RequirementRangeValue' 
        RequirementEquals = 342,          //lovkey='RequirementRangeValue'
        RequirementRange = 343,            //lovkey='RequirementRangeValue

        HospitalDirector = 5555677,
        JohnPosition = 2840,              //lovkey='GeneralHospitalCurrentPosition'
        HospitalAsstEngineer=  5920,
        HospitalDirectorPosition = 2837,  //lovkey='GeneralHospitalCurrentPosition'
        StateEngineer = 3157,             //lovkey='GMStaffType'
        BPK = 3156,
        FWCategory_TestEquipmentLovId = 4177,                //lovkey='FWCategoryValue'
        FWCategory_ToolsLovId = 4178,                       //lovkey='FWCategoryValue'
        FWCategory_EquipmentUnderRepairLovId = 4182,        //lovkey='FWCategoryValue'

        UMActive = 971,                     //lovkey='UMStatusValue'
        UMInactive = 972,                   //lovkey='UMStatusValue'

        LLSOwnerShip = 3040,                 //Lovkey='OwnershipValue'   
        LLSCurrentPosition = 4144,           //Lovkey='LLSCurrentPosition' 
        GMLocationType = 4130,               //LovKey='GMLocationType'
        LLsAccessLevel = 663,                //LOvkey='Commonlevel'
        LLSCommonService = 4,                // Lovkey='CommonLevel' && Fieldvalue = 'LLs' 
        FmsContractType = 3189,              // lovkey='FmsContractType'                   
        HospitalCommonLevl = 662,            // Lovkey=CommonLevel
        GeneralHospitalCurrentPosition = 5196, //Lovkey= GeneralHospitalCurrentPosition

        RollOverFeeStatus_OPEN = 5614,                              //Lovkey RollOverFeeStatus                       
        RollOverFeeStatus_VERIFIED = 5615,
        RollOverFeeStatus_APPROVED = 5616,

        ActiveAsset = 127,                     //lovkey='ContractorAndVendorStatus'  -- referred for Asset Register
        InactiveAsset = 128,                  //lovkey='ContractorAndVendorStatus' for Asset Register

        Authorization = 4799,           //Lovkey = 'AuthorizationValue' of Asset
        UnAuthorization = 4800,

        Project = 2818,                           //LovKey = 'TCTypeValue' type of T & C refers Asset Type
        Asset = 2819,

        TreatmentFcltymstActive = 3327,                     //lovkey='StatusValue'
        TreatmentFcltymstInactive = 3328,

        //Lovkey='VOStatusValue' for Variation Status in VM
        V1 = 2648,              //V1 - Existing (asset prior to 1997)
        V2 = 2649,              //V2 - Stop service by MOH Engineering Division
        V3 = 2650,              //V3 - Added installed facilities (new building, plant, equipment or land)
        V4 = 2651,              //V4 - Stop Service by Hospital / Institution
        V5 = 2652,              //V5 - Transfer to others Hospitals / Institution
        V6 = 2653,              //V6 - Transfer from others Hospitals / Institution
        V7 = 2654,              //V7 - Donated by other Hospitals / Institution or Healthcare facilities
        V8 = 2655,              //V8 - Upgraded Installed Facilities
        V9 = 2656,              //V9 - Project systems component
        V10 = 2657,             //V10 ­ Asset in initial fee submission for any new or replacement hospital
        V11 = 2658,             //V11 - Old hospital asset moved to new replacement hospital
        V12 = 2659,             //V12 – System component and asset in initial fee submission for any new or replacement hospital 

        daysperweek7 = 876,
        daysperweek6 = 877,
        daysperweek5 = 878,
        daysperweek4 = 879,
        daysperweek3 = 880,
        daysperweek2 = 881,
        daysperweek1 = 882,

        LocationOfCondemnation_Plant = 625,
        LocationOfCondemnation_Hospital = 626,

        LLS_POSITION_LLSVERIFIER = 5196,

        FMS_ContractorAndVendorStatus_Active = 127,
        FMS_ContractorAndVendorStatus_InActive = 128,

        GM_LicenseTypeCodeValue_Transportation = 810,
        CldStatusValue_Received = 1135,

        YesNoValue_Yes = 145,
        YesNoValue_No = 146,
        Elec_Provider_Tenaga_Nasional_Berhad = 2160,
        Elec_Provider_Sabah_Electricity_Sdn_Bhd = 2161,
        Elec_Provider_Sarawak_Energy_Berhad = 2162,
        Elec_Provider_Northern_Utilities_Resources = 2163,

        SP_TariffType_B = 783,
        SP_TariffType_C1 = 784,
        SP_TariffType_C2 = 785,
        SP_TariffType_C3 = 4031,
        SP_TariffType_CM1 = 4032,
        SP_TariffType_CM2 = 4033,
        SP_TariffType_CM3 = 4034,
        SP_TariffType_D = 11903,

        SIJILNotification = 4685,
        TypeCode_WarrantyTypeValue_DuringWarrantyRate = 2829,
        TypeCode_WarrantyTypeValue_PostWarrantyRate = 2830,
        TypeCode_WarrantyTypeValue_Land = 2831,
        TypeCode_BEMSWarrantyParameter_DWPCLessThan2M = 5176,
        TypeCode_BEMSWarrantyParameter_DWPCGreaterThan2M = 5177,
        TypeCode_BEMSWarrantyParameter_PostWarranty = 5178,

        TypeCode_Parameter_1Landbelow = 2642,
        TypeCode_Parameter_1Lto5L = 2643,
        TypeCode_Parameter_5Lto10L = 2644,
        TypeCode_Parameter_Morethan10L = 2645,
        TypeCode_Parameter_Building = 2825,
        TypeCode_Parameter_Mechanical = 2826,
        TypeCode_Parameter_Electrical = 2827,
        TypeCode_Parameter_Aggregated = 2828,


        Typecode_TypeAssetClassificationValue_Equipment = 2424,
        Typecode_TypeAssetClassificationValue_Vehicle = 2425,
        Typecode_TypeAssetClassificationValue_System = 2426,
        Typecode_TypeAssetClassificationValue_Building = 2427,
        Typecode_TypeAssetClassificationValue_Land = 2428,
        Typecode_TypeAssetClassificationValue_Location = 2429,
        Typecode_TypeAssetClassificationValue_EquipmentandSystem = 4801,

        FEMSPOS_REEM = 45,
        FEMSPOS_CEM = 46,


        CLS_AreaCategory_SpecializedArea = 427,
        CLS_AreaCategory_MedicalArea = 428,
        CLS_AreaCategory_GeneralArea = 429,
        CLS_AreaCategory_OtherArea = 430,
        CLS_AreaCategory_Overall = 431,
        CLS_AreaCategory_Multilevel_Car_Parking = 5613,

        SP_ClaimStatus_Submitted = 4504,              //SP_IAQReassessment
        SP_ClaimStatus_Processed = 4505,

        WPM_InvocationStatus_Draft = 5653,                 // this lovid is lovkey =  AssessmentStatus  uing in John part
        WPM_InvocationStatus_Invoked = 2793,
        WPM_InvocationStatus_ImplementedandClosed = 5650,
        WPM_InvocationStatus_Approved = 2796,
        WPM_InvocationStatus_ClarificationSought = 5659,

        WPM_PenaltyImposed_Approved = 5658,                                  //Assessment Based on Penalty Imposed (Critical Event) – (JKN)
        WPM_PenaltyImposed_ClarificationSoughtbyJKN = 5659,


        SP_EM_Claim_Pending = 4496,     //lov Key = SPEMCClaimStatus
        SP_EM_Claim_Claimed = 4497,    //lov Key = SPEMCClaimStatus
        SP_EM_Claim_Rejected = 6021,    //lov Key = SPEMCClaimStatus
        Sr_Status_Open = 2311,                                  //Service Request Lov
        Sr_Status_WIP = 2312,
        Sr_Status_Completed = 2313,
        Sr_Status_Closed = 2314,
        Laundry_Location = 4131,
        SR_TypeOfRequest_BER = 978,


        Pos_FacilityManager_1 = 3191,  // Facility Manager 1
        Pos_FacilityManager_2 = 3192,   // Facility Manager 2
        Pos_Head_Of_FEMS_1 = 5932,     // Head of FEMS 1
        Pos_Head_Of_FEMS_2 = 5933,     // Head of FEMS 1
        Pos_Head_Of_BEMS = 5934,       // Head of BEMS
        Pos_Head_Of_CLS = 2781,
        Pos_Head_Of_LLS = 2785,
        Pos_Head_Of_HWMS = 2784,
        Pos_Head_Of_HWMS_CLS_LLS = 5929,


        /*Hwms Santize value */
        HWMS_Sanitize_yes = 1049,                     //lovkey='StatusValue'
        HWMS_Sanitize_No = 1050,

    };


    public enum WOProcessStatus
    {
        NotDoneAndClosed = 5886
    }
    public enum CompletionInfoReason
    {
        EquipmentInUse = 4026,
        EquipmentNotAtLocation = 4027
    }
    public enum VariationWFStatusList
    {
        VVF_Submitted = 5575,
        VVF_Verified = 5576,
        VVF_Rejected = 5577,
        VVF_Approved = 5578,
        VVF_RejectedbyHD = 5579,
        VVF_ReSubmitted = 5580,
        SVR_Verified = 5581,
        SVR_Rejected = 5582,
        SVR_Approved = 5583,
        SVR_RejectedbyJKN = 5584,
        SVR_ReSubmitted = 5585,
        Open = 5598,
        SVR_Draft = 5963,
        Rejected_By_BPK = 6073,
        ROFR_Prepared = 6074,
        ROFR_Verified = 6075,
        ROFR_Rejected = 6076,
        ROFR_Acknowledged = 6077,
        SOFR_Open = 6078,
        SOFR_Endorsement_Submission = 6079,
        SOFR_Correction = 6080,
        SOFR_Corrected = 6081,
        SOFR_KSU_Approval_Submission = 6082,
        SOFR_KSU_Approved = 6083,
        ST_Offer_Letter_Generated = 6084
    };

    public enum WPMAssessmentStatus
    {
        Draft = 5653,
        Submitted = 5654,
        Clarified = 5655,
        Recommended = 5656,
        Clarification_Sought_by_HD = 5657,
        Approved = 5658,
        Clarification_Sought_by_JKN = 5659
    };
    public enum VMModuleEmailTemplate
    {
        SummaryofVariationsVerify = 90,
        SummaryofVariationsrejectedHQ = 93,
        SummaryofVariationsApporoved = 92,
        SummaryofVariationsrejected = 91,
        SummaryofVariationsresubmitted = 94,
        VVFSubmittedFEMS = 84,
        VVFSubmittedBEMS = 97,
        VVFSubmittedCLS = 103,
        VVFverifiedJOHNFEMS = 85,
        VVFverifiedJOHNBEMS = 98,
        VVFverifiedJOHNCLS = 104,
        VVFrejectedJOHNFEMS = 86,
        VVFrejectedJOHNBEMS = 99,
        VVFrejectedJOHNCLS = 105,
        VVFapprovedHDFEMS = 87,
        VVFapprovedHDBEMS = 100,
        VVFapprovedHDCLS = 106,
        VVFrejectedHDFEMS = 88,
        VVFrejectedHDBEMS = 101,
        VVFrejectedHDCLS = 107,
        VVFresubmittedFEMS = 89,
        VVFresubmittedBEMS = 102,
        VVFresubmittedCLS = 108,
        RoolOverFeeSubmit = 95,
        RoolOverFeeVerify = 96,
        RoolOverFeeAmendmentNotificattionEmail = 122,


    };

    public enum Email_Template
    {
        AssessmentBasedPISubmitted = 147,
        AssessmentBasedPIMoreInfoHD = 148,
        AssessmentBasedPIRecommended = 149
    }

    public enum VMPeriodValue
    {
        Jan2June = 4610,
        July2Dec = 4611
    }

    public enum VM_ScreenList
    {
        VVF = 619,
        VVF_Rejection = 624,
        SummaryReports = 621,
        Summary_Rejection = 623

    }

    public enum VMTables
    {
        BuildingandSystems = 4467,
        EquipmentandVehicles = 4468,
        LandArea = 4469,
        Equipment = 4470,
        CleansingArea = 4471
    }

    public enum VMSNFStatusList
    {
        OPEN = 4283,   //Lovkey SNFStatus    
        VERIFIED = 4284,
        REJECTED = 4285,
        APPROVED = 4286,
        ISSUED = 4287,
        CLARIFICATION_SOUGHT_BY_HE = 5524,
        CLARIFICATION_SOUGHT_BY_HD = 6030,
        CLARIFIED_BY_HE = 6031,
        ReSubmitted = 6032,
        CANCELLED = 6034
    }

    public enum VMDocumentType
    {
        GovernmentAssetRegistrationForm = 5018,
        CopyofPurchaseAgreement = 5019,
        CopyofPurchaseOrder_LPO = 5020,
        TCdocumentCertificateofAcceptance = 5021,
        ApprovalletterfromMOHProcurementDivisionfordonateditem = 5022,
        MOHletterfortransferinoutitemtofromhospital = 5023,
        MOHletterforanyomissionifany = 5024,
        SitePlanAsBuiltDrawingFloorPlan = 5025,
        PoliceReportandLaporanAwalKEWPA28forassetnotfoundifany = 5026,
        BQ_BillofQuantity = 5888
    }
    public enum Assetregister
    {
        Asset_EquipmentandVehicles = 2296,
        Asset_System = 2297,
        Asset_EquipmentandSystem = 4807,
        Asset_Building = 2324,
        Asset_Authorization = 4799,
        Asset_Transfered = 5968,
        Asset_Land = 2325,
        Asset_Location = 2326,
        Asset_UnAuthorization = 4800,
        SNF_Approved = 4286,
        SnfV2_status = 2649,
        SnfV4_status = 2651,
        SnfV5_status = 2652,
        TypeCode_Land = 2428,
        TypeCode_Building = 2427,
        TypeCode_Location = 2429,
        TypeCode_System = 2426,
        TypeCode_Equipment = 2424,
        TypeCode_EquipmentAndSystem = 4801,
        Status_Active = 413,
        Status_InActive = 414,
        Yes = 145,
        No = 146,
        Service_Fems = 1,
        Service_Bems = 2,
        Asset_PlannerClassification_PPM = 2362,
        Asset_PlannerClassification_RI = 2363,
        Asset_PlannerClassification_CALB = 2364,
        Asset_TransferType_In = 2301,
        Asset_TransferType_Out = 2300,
        SR_Cancel = 2315,

        Asset_MainSupplier = 2293,
        Asset_LocalAuthorisedRepresentative = 2294,
        Asset_3rdPartyServiceProvider = 2295,
        MWO_Schedule = 2358,
        MWO_Unscheduled = 2357,
        PlannerClassification_PPM = 2512,
        PlannerClassification_RI = 2513,
        PlannerClassification_CALB = 2515,
        AssetPoup_Softwarekey = 2,
        Asset_purchase_history = 3,


    }

    public enum VariationDocumentTypeMapping
    {

        Government_Asset_Registration_Form = 5018,
        Copy_of_Purchase_Agreement = 5019,
        Copy_of_Purchase_Order = 5020,
        TC_documentorCertificate_of_Acceptance = 5021,
        Approval_letter_from_MOH_Procurement_Division_for_donated_item = 5022,
        MOH_letter_for_transfer_inorout_item_toorfrom_hospital = 5023,
        MOH_letter_for_any_omission = 5024,
        Site_Plan_As_Built_Drawing_Floor_Plan = 5025,
        Police_Report_and_Laporan_Awal_KEW_PA_28_for_asset_not_found = 5026

    }
    public enum WorkGroupDetails
    {
        W6_Electrical_Engineering = 6,
        W9_Mechanical_Engineering = 9
    }

    public enum WPMCriticalEvent
    {
        JOHNsubmit = 109,
        JKNValid = 110,
        JKNInValid = 111,
        JKNForwordToKKM = 112,
        KKMValid = 113,
        KKMInValid = 114,
        JKNClarification = 126,
        JKNClarified = 127,
    }

    public enum CustomerFeedbackSurveyEMailTemplate
    {
        AssessmentBasedCFSSubmitted = 128,
        AssessmentBasedCFSMoreInfoHD = 129,
        AssessmentBasedCFSRecommended = 130,
        AssessmentBasedCFSApproved = 131,
        AssessmentBasedCFSMoreInfoJKN = 132
    }


    public enum AssessmentBasedonTpcEMailTemplate
    {
        AssessmentBasedTPCApproved = 144,
        AssessmentBasedTPCMoreInfoJKN = 145,
    }
    public enum AssessmentBasedPI
    {
        AssessmentBasedPIApproved = 150,
        AssessmentBasedPIMoreInfoJKN = 151,
    }
    public enum WPM_DeductionMade_AssessmentStatusList
    {
        Draft = 5653,
        Submitted = 5654,
        Clarified = 5655,
        Recommended = 5656,
        ClarificationSoughtByHD = 5657,
        Approved = 5658,
        ClarificationSoughtByJKN = 5659
    }

    public enum WPM_DeductionMade_NotificationTemplateList
    {
        AssessmentBasedDMSubmitted = 136,
        AssessmentBasedDMMoreInfoHD = 137,
        AssessmentBasedDMRecommended = 138,
        AssessmentBasedDMApproved = 139,
        AssessmentBasedDMMoreInfoJKN = 140
    }

    public enum WPM_ScreenList
    {
        Assessment_Based_on_Deduction_MadeBYJOHN = 845,
        Assessment_Based_on_Deduction_Made_JKN = 846


    }

    public enum HospitalReportFormAandBEMailTemplate
    {
        HospitalReportFormAandBSubmitted = 156,
        HospitalReportFormAandBRejected = 158,
        HospitalReportFormAandBApproved = 157,
        HospitalReportFormAandBFinalized = 159,

    }
    public enum PPMScheduleGenerationMailTemplate
    {
        PPMScheduleGeneration = 163,
    }
    public enum FormAandBStatus
    {

        AB_Submitted = 5516,
        ABF_Rejected = 5518,
        AB_Approved = 5517,
        AB_Finalized = 2640,

    };
    public enum PlannerType
    {

        PPM = 2512,
        RI = 2513,
        PDM = 2514,
        Calibration = 2515,
        AssetAudit = 2516,
        LCA = 2672,
        AdvisoryServices = 2673,
        WarrantyPPM = 3120,
        SCM = 3121,


    };

    public enum WorkPermitEnum
    {
        WpDraft = 5639,
        WpSubmitted = 5640,
        WpVerified = 5641,
        WpMoreInfobyJOHN = 5642,
        WpClarified = 5643,
        WpApproved = 5644,
        WpRejected = 5645,
        WpMoreInfobyHD = 5662,

        wpEtSubmitted = 115,
        wpEtVerified = 116,
        wpEtMoreInfobyJOHN = 117,
        wpEtApproved = 118,
        wpEtClarificationSoughtFromJOHN = 119,
        wpEtClarificationSoughtFromApplicant = 146,

        ClarificationSoughtFromJOHN = 1,
        ClarificationSoughtFromApplicant = 2,
        ClarificationSoughtFromFacilityManager = 3,

        CivilEngineering = 4980,
        MechanicalEngineering = 4981,
        ElectricalEngineering = 4982,


    };

    public enum ENGAdvisoryServicesType
    {
        CA = 4200,
        TA = 4201,
        PTA = 4202,
        BER = 4203
    };

    public enum BerRoleType
    {
        BILNo = 5617
    }

    public enum ENGStakeholderTypeValue
    {
        Prepared = 4012,
        Checked = 4013,
        Approved = 4014,
        Recommended = 4015,
        Conclusion = 4016,
        Rejected = 5172,
        Draft = 5404,
        ClarificationSought = 5431,
        RejectedbyHD = 5431,
        Clarified = 6022

    }

    public enum AdvisoryServicesEmailTemplate
    {
        FEMS_Advisory_Prepared = 49,
        FEMS_Advisory_Checked = 50,
        FEMS_Advisory_Approved = 51,
        FEMS_Advisory_Recommended = 52,
        FEMS_Advisory_Rejected = 53,
        FEMS_Advisory_Concluded = 54,
        BEMS_Advisory_Prepared = 56,
        BEMS_Advisory_Checked = 57,
        BEMS_Advisory_Approved = 58,
        BEMS_Advisory_Recommended = 59,
        BEMS_Advisory_Rejected = 60,
        BEMS_Advisory_Concluded = 61,
        FEMS_Advisory_RejectedByHD = 186,
        BEMS_Advisory_RejectedByHD = 187

    }

    public enum ENGTCStatusValue
    {
        Passed = 2820,
        Failed = 2821,
        Cancelled = 5872
    }
    public enum LLSLinenAdjustmentMailTemplate
    {
        submit = 196,
        approved = 197
    }

    public enum VMSNFEmailTemplateList
    {
        SNF_SUBMITTED = 63,
        SNF_RESUBMITTED = 200,
        SNF_VERIFIED = 64,
        SNF_CLARIFIED_BY_HE = 198,
        SNF_CLARIFICATION_SOUGHT_BY_HE = 66,
        SNF_APPROVED_FEMS = 65,
        SNF_APPROVED_BEMS = 345,
        SNF_APPROVED_CLS = 346,
        SNF_CLARIFICATION_SOUGHT_BY_HD = 199,
        SNF_REJECTED = 62
    }
    public enum AsisticketStatus
    {
        New = 1,
        Open = 2,
        Fixed = 3,
        Closed = 4,
        Dispute = 5,
        Clarification = 6,
        Duplicate = 7
    }
    public enum AsisticketCategory
    {
        Defect = 1,
        ChangeRequest = 2,
        Dispute = 3,
        Clarification = 4,
        Duplicate = 5

    }



    // invocation of clauses 
    public enum IoCEnum
    {
        Recommended = 5825,
        Clarified = 2795,
        ClarificationSought = 2794,
        Approved = 5826,
        ImplementedandClosed = 5650,
        NotImplementedAndClosed = 5649
    }

    public enum VM_SNFAssetCategory
    {
        Aset_Alih = 6070,
        Aset_Tak_Alih = 6071
    }
    public enum SREmailTemplate
    {


        BemsTemplateIdSave = 215,
        BemsTemplateIdUpdate = 216,
        BemsTemplateIdCancel = 217,
        BemsTemplateIdHelpDeskSave = 218,
        BemsTemplateIdHelpDeskUpdate = 219,
        BemsTemplateIdRejected = 220,
        BemsTemplateIdDateChanges = 221,


        ClsTemplateIdSave = 222,
        ClsTemplateIdUpdate = 223,
        ClsTemplateIdCancel = 224,
        ClsTemplateIdHelpDeskSave = 225,
        ClsTemplateIdHelpDeskUpdate = 226,
        ClsTemplateIdRejected = 227,
        ClsTemplateIdDateChanges = 228,


        LlsTemplateIdSave = 229,
        LlsTemplateIdUpdate = 230,
        LlsTemplateIdCancel = 231,
        LlsTemplateIdHelpDeskSave = 232,
        LlsTemplateIdHelpDeskUpdate = 233,
        LlsTemplateIdRejected = 234,
        LlsTemplateIdDateChanges = 235,

        HwmsTemplateIdSave = 236,
        HwmsTemplateIdUpdate = 237,
        HwmsTemplateIdCancel = 238,
        HwmsTemplateIdHelpDeskSave = 239,
        HwmsTemplateIdHelpDeskUpdate = 240,
        HwmsTemplateIdRejected = 241,
        HwmsTemplateIdDateChanges = 242,


        FmsTemplateIdSave = 243,
        FmsTemplateIdUpdate = 244,
        FmsTemplateIdCancel = 245,
        FmsTemplateIdHelpDeskSave = 246,
        FmsTemplateIdHelpDeskUpdate = 247,
        FmsTemplateIdRejected = 248,
        FmsTemplateIdDateChanges = 249,


        SpTemplateIdSave = 250,
        SpTemplateIdUpdate = 251,
        SpTemplateIdCancel = 252,
        SpTemplateIdHelpDeskSave = 253,
        SpTemplateIdHelpDeskUpdate = 254,
        SpTemplateIdRejected = 255,
        SpTemplateIdDateChanges = 256,




        FemsTemplateIdSave = 18,
        FemsTemplateIdUpdate = 24,
        FemsTemplateIdCancel = 75,
        FemsTemplateIdHelpDeskSave = 76,
        FemsTemplateIdHelpDeskUpdate = 77,
        FemsTemplateIdRejected = 78,
        FemsTemplateIdDateChanges = 162,



        HDURBookingConvertToSR_SP = 262,
        HDURBookingConvertToSR_FMS = 261,
        HDURBookingConvertToSR_HWMS = 260,
        HDURBookingConvertToSR_LLS = 259,
        HDURBookingConvertToSR_CLS = 258,
        HDURBookingConvertToSR_BEMS = 257,
        HDURBookingConvertToSR_FEMS = 82,



        HDURBookingStatus_SP = 268,
        HDURBookingStatus_FMS = 267,
        HDURBookingStatus_HWMS = 266,
        HDURBookingStatus_LLS = 265,
        HDURBookingStatus_CLS = 264,
        HDURBookingStatus_BEMS = 263,
        HDURBookingStatus_FEMS = 83



    }
    public enum Locationtype
    {
        Hospital=4130,
        LaundryPlant=4131,
        TreatmentFacility=4132

    }
    public enum SMSStatus
    {
        Valid = 6121,
        Invalid = 6122,
        InvalidNoHospitalCode = 6123
    }
    public enum PlannerScheduleGenerationAssetClassification
    {
        Building = 2324,
        Equipment = 4489,
        EquipmentAndVehicles = 2296,
        EquipmentOrSystem = 4807,
        Land = 2325,
        Location = 2326,
        System = 2297

    }

    public enum ConfigScreenNameValue
    {
        AssetRegister = 314,
        TestingAndCommissioning = 315,
        WorkorderScheduled=337
    }
    public enum YesNo
    {
        Yes = 99,
        No = 100
    }
    public enum CARStatus
    {
        Submitted = 367,
        Approved = 369,
        Rejected = 368
    }

    public enum NotificationTemplateIds
    {
        QAPCARSubmission = 61,
        QAPCARApproved = 62,
        QAPCARRejected = 63,
        WorkOrderReassigned = 75,
        WorkOrderReassignedToVendor = 76
    }

    public enum WorkOrderCategory
    {
        Scheduled = 187,
        Unscheduled = 188
    }
}
