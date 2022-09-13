using System;

namespace CP.UETrack.Model
{
    public class UMUserRole
    {
        public int UMUserRoleId { get; set; }
        public int UserTypeId { get; set; }
        public string Name { get; set; }
        public int Status { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public string UserType { get; set; }
        public string StatusValue { get; set; }
        public string UserTypeValue { get; set; }
        public string UserRole { get; set; }
    }
}
