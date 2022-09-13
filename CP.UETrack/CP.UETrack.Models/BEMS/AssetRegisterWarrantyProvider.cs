using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class AssetRegisterWarrantyProvider //: BaseViewModel
    {
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public int TypeCodeId { get; set; }
        public string TypeCode { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int CategoryId { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public string Timestamp { get; set; }
        public List<AssetRegisterWarrantyProviderGrid> AssetRegisterWarrantyProviderTabGrid { get; set; }
        public List<AssetRegisterWarrantyProviderGrid> AssetRegisterWarrantyProviderTabGrid1 { get; set; }
        public List<AssetRegisterWarrantyProviderGrid> AssetRegisterWarrantyProviderTabGrid2 { get; set; }
        public WarrantyDetails warrantyDetails { get; set; }
    }
    public class WarrantyDetails
    {
        public DateTime? WarrantyStartDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public decimal? WarrantyDuration { get; set; }
        public decimal? PurchaseCostRM { get; set; }
    }
    public class AssetRegisterWarrantyProviderGrid
    {
        public int AssetId { get; set; }
        public int CategoryId { get; set; }
        public string Category { get; set; }
        public int SupplierWarrantyId { get; set; }
        public int? ContractorId { get; set; }
        public int CustomerId { get; set; }
        public string SSMNo { get; set; }
        public string ContractorName { get; set; }
        public string Address { get; set; }
        public string ContactNo { get; set; }
        public string ContactPerson { get; set; }
        public string Email { get; set; }
        public string FaxNo { get; set; }
        public string Timestamp { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Designation { get; set; }
        public bool IsDeleted { get; set; }
       
    }

    public class WarrantyProviderCategoryLov
    {
        public List<LovValue> CategoryLovMain { get; set; }
        public List<LovValue> CategoryLovLar { get; set; }
        public List<LovValue> CategoryLovthirdparty { get; set; }
    }
}
