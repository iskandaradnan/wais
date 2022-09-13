using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;

namespace CP.UETrack.Model.LLS
{
    public class CleanLinenRequestModel
    {
       // public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string GuId { get; set; }
        public int CLRLinenItemId { get; set; }
        public int CleanLinenIssueId { get; set; }
    public List<cleanLinenLaundryValueList> cleanLinenLaundryValue { get; set; }
        public int LinenItemId { get; set; }
        public int CleanLinenRequestId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime RequestDateTime { get; set; }
        public int LLSUserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int LocationCode { get; set; }
        public string LocationName { get; set; }
        public string Timestamp { get; set; }
        public string Designation { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public string RequestedBy { get; set; }
        public string Priority { get; set; }
        public int TotalBagRequested { get; set; }
        public string UserLocationName { get; set; }
        public int TotalLinenItemShortfall { get; set; }
        public string UserLocationCode { get; set; }
        public string DeliverySchedule { get; set; }
        public int TotalItemIssued { get; set; }
        public int TotalItemRequested { get; set; }
        public int BalanceOnShelf { get; set; }
        public string IssuedonTime { get; set; }
        public string DeliveryWindow { get; set; }
        public string QCTimeliness { get; set; }
        public string ShortfallQC { get; set; }
        public string IssueStatus { get; set; }
        public int CLRLinenBagID { get; set; }
        public string LaundryBag { get; set; }
        public int RequestedQuantity { get; set; }
        public int IssuedQuantity { get; set; }
        public int Shortfall { get; set; }
        public int LinenShortfall { get; set; }
        public string Remarks { get; set; }
        public string Remarks1 { get; set; }
        public int TotalLinenItemsRequested { get; set; }
        public int TotalLinenItemsIssued { get; set; }
        public int TotalLinenItemsShortfall { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int AgreedShelfLevel { get; set; }
        public int DeliveryIssuedQty1st { get; set; }
        public int DeliveryIssuedQty2nd { get; set; }
        public int StoreBalance { get; set; }


        public int UserAreaId { get; set; }
        public int AttachmentID { get; set; }
        public int FileType { get; set; }
        public string FileName { get; set; }

        public int  PageIndex { get; set; }

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        //==Child2 Table=======
        public List<LLinenRequestItemList> LLinenRequestItemGridList { get; set; }


        //=====================
        public string StaffName { get; set; }
        public int UserRegistrationId { get; set; }

        public int TxnStatus { get; set; }




    }
    public class cleanLinenLaundryValueList
    {
        public int CleanLinenIssueId { get; set; }
        public int CLRLinenBagId { get; set; }
        public string FieldValue { get; set; }
        public string Remarks { get; set; }
        public int LovId { get; set; }
        public int LinenItemId { get; set; }
        public int RequestedQuantity { get; set; }

        public int CleanLinenRequestId { get; set; }
        public int IssuedQuantity { get; set; }
        public int Shortfall { get; set; }
        public int BalanceOnShelf { get; set; }
    }
    public class LLinenRequestItemList
    {
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public Decimal AgreedShelfLevel { get; set; }
        public Decimal DeliveryIssuedQty1st { get; set; }
        public Decimal DeliveryIssuedQty2nd { get; set; }
        public Decimal StoreBalance { get; set; }
        public int BalanceOnShelf { get; set; }
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
        public int LinenItemId { get; set; }
        public Decimal Shortfall { get; set; }
        public int CLRLinenItemId { get; set; }
    }
    public class CleanLinenRequestModelLovs
    {
        public List<LovValue> IssuedonTime { get; set; }
        public List<LovValue> DeliveryWindow { get; set; }
        public List<LovValue> Priority { get; set; }
        public List<LovValue> QCTimeliness { get; set; }
        public List<LovValue> ShortfallQC { get; set; }
        public List<LovValue> IssueStatus { get; set; }
        public List<cleanLinenLaundryValueList> cleanLinenLaundryValue { get; set; }
    }

    public class UserAreaFetchs : FetchPagination
    {
        public int UserLocationId { get; set; }
        public int UserAreaId { get; set; }
        public string AssetCount { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public int CompRepId { get; set; }
        public int FacRepId { get; set; }
        public string CompRep { get; set; }
        public string FacRep { get; set; }
        public string CompRepEmail { get; set; }
        public string FacRepEmail { get; set; }
        public string ActiveFromDate { get; set; }
        public string ActiveToDate { get; set; }

        public int FacilityId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }

        public string FacilityCode { get; set; }
        public string LinenCode { get; set; }
        public int LinenItemId { get; set; }
        public string LinenDescription { get; set; }

        public string StaffName { get; set; }
        public int LLSUserAreaId { get; set; }

        public int UserRegistrationId { get; set; }


    }
}
