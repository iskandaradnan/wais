using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class CleanLinenIssueModel
    {

        public DateTime Delievery1  { get; set; }
        public DateTime Delievery2 { get; set; }
        public int priority1 { get; set; }
        public DateTime RequestDT { get; set; }
        public int delieveryST { get; set; }
        public int Location1 { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string GuId { get; set; }
        public List<cleanLinenLaundryValueLists> cleanLinenLaundryValues { get; set; }
        public List<cleanLinenLaundryValueList> CleanLinenRequestModels { get; set; }
        //public int CLILinenBagId { get; set; }
        public int CleanLinenIssueId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }

        public string StaffName { get; set; }
        public int UserRegistrationId { get; set; }
        public string Designation { get; set; }

        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public int CleanLinenRequestId { get; set; }
        public string DocumentNo { get; set; }
        public string DocumentNos { get; set; }
        public string CLINo { get; set; }
        public string Timestamp { get; set; }
        public DateTime RequestDateTime { get; set; }
        public DateTime DeliveryDate1st { get; set; }
        public DateTime DeliveryDate2nd { get; set; } = DateTime.Now;
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string RequestedBy { get; set; }
        public string RequestedByDesignation { get; set; }
        public string ReceivedBy1stDesignation { get; set; }
        public string ReceivedBy1st { get; set; }
        public string ReceivedBy2nd { get; set; }
        public int SecondReceivedBy { get; set; }
        public string DeliveredBy { get; set; }
        public string ReceivedBy2ndDesignation { get; set; }

        public string DeliveredByDesignation { get; set; }
        public decimal DeliveryWeight1st { get; set; }
        public decimal DeliveryWeight2nd { get; set; }
        public int Priority { get; set; }
        public int Priorityid { get; set; }
        public decimal TotalWeight { get; set; }
        public DateTime DeliveryDateFirst { get; set; }
        public DateTime DeliveryDateSecond { get; set; }
        public DateTime ReceivedByFirst { get; set; }
        public DateTime ReceivedBySecond { get; set; }
        public string Verifier { get; set; }
        public string VerifierDesignation { get; set; }

        public int DeliveryWeightFirst { get; set; }
        public int DeliveryWeightSecond { get; set; }
        public int IssuedOnTime { get; set; }
        public string DeliverySchedule { get; set; }
        public string QCTimeliness { get; set; }
        public int TotalBagRequested { get; set; }

        public int TotalBagIssued { get; set; }
        public int TotalItemRequested { get; set; }
        public int TotalItemIssued { get; set; }
        public int TotalItemShortfall { get; set; }
        public int FirstReceivedBy { get; set; }
    public string ShortfallQC { get; set; }
        public string CLIOption { get; set; }
        public string Remarks { get; set; }
        public int TotalBagShortfall { get; set; }

        public int CLILinenBagId { get; set; }
        public int LaundryBag { get; set; }
        public decimal IssuedQuantity { get; set; }
        public int BL01 { get; set; }
        public int BL02 { get; set; }
        public int BL03 { get; set; }
        public int BL04 { get; set; }
        public int BL05 { get; set; }



        public int CLILinenItemId { get; set; }
        public int LinenitemId { get; set; }
        public int RequestedQuantity { get; set; }
        public decimal DeliveryIssuedQty1st { get; set; }
        public decimal DeliveryIssuedQty2nd { get; set; }



        public int AttachmentID { get; set; }
        public int FileType { get; set; }
        public string FileName { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LLinenIssueItemList> LLinenIssueItemGridList { get; set; }

        public List<LaundrybagItemlist> LaundrybagItemGridList { get; set; }


        //=====================

        public int UserDesignationId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int TxnStatus { get; set; }

    }
    public class CleanLinenIssueModel_Filter
    {

        public DateTime Delievery1 { get; set; }
        public DateTime Delievery2 { get; set; }
        public string priority1 { get; set; }
        public DateTime RequestDT { get; set; }
        public int delieveryST { get; set; }
        public int Location1 { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string GuId { get; set; }
        public List<cleanLinenLaundryValueLists> cleanLinenLaundryValues { get; set; }
        public List<cleanLinenLaundryValueList> CleanLinenRequestModels { get; set; }
        //public int CLILinenBagId { get; set; }
        public int CleanLinenIssueId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }

        public string StaffName { get; set; }
        public int UserRegistrationId { get; set; }
        public string Designation { get; set; }

        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public int CleanLinenRequestId { get; set; }
        public string DocumentNo { get; set; }
        public string DocumentNos { get; set; }
        public string CLINo { get; set; }
        public string CLRNo { get; set; }
        public string Timestamp { get; set; }
        public DateTime RequestDateTime { get; set; }
        public DateTime DeliveryDate1st { get; set; }
        public DateTime DeliveryDate2nd { get; set; } = DateTime.Now;
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string RequestedBy { get; set; }
        public string RequestedByDesignation { get; set; }
        public string ReceivedBy1stDesignation { get; set; }
        public string ReceivedBy1st { get; set; }
        public string ReceivedBy2nd { get; set; }
        public string DeliveredBy { get; set; }
        public string ReceivedBy2ndDesignation { get; set; }

        public string DeliveredByDesignation { get; set; }
        public decimal DeliveryWeight1st { get; set; }
        public decimal DeliveryWeight2nd { get; set; }
        public string Priority { get; set; }
        public int Priorityid { get; set; }
        public decimal TotalWeight { get; set; }
        public DateTime DeliveryDateFirst { get; set; }
        public DateTime DeliveryDateSecond { get; set; }
        public DateTime ReceivedByFirst { get; set; }
        public DateTime ReceivedBySecond { get; set; }
        public string Verifier { get; set; }
        public string VerifierDesignation { get; set; }

        public int DeliveryWeightFirst { get; set; }
        public int DeliveryWeightSecond { get; set; }
        public int IssuedOnTime { get; set; }
        public string DeliverySchedule { get; set; }
        public string QCTimeliness { get; set; }
        public int TotalBagRequested { get; set; }

        public int TotalBagIssued { get; set; }
        public int TotalItemRequested { get; set; }
        public int TotalItemIssued { get; set; }
        public int TotalItemShortfall { get; set; }
        public string ShortfallQC { get; set; }
        public string CLIOption { get; set; }
        public string Remarks { get; set; }
        public int TotalBagShortfall { get; set; }

        public int CLILinenBagId { get; set; }
        public int LaundryBag { get; set; }
        public decimal IssuedQuantity { get; set; }
        public int BL01 { get; set; }
        public int BL02 { get; set; }
        public int BL03 { get; set; }
        public int BL04 { get; set; }
        public int BL05 { get; set; }



        public int CLILinenItemId { get; set; }
        public int LinenitemId { get; set; }
        public int RequestedQuantity { get; set; }
        public decimal DeliveryIssuedQty1st { get; set; }
        public decimal DeliveryIssuedQty2nd { get; set; }



        public int AttachmentID { get; set; }
        public int FileType { get; set; }
        public string FileName { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LLinenIssueItemList> LLinenIssueItemGridList { get; set; }

        public List<LaundrybagItemlist> LaundrybagItemGridList { get; set; }


        //=====================

        public int UserDesignationId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }


    }
    public class LaundrybagItemlist
    {
        public int BL01 { get; set; }
        public int BL02 { get; set; }
        public int BL03 { get; set; }
        public int BL04 { get; set; }
        public int BL05 { get; set; }
        public string Priority { get; set; }


        public int CleanLinenRequestId { get; set; }
    }
        public class LLinenIssueItemList
    {
        public int CLRLinenItemId { get; set; }
      
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public Decimal AgreedShelfLevel { get; set; }
        public decimal DeliveryIssuedQty1st { get; set; }
        public decimal DeliveryIssuedQty2nd { get; set; }
        public Decimal StoreBalance { get; set; }
        public int BalanceOnShelf { get; set; }
        public int CLILinenItemId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
        public int RequestedQuantity { get; set; }
        public int IssuedQuantity { get; set; }
        public Decimal Shortfall { get; set; }
        public string Remarks { get; set; }
        public int LaundryBag { get; set; }
        public int LinenitemId { get; set; }
        public int CleanLinenIssueId { get; set; } 

    }
    public class cleanLinenLaundryValueLists
    {
        public int LaundryBag { get; set; }
        public int CLILinenBagId { get; set; }
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public int RequestedQuantity { get; set; }
        public decimal IssuedQuantity { get; set; }
        public int Shortfall { get; set; }
        public int BalanceOnShelf { get; set; }
        public string Remarks { get; set; }

    }
    public class CleanLinenIssueModelLovs
    {
        public List<cleanLinenLaundryValueLists> cleanLinenLaundryValues { get; set; }
        public List<LovValue> DeliverySchedule { get; set; }
        public List<LovValue> QCTimeliness { get; set; }
        public List<LovValue> ShortfallQC { get; set; }
        public List<LovValue> Priority { get; set; }
        public List<LovValue> CLIOption { get; set; }
        public List<LovValue> IssuedOnTime { get; set; }
        public List<LovValue> LaundryBag { get; set; }
    }
}