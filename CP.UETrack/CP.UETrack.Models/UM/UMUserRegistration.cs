using CP.UETrack.Model.UM;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class UMUserRegistration
    {
    public int UserRegistrationId { get; set; } 
    public int? StaffMasterId { get; set; }
    public string StaffName { get; set; } 
	public string UserName { get; set; } 
	public string Password { get; set; } 
	public int Gender { get; set; } 
	public string PhoneNumber { get; set; } 
	public string Email { get; set; } 
	public DateTime DateJoined { get; set; } 
	public DateTime DateJoinedUTC { get; set; } 
	public int UserTypeId { get; set; }
    public string UserTypeValue { get; set; }
    public int? CustomerId { get; set; }
    public string CustomerName { get; set; }
    public bool? IsMailSent { get; set; } 
	public DateTime? MailSentTime { get; set; } 
	public DateTime? MailSentTimeUTC { get; set; } 
	public int? ExpiryDuration { get; set; } 
	public int LoginAttempt { get; set; } 
	public int Status { get; set; }
        public string Employee_ID { get; set; }
        public string StatusValue { get; set; }
    public bool? IsBlocked { get; set; } 
	public int? InvalidAttempts { get; set; } 
	public DateTime? InvalidAttemptDateTime { get; set; } 
	public DateTime? InvalidAttemptDateTimeUTC { get; set; } 
	public DateTime? LoginDateTime { get; set; } 
	public DateTime? LoginDateTimeUTC { get; set; } 
	public DateTime? PasswordChangedDateTime { get; set; } 
	public DateTime? PasswordChangedDateTimeUTC { get; set; } 
	public string MobileNumber { get; set; } 
	public bool ExistingStaff { get; set; } 
	public int CreatedBy { get; set; } 
	public DateTime CreatedDate { get; set; } 
	public DateTime CreatedDateUTC { get; set; } 
	public int? ModifiedBy { get; set; } 
	public DateTime? ModifiedDate { get; set; } 
	public DateTime? ModifiedDateUTC { get; set; } 
	public string Timestamp { get; set; } 
	public bool Active { get; set; } 
	public bool BuiltIn { get; set; } 
    public string SelectedUserRole { get; set; }
    public List<UMUserLocationMstDet> LocationDetails { get; set; }
    public List<LovValue> AllLocations { get; set; }
    public List<LovSelectedVisible> LeftLocations { get; set; }
    public List<LovSelected> LocationRole { get; set; }
    public List<LovValue> UserRoles { get; set; }

    //public int AccessLevl { get; set; }
    public int UserRoleId { get; set; }
    public int UserDesignationId { get; set; }
    public int Nationality { get; set; }
    public int UserGradeId { get; set; }
    public string UserCompetencyId { get; set; }
    public int UserDepartmentId { get; set; }
    public string UserSpecialityId { get; set; }
    public int ContractorId { get; set; }   
    public string ContractorName { get; set; }
    public bool IsCenterPool { get; set; }
    public string AccessLevelValue { get; set; }
    public decimal? LabourCostPerHour { get; set; }
    public string Designation { get; set; }
    public string CenterPool { get; set; }
    public int? UserId { get; set; }
    public string ServicesID { get; set; }
        
    }
    public class UMStaffSearch
    {
        public int StaffMasterId { get; set; }
        public string StaffName { get; set; }
        public string StaffEmployeeId { get; set; }
        public string FacilityName { get; set; }
        public int? DesignationId { get; set; }
        public string Designation { get; set; }
        public string StaffEmail { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    };
}
