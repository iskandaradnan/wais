using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.MASTER
{
    class MasterDetails
    {

        public int Common_Id { get; set; }
        public int BlockId { get; set; }      
        public int LevelId { get; set; }
        public int UserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public DateTime ActiveFromDate { get; set; }
        public DateTime ActiveFromDateUTC { get; set; }
        public DateTime ActiveToDate { get; set; }
        public DateTime ActiveToDateUTC { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public string B_ShortName { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public string L_ShortName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string U_ShortUserAreaName { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string U_UserLocationName { get; set; }
        public string TypeOfRequest { get; set; }
        public string Remarks_BlockId { get; set; }
        public string Remarks_LevelId { get; set; }
        public string Remarks_UserAreaId { get; set; }
        public string Remarks_UserLocationId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string GuId { get; set; }
        public string BuiltIn { get; set; }
    }

    public class MasterBlockViewModel
    {
        public string HiddenId { get; set; }
        public int BlockId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public string ShortName { get; set; }
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
        public int Active { get; set; }
        public bool BuiltIn { get; set; }

    }
    public class MasterLevelViewModel
    {
        public string HiddenId { get; set; }
        public int LevelId { get; set; }
        public int CustomerId { get; set; }
        public int BlockId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string LevelCode { get; set; }
        public string LevelName { get; set; }
        public string ShortName { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
    }
    public class MasterLocationUserAreaViewModel
    {
        public int UserAreaId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int BlockId { get; set; }
        public int LevelId { get; set; }
        public string UserLevelCode { get; set; }
        public string UserLevelName { get; set; }
        public string LevelName { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string HiddenId { get; set; }
        public string UserAreaDescription { get; set; }
        public int CompanyStaffId { get; set; }
        public string CompanyStaffName { get; set; }
        public int HospitalStaffId { get; set; }
        public string HospitalStaffName { get; set; }
        public string Remarks { get; set; }
        public System.DateTime ActiveFromDate { get; set; }
        public System.DateTime ActiveFromDateUTC { get; set; }
        public System.DateTime? ActiveToDate { get; set; }
        public System.DateTime? ActiveToDateUTC { get; set; }
        public string Operation { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public string StatusValue { get; set; }
        public string Status { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public bool isStartDateFuture { get; set; }
    }

    public class MasterAreaLovs
    {
        public int LevelId { get; set; }
        public int BlockId { get; set; }
        public int FacilityId { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
    }
    public class MasterLocationUserLocation
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
        public System.DateTime? ActiveToDateUTC { get; set; }
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

    public class MasterLocationUserLocationLovs
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
