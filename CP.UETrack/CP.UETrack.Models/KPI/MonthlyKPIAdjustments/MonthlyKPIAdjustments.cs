
using System;

namespace CP.UETrack.Model
{
    public class MonthlyKPIAdjustments
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int UserId { get; set; }
        public string DocumentNo { get; set; }
        public string Remarks { get; set; }
    }
    public class MonthlyKPIAdjustmentFetchResult
    {
        public int IsAdjustmentSaved { get; set; }
        public string IndicatorNo { get; set; }
        public string IndicatorName { get; set; }
        public int TotalDemeritPoints { get; set; }
        public decimal DeductionValue { get; set; }
        public decimal DeductionPer { get; set; }
        public int PostDemeritPoints { get; set; }
        public decimal PostDeductionValue { get; set; }
        public decimal PostDeductionPer { get; set; }
        public string DocumentNo { get; set; }
        public string Remarks { get; set; }
    }
}