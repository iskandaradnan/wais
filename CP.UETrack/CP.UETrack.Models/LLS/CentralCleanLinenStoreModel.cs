using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class CentralCleanLinenStoreModel
    {
        public int CCLSId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string StoreType { get; set; }      
        public int CCLSDetId { get; set; }
        public int LinenItemId { get; set; }
       
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public List<CentralCleanLinenStoreModelList> CentralCleanLinenStoreModelListData { get; set; }
    }

    public class CentralCleanLinenStoreModelList
    {
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public decimal StoreBalance { get; set; }
        public decimal StockLevel { get; set; }
        public decimal ReorderQuantity { get; set; }
        public decimal Par1 { get; set; }
        public decimal Par2 { get; set; }
        public int TotalRequirement { get; set; }
        public int RepairQuantity { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
    }
    public class CentralCleanLinenStoreModelLovs
    {
        public List<LovValue> StoreType { get; set; }

    }
}
