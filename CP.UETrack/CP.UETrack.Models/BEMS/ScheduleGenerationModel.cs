using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class ScheduleGenerationModel
    {
        public int PpmScheduleId { get; set; }
        public int ServiceId { get; set; }
        public int Year { get; set; }
        public int WorkGroup { get; set; }
        public int TypeOfPlanner { get; set; }
        public int? UserAreaId { get; set; }
        public int? UserLocationId { get; set; }
        public string WeekNo { get; set; }
        public string AssetType { get; set; }
        public bool IsParentChildAvailable { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; } 
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public List<ScheduleGenerationDetModel> ScheduleDets { get; set; }
        public int skipweek { get; set; }
        public string WeekLogId { get; set; }

    }

    public class ScheduleGenerationDetModel
    {
        public string SNo { get; set; }
        public string AssetNo { get; set; }
        public string UserArea { get; set; }
        public string WorkOrder { get; set; }
        public string WorkGroupCode { get; set; }
        public string AssetType { get; set; }
        public bool IsParentChildAvailable { get; set; }
        public DateTime WorkOrderDate { get; set; }
        public DateTime TargetDate { get; set; }
        public string TypeOfPlanner { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
        public string Status { get; set; }
    }
        public class ScheduleGenerationLovs
    {      
        public List<LovValue> ServiceList { get; set; }
        public List<SelectListLookup> YearList { get; set; }
        public List<LovValue> WorkGroupList { get; set; }
        public List<LovValue> TypeOfPlannerList { get; set; }
        public int ServiceDB { get; set; }
        public List<LovValue> WorkGroup { get; set; }
    }
    public class workorde_week
    {
        public int id { get; set; }
        public int Uniq { get; set; }

        public int WeekLogId { get; set; }

        public string Status { get; set; }
        public int WorkOrderId { get; set; }
        public int WeekNo { get; set; }
        public DateTime TargetDateTime { get; set; }
        public DateTime WeekStartDate { get; set; }
        public DateTime WeekEndDate { get; set; }
        public DateTime CreatedDate { get; set; }
        public int Year { get; set; }
        public int FacilityId { get; set; }
        public string type_of_planning { get; set; }
        public string file_name{ get; set; }


    }
}
