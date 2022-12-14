using System;

namespace CP.UETrack.Model.BEMS
{
    public class MstLocationUserLocation
    {       
       public int UserLocationId { get; set; }
        public int UserAreaId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationShortName { get; set; }
        public string UserLocationName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }

        public System.DateTime ActiveFromDate { get; set; }
        public System.DateTime ActiveFromDateUTC { get; set; }
        public DateTime? ActiveToDate { get; set; }
        public System.DateTime ?ActiveToDateUTC { get; set; }
        public int AuthorizedStaffId { get; set; }
        public string AuthorizedStaffName { get; set; }
        public string Timestamp { get; set; }
        public string HiddenId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public string StatusValue { get; set; }
        public int CompanyStaffId { get; set; }
        public string CompanyStaffName { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public bool isStartDateFuture { get; set; }
    }

    public class MstLocationUserLocationLovs
    {
        public int FacilityId { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int UserAreaId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
    }
}
