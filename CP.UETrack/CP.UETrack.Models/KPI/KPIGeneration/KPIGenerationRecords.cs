
using System;

namespace CP.UETrack.Model
{
    public class KPIGenerationRecord
    {
        public int IndicatorDetId { get; set; }
        public string IndicatorNo { get; set; }
        public string IndicatorName { get; set; }
        public int TotalDemeritPoints { get; set; }
        public decimal DeductionValue { get; set; }
        public decimal DeductionPer { get; set; }
    }
}
