using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class CorrectiveActionReportLovs
    {
        public List<LovValue> QAPPriorityValue { get; set; }
        public List<LovValue> QAPStatusValue { get; set; }
        public List<LovValue> Responsibilities { get; set; }
        public List<LovValue> Indicators { get; set; }
        public List<LovValue> FailureSymptomCodes { get; set; }
        public List<LovValue> RootCauses { get; set; }
        public List<LovValue> SelectedIndicators { get; set; }
        public List<LovValue> ServiceData { get; set; }
    }
}