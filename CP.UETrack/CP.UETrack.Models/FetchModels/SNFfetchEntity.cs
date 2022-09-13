using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.FetchModels
{
   public class SNFfetchEntity : FetchPagination
    {
        public string SNFDocNo { get; set; }
        public int AssetId { get; set; }
        public int TestingandCommissioningId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int VariationStatusLovId { get; set; }
        public decimal? PurchaseProjectCost { get; set; }
        public DateTime VariationDate { get; set; }
        public DateTime? StartServiceDate { get; set; }
        public DateTime? StopServiceDate { get; set; }
        public DateTime CommissioningDate { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int VariationMonth { get; set; }
        public int VariationYear { get; set; }
        public int? VariationApprovedStatusLovId { get; set; }
        public string VariationStatusLovName { get; set; }
        public DateTime? PurchaseDate { get; set; }
        public string ContractLpoNo { get; set; }
        public bool? AuthorizedStatus { get; set; }

    }
}
