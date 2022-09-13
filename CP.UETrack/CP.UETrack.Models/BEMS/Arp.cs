using System;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.Model.FetchModels;

namespace CP.UETrack.Model.BEMS
{

    public class Arp : FetchPagination
    {

        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> SelectProposal { get; set; }
        public string ItemCode { get; set; }
      
        public string BER1Remarks { get; set; }
        public string PurchaseCostRM { get; set; }
        //public DateTime PurchaseDate { get; set; }

        public string BERStatusName { get; set; }
        public int BERStatusLovId { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string Package_Code { get; set; }
        
        public int ARPID { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public DateTime Timestamp { get; set; }
        public string BERno { get; set; }
        public DateTime BERDate { get; set; }
        public string ConditionAppraisalRefNo { get; set; }
        public string AssetNo { get; set; }
        public int AssetId { get; set; }
        public string AssetName { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AreaName { get; set; }
        public string LocationName { get; set; }
        public int ItemNo { get; set; }
        public string Quantity { get; set; }
        public DateTime BERApplicationDate { get; set; }
        public int BERApplicationId { get; set; }
        public string BatchNo { get; set; }
        public string PackageCode { get; set; }
        public string BERRemarks { get; set; }
        // public List<LovValue> FinalProposal { get; set; }
        public List<FileUploadDetModels> FileUploadList { get; set; }
        public List<ArpGridData> ArpGridData { get; set; }
        public Proposal FirstProposal { get; set; }
        public Proposal SecondProposal { get; set; }
        public Proposal ThirdProposal { get; set; }
        public string Justification { get; set; }
        public int SelectedProposal { get; set; }
        public string ArpProposalId { get; set; }
        public string Model1 { get; set; }
        public string Brand1 { get; set; }
        public string Manufacture1 { get; set; }
        public string EstimationPrice1 { get; set; }
        public string SupplierName1 { get; set; }
        public string ContactNo1 { get; set; }
        public string ARPID1 { get; set; }
        public int PROP_ID1 { get; set; }
        public string Model2 { get; set; }
        public string Brand2 { get; set; }
        public string Manufacture2 { get; set; }
        public string EstimationPrice2 { get; set; }
        public string SupplierName2 { get; set; }
        public string ContactNo2 { get; set; }
        public string ARPID2 { get; set; }
        public int PROP_ID2 { get; set; }
        public string Model3 { get; set; }
        public string Brand3 { get; set; }
        public string Manufacture3 { get; set; }
        public string EstimationPrice3 { get; set; }
        public string SupplierName3 { get; set; }
        public string ContactNo3 { get; set; }
        public string ARPID3 { get; set; }
        public int PROP_ID3 { get; set; }

        //public List<FinalProposal> FinalProposal { get; set; }

        //---Adding BER1 Refference--


        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }

        public int ApplicationId { get; set; }
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
        public string Status { get; set; }
        public int ProposalStatus { get; set; }
        
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

        public string StaffName { get; set; }
        public int BERStatus { get; set; }
        public string BERStatusValue { get; set; }
        public decimal? CurrentValue { get; set; }
        public int? RequestorId { get; set; }
        public string RequestorName { get; set; }
        public string RequestorEmail { get; set; }
        public int? EngineerId { get; set; }
        public string RequestorDesignation { get; set; }
        public List<ARPApplicationRemarksHistoryTxn> ARPApplicationRemarksHistoryTxns { get; set; }
        public List<ARPMaintananceHistoryDet> ARPMaintananceHistoryDets { get; set; }
        public List<ARPApplicationHistoryTxn> ARPApplicationHistoryTxns { get; set; }
        public List<ARPCurrentValueHistoryTxnDet> ARPCurrentValueHistoryTxnDets { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string UserAreaName { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string SupplierName { get; set; }

        public decimal? AssetAge { get; set; }
        public int? StillwithInLifeSpan { get; set; }
        public string CurrentValueRemarks { get; set; }


        public int Year { get; set; }
        public int Month { get; set; }
        public string HiddenId { get; set; }
        public List<int> BER2SyorList { get; set; }
        public decimal? CurrentRepairCost { get; set; }
        public string BIL { get; set; }
        public decimal? PastMaintenanceCost { get; set; }
        public bool CannotRepair { get; set; }
        public decimal? PurchaseCost { get; set; }
        //public DateTime? PurchaseDate { get; set; }
        public DateTime PurchaseDate { get; set; } = DateTime.Now;
        

        //----End Here---------

    }



    //---Add Ber Reffernece---
    public class ARPMaintananceHistoryDet
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
    public class ARPApplicationRemarksHistoryTxn
    {
        public int RemarksHistoryId { get; set; }
        public int ApplicationId { get; set; }
        public string Remarks { get; set; }
        public string EnteredBy { get; set; }
        public DateTime? UpdatedDate { get; set; }

    }

    public class ARPApplicationHistoryTxn
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

    public class ARPCurrentValueHistoryTxnDet
    {
        public int ApplicationId { get; set; }
        public int CurrentValueId { get; set; }
        public decimal? CurrentValue { get; set; }
        public string Remarks { get; set; }
        public string UpdatedBy { get; set; }
    }

    public class ARPApplicationTxnLovs
    {
        public int? ApplicantStaffId { get; set; }
        public string ApplicantStaffName { get; set; }
        public string ApplicantDesignation { get; set; }

        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> BER2EstimateLifeTimeLovs { get; set; }
        public List<LovValue> NotReliableLovs { get; set; }
        public List<LovValue> StatuaryRequirementLovs { get; set; }
        public List<LovValue> BER1StatusLovs { get; set; }

        public List<LovValue> SelectProposal { get; set; }
        public List<LovValue> BER2TechnicalConditionLovs { get; set; }
        public List<LovValue> BER2SafeReliableLovs { get; set; }
        public int FacilityId { get; set; }
        public string FacilityCode { get; set; }
        public string FacilityName { get; set; }
        public string ApplicantName { get; set; }
        public DateTime CurrentDate { get; set; }
    }

    //---End BERREference----
    public class Proposal
    {
        public string ArpProposalId { get; set; }
        public string Model { get; set; }
        public string Brand { get; set; }
        public string Manufacture { get; set; }
        public string EstimationPrice { get; set; }
        public string SupplierName { get; set; }
        public string ContactNo { get; set; }
        public string ARPID { get; set; }
        public int PROP_ID { get; set; }


    }
    public class FirstProposal
    {
        public int PROP_ID { get; set; }
        public string ArpProposalId { get; set; }
        public string Model1 { get; set; }
        public string Brand1 { get; set; }
        public string Manufacture1 { get; set; }
        public string EstimationPrice1 { get; set; }
        public string SupplierName1 { get; set; }
        public string ContactNo1 { get; set; }
        public List<FileUploadDetModel> FileUploadList { get; set; }
        public string ARPID { get; set; }



    }
    public class SecondProposal
    {
        public int PROP_ID { get; set; }
        public string ArpProposalId { get; set; }
        //public List<FirstProposal> SelectedProposal { get; set; }
        public string Model2 { get; set; }
        public string Brand2 { get; set; }
        public string Manufacture2 { get; set; }
        public string EstimationPrice2 { get; set; }
        public string SupplierName2 { get; set; }
        public string ContactNo2 { get; set; }
        public string ARPID { get; set; }



        public int RejectedApplicationId { get; set; }
        public string BERno { get; set; }
        public string BERStatusName { get; set; }
        public int BERStatusLovId { get; set; }
        public int BERStage { get; set; }

    }
    public class ThirdProposal
    {
        //public List<SecondProposal> SelectedProposal { get; set; }
        public string ArpProposalId { get; set; }
        public string Model3 { get; set; }
        public string Brand3 { get; set; }
        public string Manufacture3 { get; set; }
        public string EstimationPrice3 { get; set; }
        public string SupplierName3 { get; set; }
        public string ContactNo3 { get; set; }
        public string ARPID { get; set; }
        public int PROP_ID { get; set; }

    }

    public class FinalProposal
    {
        public string ArpProposalId { get; set; }
        public List<LovValue> SelectedProposal { get; set; }


        //public List <ThirdProposal> SelectedProposal { get; set; }
        public string Justification { get; set; }
        public string ARPID { get; set; }


    }



    public class FileUploadDetModels
    {
        public string DocumentGuId { get; set; }
        public int DocumentId { get; set; }
        public string GuId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentDescription { get; set; }
        public int DocumentCategory { get; set; }
        public string DocumentCategoryOthers { get; set; }
        public string DocumentExtension { get; set; }
        public int MajorVersion { get; set; }
        public int MinorVersion { get; set; }
        public string FileName { get; set; }
        public int FileType { get; set; }
        public string FilePath { get; set; }
        public DateTime? UploadedDateUTC { get; set; }
        public int ScreenId { get; set; }
        public string Remarks { get; set; }
        public int UploadedBy { get; set; }
        public DateTime? UploadedDate { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public string contentAsBase64String { get; set; }
        public bool Active { get; set; }
        public string ContentType { get; set; }
        public bool IsDeleted { get; set; }

    }

    public class ArpGridData
    {
        public string BERNo { get; set; }
        public string ConditionAppraisalRefNo { get; set; }
        public string AssetNo { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AreaName { get; set; }
        public string LocationName { get; set; }

    }

}
