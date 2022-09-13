using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.CLS
{
    public class JIScheduleGeneration
    {
        public int JIId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public string MonthName { get; set; }
        public int Week { get; set; }      
        public List<JISchedule> ScheduleList { get; set; }

    }

    public class JISchedule:FetchPagination
    {
        public int ScheduleId { get; set; }
        public int StatusId { get; set; }
        public string DocumentNo { get; set; }
        public string UserAreaLocations { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string Day { get; set; }
        public string TargetDate { get; set; }
        public int Status { get; set; }
    }

    public class JIDropdowns
    {
        public List<LovValue> StatusValues { get; set; }
        public List<LovValue> YearValues { get; set; }
        public List<LovValue> MonthValues { get; set; }
        public List<LovValue> WeekValues { get; set; }
    }       
}
