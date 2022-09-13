
using System;

namespace CP.UETrack.Model
{
    public class TAndCWarrnty
    {
        public DateTime WarrantyStartDate { get; set; }
        public int WarrantyDuration { get; set; }
        public DateTime? WarrantyEndDate { get; set; }
        public int WarrantyStatus { get; set; }
    }
}