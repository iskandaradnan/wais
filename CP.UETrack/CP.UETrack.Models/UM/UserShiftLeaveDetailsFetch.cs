
namespace CP.UETrack.Model
{
    public class UserShiftLeaveDetailsFetch
    {
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public string MobileNumber { get; set; }
        public string	 UserType { get; set; }
        public string AccessLevel { get; set; }
        public string Role { get; set; }
        public string Designation { get; set; }
        public int FacilityId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}