using System;

namespace CP.UETrack.Model
{
    public class DefectDetails
    {
        public string DefectNo { get; set; }
        public DateTime? DefectDate { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? CompletionDate { get; set; }
        public string ActionTaken { get; set; }
    }
}
