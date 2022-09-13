using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class DailyTemperatureLog : FetchPagination
    {
        public int DailyId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }        
        public List<DailyDate> dailyTemperatureLogsList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }
    public class DailyDate
    {
        public int TemperatureId { get; set; }
        public DateTime Date { get; set; }
        public string TemperatureReading { get; set; }
        public bool isDeleted { get; set; }
    }
    public class DailyDropDowns
    {
        public List<LovValue> DailyYearValues { get; set; }
        public List<LovValue> DailyMonthValues { get; set; }
        public List<LovValue> TemperatureReadingValues { get; set; }
    }
}
