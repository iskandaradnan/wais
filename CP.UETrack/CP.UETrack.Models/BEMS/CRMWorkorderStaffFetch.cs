
namespace CP.UETrack.Model
{
    public class CRMWorkorderStaffFetch
    {
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public int? StaffId { get; set; }
        public string FacilityName { get; set; }
        public string PhoneNumber { get; set; }
        public int? UserDesignationId { get; set; }
        public string Designation { get; set; }
        public string StaffEmail { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int TypeOfRequest { get; set; }

        public int UserAreaId { get; set; }

        public string UserAreaCode { get; set; }

        public string AssetNo { get; set; }
        public int AssetId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserAreaName { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
        public string UserLocationName { get; set; }
        public int UserLocationId { get; set; }
        
    }
}