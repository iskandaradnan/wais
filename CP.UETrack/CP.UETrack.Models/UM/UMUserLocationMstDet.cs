using System;

namespace CP.UETrack.Model.UM
{
    public class UMUserLocationMstDet
    {
        public int LocationId { get; set; } 
        public int UserRegistrationId { get; set; }
        public int? CustomerId { get; set; }
        public int FacilityId { get; set; } 
        public int UserRoleId { get; set; } 
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; } 
        public DateTime CreatedDateUTC { get; set; } 
        public int? ModifiedBy { get; set; } 
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; } 
        public int BuiltIn { get; set; } 
    }
}
