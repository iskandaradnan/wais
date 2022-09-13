using System;

namespace CP.UETrack.Model
{
    public class StaffMstViewModel
    {

        public int StaffMasterId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string AccessLevel { get; set; }
        public int UMUserRoleId { get; set; }
        public int UserAreaId { get; set; }
        public string StaffEmployeeId { get; set; }
        public string StaffName { get; set; }
        public int EmployeeTypeLovId { get; set; }
        public string EmployeeType { get; set; }
        public int DepartmentId { get; set; }
        public bool IsEmployeeShared { get; set; }
        public int DesignationId { get; set; }
        public string StaffCompetencyId { get; set; }
        public string StaffSpecialityId { get; set; }
        public int? GradeId { get; set; }
        public string Grade { get; set; }
        public int PersonalIdentityTypeLovId { get; set; }
        public int PersonalUniqueId { get; set; }
        public int GenderLovId { get; set; }
        public string Gender { get; set; }
        public int NationalityLovId { get; set; }
        public string Nationality { get; set; }
        public string Email { get; set; }
        public string ContactNo { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime ActiveFromDateUTC { get; set; }
        public DateTime ActiveToDate { get; set; }
        public DateTime ActiveToDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Status { get; set; }
        public bool BuiltIn { get; set; }
    }
}
