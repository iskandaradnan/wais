using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class DepartmentDetailsModel
    {
        public int LLSUserAreaLinenItemId { get; set; }

        public string HiddenId { get; set; }
        public int LLSUserAreaDetId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LLSUserAreaLocationId { get; set; }
        public int UserAreaID { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }

        public int LevelId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }

        public string HospitalRepresentative { get; set; }
        public int hdnHospitalRepresentativeId { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string EmployeeName { get; set; }
        public int Status { get; set; }
        public int? StaffID { get; set; }
        public string TaskCode { get; set; }
        public string TaskDescription { get; set; }


        public DateTime EffectiveFromDate { get; set; } = DateTime.Now;
        public DateTime EffectiveToDate { get; set; } = DateTime.Now;
        public DateTime LAADStartTimess{ get; set; }

        public DateTime? EffectiveFromDates { get; set; }
        public DateTime? EffectiveToDates { get; set; }
        public DateTime? LastModifiedDateandTime { get; set; }

        public int WhiteBag { get; set; }
        public int RedBag { get; set; }
        public int GreenBag { get; set; }
        public int BrownBag { get; set; }
        public int AlginateBag { get; set; }
        public int SoiledLinenBagHolder { get; set; }
        public int SoiledLinenRack { get; set; }
        public int RejectLinenBagHolder { get; set; }
        public Nullable<System.TimeSpan> LAADStartTime { get; set; }
        public DateTime? LAADStartTimes { get; set; }
        public Nullable<System.TimeSpan> LAADEndTime { get; set; }

        public string CleaningSanitizing { get; set; }
        public int LinenItemId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public bool IsDeleted { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }

        public bool Active { get; set; }
        public string OperatingDays { get; set; }
        public string DayList { get; set; }
        public string test { get; set; }

        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public String LinenSchedule { get; set; }


        //==Child1 Table=======
        public List<UserAreaDetailsLocationList> UserAreaDetailsLocationGridList { get; set; }
        //=====================


        //==Child2 Table=======
        public List<LUserAreaDetailsLinenItemList> LUserAreaDetailsLinenItemGridList { get; set; }


        //=====================
    }

    public class LUserAreaDetailsLinenItemList
    {
        public int LLSUserAreaLocationId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int LLSUserAreaLinenItemId { get; set; }
        public string UserLocationCode { get; set; }
        public int UserLocationId { get; set; }
        public int LLSUserAreaId { get; set; }
        public int LinenItemId { get; set; }
        public Decimal Par1 { get; set; }
        public Decimal Par2 { get; set; }
        public Decimal AgreedShelfLevel { get; set; }
        public int DefaultIssue { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDelete { get; set; }
    }

    public class UserAreaDetailsLocationList
    {
        public int LLSUserAreaLocationId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserLocationName { get; set; }
        public int LLSUserAreaId { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserAreaName { get; set; }
        public String LinenSchedule { get; set; }
        public Nullable<System.TimeSpan> FirstScheduleStartTime { get; set; }
        public Nullable<System.TimeSpan> SecondScheduleStartTime { get; set; }
        public Nullable<System.TimeSpan> ThirdScheduleStartTime { get; set; }
        public Nullable<System.TimeSpan> FirstScheduleEndTime { get; set; }
        public Nullable<System.TimeSpan> SecondScheduleEndTime { get; set; }
        public Nullable<System.TimeSpan> ThirdScheduleEndTime { get; set; }

        public bool IsDeleted { get; set; }


        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }


    }
    public class DepartmentDetailsModelLovs
    {
        public List<LovValue> FrequencyList;

        public List<LovValue> StatusList { get; set; }
        public List<LovValue> DayList { get; set; }
        public List<LovValue> OperatingDayList { get; set; }
        public List<LovValue> DefaultIssue { get; set; }
        public List<LovValue> PpmCategoryList { get; set; }
        public List<LovValue> Services { get; set; }

    }
}
