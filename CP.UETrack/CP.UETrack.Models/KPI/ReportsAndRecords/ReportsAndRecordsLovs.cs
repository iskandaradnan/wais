
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class ReportsAndRecordsLovs
    {
        public List<LovValue> Years { get; set; }
        public List<LovValue> Months { get; set; }
        public int CurrentYear { get; set; }
        public int CurrentMonth { get; set; }
    }
}