
using System;

namespace CP.UETrack.Model
{
    public class FacilityActivePeriod
    {
        public DateTime ActiveFrom { get; set; }
        public int ContractPeriod { get; set; }
        public DateTime? ActiveTo { get; set; }
    }
}