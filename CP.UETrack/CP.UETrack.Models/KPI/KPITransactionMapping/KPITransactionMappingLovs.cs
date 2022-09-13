using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class KPITransactionMappingLovs
    {
        public List<LovValue> Years { get; set; }
        public List<LovValue> Months { get; set; }
        public List<LovValue> Services { get; set; }
        public int CurrentYear { get; set; }
        public int CurrentMonth { get; set; }
        public List<LovValue> CurrentYearMonths { get; set; }
        public List<LovValue> Indicators { get; set; }
    }
}