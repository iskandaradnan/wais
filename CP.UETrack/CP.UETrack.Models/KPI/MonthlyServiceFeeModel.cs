using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.KPI
{
    public class MonthlyServiceFeeModel
    {
        public int MonthlyFeeId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string FacilityCode { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public decimal BemsMSF { get; set; }
        public decimal BemsCF { get; set; }
        public decimal DeductionMSF { get; set; }
        public decimal TotalFee { get; set; }
        public int CurrentYear { get; set; }
        public int ModuleFlag { get; set; }
        public decimal MonthlyServiceFee { get; set; }
        public int VersionNo { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public List<LovValue> VersionListData { get; set; }
        public List<ItemMonthlyServiceFeeList> MonthlyServiceFeeListData { get; set; }
    }
    public class MonthlyServiceFeeTypeDropdown
    {
        public List<LovValue> Yearss { get; set; }
        public int CurrentYear { get; set; }
        public List<LovValue> MonthListTypedata { get; set; }
        public List<ItemVersionNoList> MonthlyVersionTypedata { get; set; }
        
    }

   
    public class ItemMonthlyServiceFeeList
    {
        public int MonthlyFeeDetId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int MonthlyFeeId{ get; set; }
        public int Month{ get; set; }
        public string MonthlyFeeMonth { get; set; }
        public int VersionNo { get; set; }
        public decimal BemsMSF { get; set; }
        public decimal BemsCF { get; set; }
        public decimal DeductionMSF { get; set; }
        public decimal BemsPercent { get; set; }
        public decimal TotalFee { get; set; }
        public decimal FemsMSF{ get; set; }
        public decimal FemsCF { get; set; }
        public decimal FemsPercent{ get; set; }
        public bool IsAmdGenerated { get; set; }
        public int AmdUserId { get; set; }
        public DateTime AmdDate { get; set; }
        public DateTime AmdDateUTC { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }              
       
    }

    public class ItemVersionNoList
    {
        public int VersionNo { get; set; }
        public int Year { get; set; }
    }
}
