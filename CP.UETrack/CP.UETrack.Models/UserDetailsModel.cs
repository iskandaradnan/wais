using System;

namespace CP.UETrack.Model
{
    [Serializable]
    public class UserDetailsModel
    {
        public int UserId { get; set; }
        public string UserName { get; set; }
        public int UserTypeId { get; set; }
        public string Language { get; set; }
        public int SearchPopupPageSize { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string CustomerName { get; set; }
        public string FacilityName { get; set; }
        public int ServiceId { get; set; }
        public string FacilityCode { get; set; }
        public string StaffName { get; set; }
        public string DateFormat { get; set; }
        public string Currency { get; set; }
        public int UserRoleId { get; set; }
        public string UserRoleName { get; set; }
        public int AccessLevel { get; set; }
        public int ThemeColorId { get; set; }
        public string ThemeColorName { get; set; }
        public int UserDB { get; set; }
        public int BEMS { get; set; }
        public int FEMS { get; set; }
        public int CLS { get; set; }
        public int LLS { get; set; }
        public int HWMS { get; set; }
        public int ICT { get; set; }
        
        public int BEMSUserId { get; set; }
        public int FEMSUserId { get; set; }
        public int CLSUserId { get; set; }
        public int HWMSUserId { get; set; }

        public int HospitalId { get; set; }
        public string HospitalCode { get; set; }
        public string HospitalName { get; set; }
        public int ConsortiaId { get; set; }
        public int CompanyId { get; set; }
        public string CompanyName { get; set; }

        public bool IsMOH { get; set; }
        public int LevelOfAccess { get; set; }
        public int ModuleId { get; set; }
        public int MenuId { get; set; }
        public string VisitorSessionId { get; set; }
    }
}
