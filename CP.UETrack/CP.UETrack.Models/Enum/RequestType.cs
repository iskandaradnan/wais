
namespace CP.UETrack.Model.Enum
{
    public enum SERVICE
    {
        FEMS = 1,
        BEMS = 2,
        CLS = 3,
        LLS = 4,
        HWMS = 5,
        FMS = 6,
        BER = 7,
        QAP = 8,
        SP = 9,
        SR = 10,
        VM = 11,
        WP = 12,
        FIN = 13,
        DED = 14,
        WPM = 15,
        EOD = 16,
        HSIP = 17,
        UM = 18,
        HD = 19,
        VRC = 20,
        WebPortal = 21,
        GM = 22,
        Reports = 23,
        Mob = 24,
        GENERAL =1501
    }

    public enum MODULE
    {
        ICT = 19,
        FEMS = 13,
        BEMS = 3,


        UM = 1,
        GM = 2,

        QAP = 4,
        KPI = 5,
        BER = 6,
        VM = 7,
        ER = 8,
        MOB = 9,
        Reports = 10,

        Charts = 12,

        MASTER = 14,
        LLS = 15,
        CLS = 16,
        HWMS = 17,

        HSIP = 21,
        FMS = 22


    }

    public enum AsisServiceConfigKeys
    {
        CoreServices = 1, //FEMS,  BEMS,  CLS,  LLS,  HWMS,  FMS
        CoreServicesExceptFMS = 2, //FEMS,  BEMS,  CLS,  LLS,  HWMS
        EngineeringServices = 3, //FEMS,  BEMS
        CoreAndNonCoreServices = 4, //FEMS,  BEMS,  CLS,  LLS,  HWMS,  FMS,  BER,  QAP,  SP,  SR,  VM,  TPC,  DED,  VRC,  WPM,  EOD,  HSIP
        CoreAndNonCoreAndSupportServices = 5, //FEMS,  BEMS,  CLS,  LLS,  HWMS,  FMS,  BER,  HD, QAP, SP, SR, VM, TPC, UM, DED, VRC, WPM, FIN, WebPortal, EOD, HSIP
        CoreServicesWithALL = 6, //FEMS, BEMS, CLS, LLS, HWMS, FMS, All
        CommonLevel = 7,  //FEMS, BEMS, CLS, LLS, HWMS, SP, Hospital, Company, MOHStaff, CompanyStaff, 3R, IAQ, Energy, 
        NCRAnalysisService = 8,  //FEMS, BEMS, CLS, LLS, HWMS, FMS, SP, UETrack
        GroupValue = 9, //FEMS, BEMS, CLS, LLS, FMS, HWMS-B6A, HWMS-B6B, HWMS-B6C
        //InvoiceServiceValue = 10, //FEMS, BEMS, CLS, LLS, HWMS, FMS, SP, RW (Reimbursable Work)
        //VrcService = 11, //FEMS, BEMS, CLS, LLS, HWMS, BER, GM, QAP, SP, VM, TPC, WPM, HSIP, UETrack
        HSIPService = 106, // FEMS, BEMS, CLS, LLS, HWMS, FMS, DED
        IncidentRelatedServiceValue = 100, // FEMS, BEMS, CLS, LLS, CWMS, Safety, Health, Environment, Required Further Investigation, Referral Insurance, Referral to DOSH, Others
        CoreServicesWithSP = 101, // FEMS, BEMS, CLS, LLS, HWMS, FMS, SP
        WPMVWCTypeofService = 102, // FEMS, BEMS, CLS, LLS, HWMS, FMS, MW (Minor Work), RW (Reimbursable Work)
        AllServices = 10, //All services
        FMSStaffServices = 104, //  FEMS, BEMS, CLS, LLS, HWMS, FMS, SP, 3R, IAQ, Energy
        FINSPTypes = 105, //   3R, IAQ, Energy
        WPMVerificationOfWorkRpt = 109,// FEMS, BEMS, CLS, LLS, HWMS-CW,HWMS-OSW,HWMS-CSW, FMS,SP 
        WPApplicationForPermit = 107,// FEMS, BEMS, CLS, LLS, HWMS, FMS, SP, MW (Minor Work), RW (Reimbursable Work)
        VRCService = 108, // VRC related service load.
        FMSOtherPlannerServices = 110, // FMS Other Planner Services
        CoreServicesWithSPAndGeneral = 111,  // FEMS, BEMS, CLS, LLS, HWMS, FMS, SP, General
    }
    public enum LocationTypes
    {
        Hospital = 1,
        LaunndryPlant = 2,
        TreatmentPlant = 3,
        Laundry = 4131,
        TreatmentPlantLocation = 4132
    }

    public enum ActionPermissions
    {
        Add = 10,
        Edit = 20,
        View = 30,
        Delete = 40,
        Print = 50,
        Export = 60,
        Approve = 70,
        Reject = 80,
        Verify = 90,
        Clarify = 100,
        Renew = 110,
        Acknowledge = 120,
        Recommend = 130
    }

    public enum UserTypes
    {
        SystemAdmin = 1,
        HospitalUsers = 662,
        CompanyUsers = 663,
        MoHBPKUsers = 3156,
        MoHStateEngineer = 3157,
        CompanyHQUsers = 3187,
        LaundryPlantUsers = 3189,
        TreatmentPlantUsers = 3190
    }
    public enum StatusValues
    {
        Active = 413,
        Inactive = 414
    }
    public enum AssetClassifications
    {
        Equipment = 2424,
        Vehicle = 2425,
        System = 2426,
        Building = 2427,
        Land = 2428,
        Location = 2429,
        EquipmentSystem = 4801
    }
    public enum BuildingAndSystemParams
    {
        RM1000000AndBelow = 2642,
        RM1000001To5000000 = 2643,
        RM5000001To10000000 = 2644,
        MoreThanRM10000001 = 2645,
        Building = 2825,
        Mechanical = 2826,
        Electrical = 2827,
        Aggregated = 2828
    }
    public enum WarrantyType
    {
        DuringWarrantyRate = 2829,
        PostWarrantyRate = 2830,
        Land = 2831
    }

    public enum MonthLovs
    {
        January = 10,
        February = 11,
        March = 12,
        April = 13,
        May = 14,
        June = 15,
        July = 16,
        August = 17,
        September = 18,
        October = 19,
        November = 20,
        December = 21
    }
    public enum Months
    {
        January = 1,
        February = 2,
        March = 3,
        April = 4,
        May = 5,
        June = 6,
        July = 7,
        August = 8,
        September = 9,
        October = 10,
        November = 11,
        December = 12
    }
    public enum SPClaimStatusLovs
    {
        Proposed = 4477,
        Approved = 4478,
        Rejected = 4479,
        InProgress = 4480,
        Delay = 4481,
        Completed = 4482,
    }
    public enum AssessmentStatus
    {
        Draft = 5653,
        Submitted = 5654,
        Clarified = 5655,
        Recommended = 5656,
        ClarificationSoughtByHD = 5657,
        Approved = 5658,
        ClarificationSoughtByJKN = 5659
    }

    public enum HSIPUploadStatusLovs
    {
        Open = 5162,
        Submitted = 5163,
        Verified = 5164,
        RejectedbyLiasonOfficer = 5632,
        Recommended = 5633,
        RejectedbyJOHN = 5634,
        Approved = 5635,
        RejectedbyHD = 5636
    }

    public enum BerApplicationStatusValueId
    {
        New = 2631,
        Applied = 2632,
        Cancelled = 2633,
        Acknowledged = 2634,
        RejectedbyHD = 2635,
        ClarificationSoughtbyHD = 2636,
        ClarifiedbyApplicant = 2637,
        Recommended = 2638,
        Completed = 2639,
        Finalized = 2640,
        Approved = 2641,
        SavedbyMOH = 4592,
        SavedbyJOHN = 4593,
        Resubmitted = 5597,
        ClarificationSoughtbyJOHN = 5600,
        ClarificationSoughtbyMoH = 5601,
        ClarifiedbyHD = 5602,
        ClarifiedbyJOHN = 5603,
        RejectedbyJOHN = 5604,
        RejectedbyMoH = 5605,
        BERApplied = 2863,
        BERAcknowledged = 2864,
        BERApproved = 2865
    }
    public enum MenuIds
    {
        ChangePassword = 640
    }
    public enum UMSystemParameter
    {
        NewPasswordMatchErrorMessage
    }
    public enum EmailTemplateIds
    {
        UserRequestCreatedFEMS = 356,
        UserRequestCreatedBEMS = 357,
        UserRequestCreatedFMS = 361,
        UserRequestCreatedHWMS = 360,
        UserRequestCreatedLLS = 359,
        UserRequestCreatedCLS = 358,
        UserRequestCreatedSP = 362,        
        UserRequestUpdate = 189,

        HSIPRecommendedBEMS = 286,
        HSIPRecommendedCLS = 295,
        HSIPRecommendedFMS = 322,
        HSIPRecommendedHWMS = 313,
        HSIPRecommendedLLS = 304,
        HSIPRecommendedFEMS = 207,

        HSIPRejectedJohnBEMS = 287,
        HSIPRejectedJohnCLS = 296,
        HSIPRejectedJohnFMS = 323,
        HSIPRejectedJohnHWMS = 314,
        HSIPRejectedJohnLLS = 305,
        HSIPRejectedJohnFEMS = 208,

        HSIPRejectedHDBEMS = 288,
        HSIPRejectedHDCLS = 297,
        HSIPRejectedHDFMS = 324,
        HSIPRejectedHDHWMS = 315,
        HSIPRejectedHDLLS = 306,
        HSIPRejectedHDFEMS = 209,

        HSIPUploadCreationFEMS = 152,
	    HSIPUploadCreationBEMS = 273,
	    HSIPUploadCreationCLS = 290,
	    HSIPUploadCreationFMS = 317,
	    HSIPUploadCreationHWMS = 308,
	    HSIPUploadCreationLLS = 299,

        HSIPUploadApprovedBEMS = 276,
	    HSIPUploadApprovedCLS = 293,
	    HSIPUploadApprovedFMS = 320,
	    HSIPUploadApprovedHWMS = 311,
	    HSIPUploadApprovedLLS = 302,
        HSIPUploadApprovedFEMS = 155,

        HSIPUploadVerifiedFEMS = 154,
        HSIPUploadVerifiedBEMS = 275,
        HSIPUploadVerifiedCLS = 292,
        HSIPUploadVerifiedFMS = 319,
        HSIPUploadVerifiedHWMS = 310,
        HSIPUploadVerifiedLLS = 301,

        HSIPUploadRejectedFEMS = 153,
        HSIPUploadRejectedBEMS = 274,
        HSIPUploadRejectedCLS = 291,
        HSIPUploadRejectedFMS = 318,
        HSIPUploadRejectedHWMS = 309,
        HSIPUploadRejectedLLS = 300,

        UserTrainingScheduleFEMS = 38,
        UserTrainingScheduleBEMS = 270,
        UserTrainingScheduleCLS = 289,
        UserTrainingScheduleFMS = 316,
        UserTrainingScheduleHWMS = 307,
        UserTrainingScheduleLLS = 298,
        UserTrainingScheduleSP = 325,

        FmsUserTrainingMail = 176,
        FmsUserTrainingMailBEMS = 282,
        FmsUserTrainingMailCLS = 294,
        FmsUserTrainingMailFMS = 321,
        FmsUserTrainingMailHWMS = 312,
        FmsUserTrainingMailLLS = 303,
        FmsUserTrainingMailSP = 326,

        EODCaptureFEMS = 79,
        EODCaptureBEMS = 272,

        TAndCPassedFEMS = 74,
	    TAndCPassedBEMS = 271,

        Advisorynotverified10daysFEMS = 203,
        Advisorynotverified10daysBEMS = 285,

        Advisorynotsubmitted14daysFEMS = 202,
        Advisorynotsubmitted14daysBEMS = 284,

        EngStockExpiryMailFEMS = 194,
        EngStockExpiryMailBEMS = 283,

        ScheduleMaintenanceNoticeFEMS = 163,
        ScheduleMaintenanceNoticeBEMS = 277
    }
    public enum HWMSCompanies
    {
        Radicare = 3
    }
    public enum HWMSMenuIds
    {
        ConsumablesAndReceptacles = 270,
        ChemicalList = 272,
        ProductCertificate = 292
    }
    public enum TestingAndCommissioningStatus
    {
        Verify = 289,
        Approve = 290,
        Reject = 291
    }
}


