using System;
using System.Collections.Generic;
using CP.UETrack.Models;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
    public class BulkAuthorizationViewModel
    {
        public List<BulkAuthorizationListData> BulkAuthorizationListData { get; set; }
        public List<LovValue> ServiceData { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }

    }

    public class BulkAuthorizationListData
    {
        public int VariationId { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string UserLocationName { get; set; }
        public string SNFDocumentNo { get; set; }
        public string VariationStatus { get; set; }
        public decimal PurchaseProjectCost { get; set; }
        public DateTime? CommissioningDate { get; set; }
        public DateTime? StartServiceDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public DateTime? VariationDate { get; set; }
        public DateTime? ServiceStopDate { get; set; }
        public bool? AuthorizedStatus { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public int CreatedBy { get; set; }
        public int ModifiedBy { get; set; }
        public string Timestamp { get; set; }
        public bool BuiltIn { get; set; }
        public string GuId { get; set; }
    }
}
