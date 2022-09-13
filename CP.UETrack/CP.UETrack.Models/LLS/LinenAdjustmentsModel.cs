using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class LinenAdjustmentsModel
    {
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int LinenAdjustmentId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime EffectiveDate { get; set; }
        public string StaffName { get; set; }
        public int UserRegistrationId { get; set; }
        public string Designation { get; set; }


        public DateTime DocumentDate { get; set; }
        public string AuthorisedBy { get; set; }
        public int AuthorisedById { get; set; }
        public string LinenInventoryId { get; set; }
        public int hdnTypeCodeId { get; set; }
        public int LinenInventoryIds { get; set; }
        public DateTime? Date { get; set; }
        public string Status { get; set; }
        public string Remarks { get; set; }



        public int LinenAdjustmentDetId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int LinenItemId { get; set; }
        public int ActualQuantity { get; set; }
        public int StoreBalance { get; set; }
        public int AdjustQuantity { get; set; }
        public string Justification { get; set; }



        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public String Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int LinenRepairId { get; set; }

        //==Child2 Table=======
        public List<LLinenAdjustmentLinenItemList> LLinenAdjustmentLinenItemListGrid { get; set; }
        //=====================

    }

    public class LLinenAdjustmentLinenItemList
    {
        public int LinenAdjustmentDetId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int LinenItemId { get; set; }
        public int ActualQuantity { get; set; }
        public Decimal StoreBalance { get; set; }
        public int AdjustQuantity { get; set; }
        public string Justification { get; set; }
        public int LinenAdjustmentId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class LinenAdjustmentsModelLovs
    {
        public List<LovValue> Status { get; set; }
    }
}