
namespace CP.UETrack.Model
{
    public class UserTainingParticipantFetch
    {
        public int StaffMasterId { get; set; }
        public string StaffName { get; set; }
        public string FacilityName { get; set; }
        public int TrainingScheduleId { get; set; }
        public string TrainingScheduleIdAll { get; set; }
        public string Designation { get; set; }
        public int FacilityId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}