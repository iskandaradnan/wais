using System.Collections.Generic;
using CP.UETrack.Model;
using System;

namespace CP.UETrack.Models.UM
{
    public class ASISUserRegistrationViewModel : BaseViewModel
    {

        public int UserRegistrationId { get; set; }
        public int StaffMasterId { get; set; }
        public string StaffName { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public Nullable<int> Gender { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public Nullable<System.DateTime> DateofJoined { get; set; }
        public Nullable<int> UserTypeId { get; set; }
        public Nullable<int> UserRole { get; set; }
        public Nullable<bool> IsSystemUser { get; set; }
        public Nullable<bool> IsMobileUser { get; set; }
        public Nullable<bool> IsMailSent { get; set; }
        public Nullable<System.DateTime> MailSentTime { get; set; }
        public Nullable<int> ExpiryDuration { get; set; }
        public int LoginAttempt { get; set; }
        //public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int? CompanyId { get; set; }
        public int StateId { get; set; }
        public int? HospitalId { get; set; }
        public int? LocationType { get; set; }
        public string SecurityCode { get; set; }
        public int Status { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int LastPage { get; set; }
        public int startIndex { get; set; }
        public int endIndex { get; set; }
        public bool ExistingStaff { get; set; }
       
        public bool? IsBlocked { get; set; }
        public bool IsStatusDisabled { get; set; }
        public int? InvalidAttempts { get; set; }
        public DateTime? InvalidAttemptDateTime { get; set; }
        public bool ShowUnblock { get; set; }
        public bool IsDepentinStaffMst { get; set; }
        public DateTime? LoginDateTime { get; set; }
        public DateTime? PasswordChangedDateTime { get; set; }
        //For staff Master
     
         public string MobileNumber { get; set; }
    }

    public class SearchParameters
    {
        public List<string> Statuses { get; set; }
        public List<string> UserTyeps { get; set; }
    }

}
