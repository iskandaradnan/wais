using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class MstWorkingCalenderModel
    {
        public int CalenderId { get; set; }
        public int FacilityId { get; set; }
        public int CustomerId { get; set; }
        public int Year { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public List<MstWorkingCalenderDetModel> MstWorkingCalenderDets { get; set; }
        public List<FacilityWeeklyHolidayMstDetViewModel> FacilityWeeklyHolidayMstDets { get; set; }
        public List<List<MstWorkingCalenderDetModel>> DayDetails { get; set; }
        public IEnumerable<LovValue> Month { get; set; }

    }
    public class FacilityWeeklyHolidayMstDetViewModel
    {
        public int WeeklyHolidayId { get; set; }
        public int FacilityId { get; set; }
        public int WeeklyHoliday { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        public string WeekDayName { get; set; }


    }
    public class MstWorkingCalenderDetModel
    {
        public int CalenderDetId { get; set; }
        public int CalenderId { get; set; }
        public int Month { get; set; }
        public int Day { get; set; }
        public bool IsWorking { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }

        public DateTime CurrentDate { get; set; }
        public int CurrentMonth { get; set; }
        public bool DaysCheck { get; set; }
        public int WeekNo { get; set; }
        public string DayName { get; set; }
        public int Index { get; set; }
        public DateTime Date { get; set; }


    }
    [Serializable]
    public class SelectListLookup 
    {
        public int LovId { get; set; }
        public string FieldCode { get; set; }
        public string FieldValue { get; set; }
        public Nullable<int> ParentId { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsDefault { get; set; }
        public string Remarks { get; set; }
        public int SortNo { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int LastPage { get; set; }
        public int PageIndex { get; set; }
        public int ServiceId { get; set; }
        public string ServiceKey { get; set; }
    }

  
    public class FMWorkingCalendarSelectListViewModel 
    {
        public MstWorkingCalenderModel WorkingCalendar { get; set; }
        public List<int> Year { get; set; }
        public IEnumerable<FacilityListLookup> Facility { get; set; }
        public List<FacilityListLookup> CopyFromState { get; set; }
        public int CalenderId { get; set; }
        public int StateId { get; set; }
        public int CurrentYear { get; set; }
        public int SetYear { get; set; }
        public int Week { get; set; }
        public int StateIdFMS { get; set; }
        public List<List<MstWorkingCalenderDetModel>> DayList { get; set; }
        public IEnumerable<LovValue> Month { get; set; }
        public int FacilityId { get; set; }
        public string TimeStamp { get; set;  }
    }


    public class WorkingCalenderLovs
    {
        public IEnumerable<LovValue> MonthList { get; set; }
        public List<LovValue> StatusList { get; set; }
    }


   

    public class FacilityListLookup
    {
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public int CustomerId { get; set; }
    }

   
}
