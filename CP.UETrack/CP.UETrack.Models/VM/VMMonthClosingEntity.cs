using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
  public  class VMMonthClosingEntity
    {
        public int? Month { get; set; }
        public int? Year { get; set; }
    }
    public class MCLovEntity
    {
        public List<LovValue> FMTimeMonth { get; set; }
        public List<LovValue> Yearlist { get; set; }
        public int CurrentYear { get; set; }
        public int PreviousMonth { get; set; }
        public DateTime CutoffDate { get; set; }
    }
    public class FetchMonthClosingDetails
    {
        public int? PageSize { get; set; }
        public string Flag { get; set; }
        public int? PageIndex { get; set; }
        public int? ServiceId { get; set; }
        public int? Month { get; set; }
        public int? Year { get; set; }
        public int? FacilityId { get; set; }
        public List<VariationList> VariationList { get; set; }
    }

    public class VariationList
    {
        public string VariationStatus { get; set; }
        public int Authorised { get; set; }
        public int UnAuthorised { get; set; }
    }
    public class GetallEntity : SortPaginateFilter
    {
        public int VariationId { get; set; }
        public String AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string SNFDocumentNo { get; set; }
       // public int? TotalRecords { get; set; }
        public decimal? TotalPageCalc { get; set; }
        public string VariationStatus { get; set; }
        public string AuthorizedStatus { get; set; }
        public int? Month { get; set; }
        public int? Year { get; set; }
        public int ServiceId { get; set; }
        public string Flag { get; set; }
    }
}
