using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngPlannerTxn
    {
        //Search Filters
        public string AssetClassificationCode { get; set; }
        public string AssetClassificationDescription { get; set; }
        public string Asset_Name { get; set; }
        public string TaskCode { get; set; }
        public string TotalNoOfAssets { get; set; }
        public string TypeOfPlannerGrid { get; set; }
        public int? PPMFrequency { get; set; }
        public int? FrequencyId { get; set; }
        public string PPMFrequencyValue { get; set; }
        public int TaskCodeType { get; set; }
        public string StatusGrid { get; set; }
        public int PlannerId { get; set; }
        public int ServiceId { get; set; }
        public int Year { get; set; }
        public int WorkGroup { get; set; }
        public int? WorkOrderType { get; set; }
        public string WorkOrderTypeName { get; set; }
        public int? YearName { get; set; }
        public string AssetClarificationName { get; set; }
        public string TypeOfPlannerName { get; set; }
        public string StatusType { get; set; }
        public int? TypeOfPlanner { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string AssetCount { get; set; }
        public int? AssigneeId { get; set; }
        public int? hdnStandardTaskDetId { get; set; }
        public string Assignee { get; set; }
        public int? HospitalRepresentativeId { get; set; }
        public string HospitalRepresentative { get; set; }
        public int? FacRepId { get; set; }
        public string FacRep { get; set; }
        public string Month { get; set; }
        public string Week { get; set; }
        public string Day { get; set; }

        public int? AssetClarification { get; set; }
        public int WarrentyType { get; set; }     
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string TypeCode { get; set; }
        public string TypeCodeDescription { get; set; }
        public int? AssetRegisterId { get; set; }
        public string AssetNo { get; set; }
        public string Model { get; set; }
        public string Manufacturer { get; set; }
        public string SerialNumber { get; set; }
        public int? StandardTaskDetId { get; set; }
        public string PPMTaskCode { get; set; }
        public int PPMCheckListId { get; set; }
        public string PPMTaskDescription { get; set; }
        public DateTime WarrentyEndDate { get; set; }
        public string WarrantyEndDateString { get; set; }
        public string ContractEndDateString { get; set; }
        public string SupplierName { get; set; }
        public DateTime ContractEndDate { get; set; }
        public DateTime? FirstDate { get; set; }
        public DateTime? NextDate { get; set; }
        public DateTime? LastDate { get; set; }
        public string ContractorName { get; set; }
        public string Engineer { get; set; }
        public int? EngineerId { get; set; }
        public String ContactNumber { get; set; }
        public int TaskCodeOption { get; set; }
        public DateTime? AgreedDate { get; set; }
        public string TaskCodeOptionValue { get; set; }
        public String ContactNo { get; set; }
        public int JobTrade { get; set; }
        public int? Schedule { get; set; }
        public string ScheduleType { get; set; }
        public string Date { get; set; }
        public int? Status { get; set; }
        public string ErrorMessage { get; set; }
        public string Timestamp { get; set; }
        public string PlannerType { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }


        public string FieldValue { get; set; }
        public int PPFrequency { get; set; }
        public int AQuantityText { get; set; }

        public List<EngPlannerTxn> RIPlannerPopUPDets { get; set; }
        public List<EngPlannerSummaryTxn> SummaryDets { get; set; }
        public List<PMFrequency> PFrequency { get; set; }

        public List<LovValue> ServiceList { get; set; }

    }

    public class PMFrequency
    {
        public int IsDefault { get; set; }

        public int LovId { get; set; }

        public string FieldValue { get; set; }
        public string TTaskCode { get; set; }
    }

    public class PPMPlannerLovs
    {      
        public List<LovValue> ServiceList { get; set; }
        public List<SelectListLookup> YearList { get; set; }
        public List<LovValue> WorkGroupList { get; set; }
        public List<LovValue> WorkOrderTypeList { get; set; }
        public List<LovValue> TypeOfPlannerList { get; set; }
        public List<LovValue> AssetClarificationList { get; set; }
        public List<LovValue> WarrentyTypeList { get; set; }
        public List<LovValue> JobTradeList { get; set; }
        public List<LovValue> ScheduleList { get; set; }
        public List<LovValue> DateList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<LovValue> TaskCodeOptionList { get; set; }
        public List<LovValue> FrequencyList { get; set; }
        
        public int CurrentYear { get; set; }
        public int CurrentMonth { get; set; }
    }
    public class EngPlannerSummaryTxn
    {
        public string AssetNo { get; set; }
        public string AssetName { get; set; }
        public string TaskCode { get; set; }
        public string AssetDescription  { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public bool Week1 { get; set; }
        public bool Week2 { get; set; }
        public bool Week3 { get; set; }
        public bool Week4 { get; set; }
        public bool Week5 { get; set; }
        public bool Week6 { get; set; }
        public bool Week7 { get; set; }
        public bool Week8 { get; set; }
        public bool Week9 { get; set; }
        public bool Week10 { get; set; }
        public bool Week11 { get; set; }
        public bool Week12 { get; set; }
        public bool Week13 { get; set; }
        public bool Week14 { get; set; }
        public bool Week15 { get; set; }
        public bool Week16 { get; set; }
        public bool Week17 { get; set; }
        public bool Week18 { get; set; }
        public bool Week19 { get; set; }
        public bool Week20 { get; set; }
        public bool Week21 { get; set; }
        public bool Week22 { get; set; }
        public bool Week23 { get; set; }
        public bool Week24 { get; set; }
        public bool Week25 { get; set; }
        public bool Week26 { get; set; }
        public bool Week27 { get; set; }
        public bool Week28 { get; set; }
        public bool Week29 { get; set; }
        public bool Week30 { get; set; }
        public bool Week31 { get; set; }
        public bool Week32 { get; set; }
        public bool Week33 { get; set; }
        public bool Week34 { get; set; }
        public bool Week35 { get; set; }
        public bool Week36 { get; set; }
        public bool Week37 { get; set; }
        public bool Week38 { get; set; }
        public bool Week39 { get; set; }
        public bool Week40 { get; set; }
        public bool Week41 { get; set; }
        public bool Week42 { get; set; }
        public bool Week43 { get; set; }
        public bool Week44 { get; set; }
        public bool Week45 { get; set; }
        public bool Week46 { get; set; }
        public bool Week47 { get; set; }
        public bool Week48 { get; set; }
        public bool Week49 { get; set; }
        public bool Week50 { get; set; }
        public bool Week51 { get; set; }
        public bool Week52 { get; set; }
        public bool Week53 { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }

    }
    public class PlannerUpload
    {
        public int PlannerId { get; set; }
        public string contentAsBase64String { get; set; }
        public string contentType { get; set; }
        public string fileResponseName { get; set; }
    }

    public class PlannerExport
    {
        public string WorkOrderType { get; set; }
        public string Year { get; set; }
        public string Assignee { get; set; }
        public string AssetClassification { get; set; }
        public string PPMType { get; set; }
        public string TypeCode { get; set; }
        public string TypeCodeDescription { get; set; }
        public string AssetNo { get; set; }
        public string PPMTaskCode { get; set; }
        public string Schedule { get; set; }
        public string Status { get; set; }
        public string Month { get; set; }
        public string Date { get; set; }
        public string Week { get; set; }
        public string Day { get; set; }
    }

}
