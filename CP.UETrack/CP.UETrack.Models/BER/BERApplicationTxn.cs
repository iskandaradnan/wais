using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BER
{
    public class BERApplicationTxn
    {
        public int ApplicationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }

        public int ARPID { get; set; }

        public string BERno { get; set; }
        public int AssetId { get; set; }
        public string ConditionAppraisalRefNo { get; set; }
        public string BERRemarks { get; set; }
        public string UserAreaName { get; set; }
        public string AssetNo { get; set; }
        public string AssetName { get; set; }
        public string AssetDescription { get; set; }
        public decimal? FreqDamSincPurchased { get; set; }
        public decimal? TotalCostImprovement { get; set; }
        public string FacilityCode { get; set; }
        public bool EstRepcostToExpensive { get; set; }
        public decimal? RepairEstimate { get; set; }
        public decimal? ValueAfterRepair { get; set; }
        public decimal? EstDurUsgAfterRepair { get; set; }
        public bool NotReliable { get; set; }
        public bool StatutoryRequirements { get; set; }
        public bool Obsolescence { get; set; }
        public string OtherObservations { get; set; }
        public int ApplicantStaffId { get; set; }
        public int NotificationId { get; set; }
        public string ApplicantStaffName { get; set; }
        public string ApplicantDesignation { get; set; }
        public int? BER1Status { get; set; }
        public string Applicant { get; set; }
        public string BER2TechnicalCondition { get; set; }
        public string BER2RepairedWell { get; set; }
        public string BER2SafeReliable { get; set; }
        public string BER2EstimateLifeTime { get; set; }
        public string BER2Syor { get; set; }
        public string BER2Remarks { get; set; }
        public bool TBER2StillLifeSpan { get; set; }
        public string Assignee { get; set; }
        public string BER1Remarks { get; set; }
        public int? ParentApplicationId { get; set; }
        public DateTime? ApprovedDate { get; set; }
        public DateTime? ApprovedDateUTC { get; set; }
        public string JustificationForCertificates { get; set; }

        public DateTime ApplicationDate { get; set; }
        public int? RejectedBERReferenceId { get; set; }

        public string BER2TechnicalConditionOthers { get; set; }
        public string BER2SafeReliableOthers { get; set; }
        public string BER2EstimateLifeTimeOthers { get; set; }
        public int BERStage { get; set; }
        public string CircumstanceOthers { get; set; }
        public string ExaminationFirstResultOthers { get; set; }
        public string Designation { get; set; }
        public decimal? EstimatedRepairCost { get; set; }
        public string Timestamp { get; set; }
        public string StaffName { get; set; }
        public int BERStatus { get; set; }
        public string BERStatusValue { get; set; }
        public decimal? CurrentValue { get; set; }
        public int? RequestorId { get; set; }
        public string RequestorName { get; set; }
        public string RequestorEmail { get; set; }
        public int? EngineerId { get; set; }
        public string RequestorDesignation { get; set; }
        public List<BERApplicationRemarksHistoryTxn> BERApplicationRemarksHistoryTxns { get; set; }
        public List<BERMaintananceHistoryDet> BERMaintananceHistoryDets { get; set; }
        public List<BERApplicationHistoryTxn> BERApplicationHistoryTxns { get; set; }
        public List<BerCurrentValueHistoryTxnDet> BerCurrentValueHistoryTxnDets { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string SupplierName { get; set; }
        public decimal? PurchaseCost { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public decimal? AssetAge { get; set; }
        public int? StillwithInLifeSpan { get; set; }
        public string CurrentValueRemarks { get; set; }
        public List<FileUploadDetModel> FileUploadList { get; set; }
        public DateTime BERDate { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public string HiddenId { get; set; }
        public List<int> BER2SyorList { get; set; }
        public decimal? CurrentRepairCost { get; set; }
        public string BIL { get; set; }
        public decimal? PastMaintenanceCost { get; set; }
        public bool CannotRepair { get; set; }

        public string ItemNo { get; set; }

        public int BatchNo { get; set; }

        public string AssetTypeDescription { get; set; }

        public string PackageCode { get; set; }
        public string AreaName { get; set; }
        public string Quantity { get; set; }

    }
    public class BERApplicationTxnLovs
    {
        public int? ApplicantStaffId { get; set; }
        public string ApplicantStaffName { get; set; }
        public string ApplicantDesignation { get; set; }
        public string Services { get; set; }

        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> BER2EstimateLifeTimeLovs { get; set; }
        public List<LovValue> NotReliableLovs { get; set; }
        public List<LovValue> StatuaryRequirementLovs { get; set; }
        public List<LovValue> BER1StatusLovs { get; set; }
        public List<LovValue> BER2TechnicalConditionLovs { get; set; }
        public List<LovValue> BER2SafeReliableLovs { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public string ApplicantName { get; set; }
        public DateTime CurrentDate { get; set; }
        public List<UserActionPermissions> ActionPermissions { get; set; }
    }



    public class ReportLoadLovModel
    {


        public List<LovValue> List1 { get; set; }
        public List<LovValue> List2 { get; set; }
        public List<LovValue> List3 { get; set; }
        public List<LovValue> List4 { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }

    }



    public class BERApplicationRemarksHistoryTxn
    {
        public int RemarksHistoryId { get; set; }
        public int ApplicationId { get; set; }
        public string Remarks { get; set; }
        public string EnteredBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }

    public class BERMaintananceHistoryDet
    {
        public int ApplicationId { get; set; }
        public string MaintenanceWorkCategory { get; set; }
        public string BERno { get; set; }
        public string MaintenanceWorkNo { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public DateTime? MaintenanceWorkDateTime { get; set; }

        public string MaintenanceCategoryValue { get; set; }
        public string MaintenanceWorkType { get; set; }
        public string MaintenanceTypeValue { get; set; }
        public decimal? DowntimeHoursMin { get; set; }
        public decimal? TotalCost { get; set; }
        public decimal? TotalSpareCost { get; set; }
        public decimal? TotalLabourCost { get; set; }
        public decimal? TotalVendorCost { get; set; }
        public decimal? TotalContractCost { get; set; }
    }

    public class BERApplicationHistoryTxn
    {
        public int ApplicationId { get; set; }
        public string BERno { get; set; }
        public DateTime? ApplicationDate { get; set; }
        public int Status { get; set; }
        public string StatusValue { get; set; }
        public string StaffName { get; set; }
        public string Designation { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string RejectedBERNo { get; set; }
    }
    public class BerCurrentValueHistoryTxnDet
    {
        public int ApplicationId { get; set; }
        public int CurrentValueId { get; set; }
        public decimal? CurrentValue { get; set; }
        public string Remarks { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class AdditionalFieldsConfig
    {
        public List<AdditionalFields> additionalFields { get; set; }
    }
    public class AdditionalFields
    {
        public int AddFieldConfigId { get; set; }
        public int CustomerId { get; set; }
        public int ScreenNameLovId { get; set; }
        public int FieldTypeLovId { get; set; }
        public string FieldName { get; set; }
        public string Name { get; set; }
        public string DropDownValues { get; set; }
        public int RequiredLovId { get; set; }
        public int? PatternLovId { get; set; }
        public int? MaxLength { get; set; }
        public string PatternValue { get; set; }
        public string IsRequired { get; set; }
    }


    public class BerAdditionalFields
    {
        public int ApplicationId { get; set; }
        public string Field1 { get; set; }
        public string Field2 { get; set; }
        public string Field3 { get; set; }
        public string Field4 { get; set; }
        public string Field5 { get; set; }
        public string Field6 { get; set; }
        public string Field7 { get; set; }
        public string Field8 { get; set; }
        public string Field9 { get; set; }
        public string Field10 { get; set; }
    }
}

