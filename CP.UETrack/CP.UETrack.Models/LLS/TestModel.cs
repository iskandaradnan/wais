using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class TestModel
    {
        public int LinenInventoryId { get; set; }
        public int LLSlinenInventoryTxnDetId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string StoreType { get; set; }
        public string DocumentNo { get; set; }
        public DateTime Date { get; set; }
        public int LLSUserAreaId { get; set; }
        public string VerifiedBy { get; set; }
        public string StaffName { get; set; }
        public decimal TotalPcs { get; set; }
        public string Remarks { get; set; }
        public int VerifiedById { get; set; }
        public int LinenItemId { get; set; }
        public int LocLinenItemId { get; set; }
        public string UserAreaCode { get; set; }
        public string LocationCode { get; set; }
        public decimal TotalInUse { get; set; }
        public decimal TotalShelf { get; set; }
        
        public string UserAreaName { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        // public DateTime Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsDelete { get; set; }
        public List<LLinenInventoryclassLinenItemList> LLinenInventoryLinenItemListGrid { get; set; }
        public List<LLinenInventoryclassLinenItemList> LLinenInventoryCCLSListGrid { get; set; }

    }
    public class LLinenInventoryclassLinenItemList
    {
        public decimal CCLSInUse { get; set; }
        public decimal CCLSShelf { get; set; }
        public int LinenItemId { get; set; }
        public decimal UserAreaTotalPcs { get; set; }
        public decimal CCLSTotalPcs { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public string LocationCode { get; set; }
        public string CCLSLinenCode { get; set; }
        public string CCLSLinenDescription { get; set; }
        public decimal StoreBalance { get; set; }
        public decimal InUse { get; set; }
        public decimal Shelf { get; set; }
        public int LinenInventoryId { get; set; }
        public int LlsLinenInventoryTxnDetId { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsDelete { get; set; }
        public decimal TotalPcsA { get; set; }
        public decimal TotalPcsB { get; set; }
        public decimal TotalPcsAB { get; set; }
        public decimal Variance { get; set; }
        public decimal InUsee { get; set; }
        public decimal Shelff { get; set; }


    }

    public class LinenInventoryModelClassLovs
    {
        public List<LovValue> StoreType { get; set; }

    }
}