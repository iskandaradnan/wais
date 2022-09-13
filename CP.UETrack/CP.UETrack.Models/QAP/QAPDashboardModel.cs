using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.QAP
{
    public class QAPDashboardModel
    {
        public int Year { get; set; }
        public int FacilityId { get; set; }
        public int QAPIndicatorId { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }
        public int CustomerId { get; set; }         
        public List<ItemQAPBarChartList> QAPBarChartListData { get; set; }
        public List<ItemQAPLineChartList> QAPLineChartListData { get; set; }

    }
    public class QAPDashboardTypeDropdown
    {
        public List<LovValue> QAPDashboardServiceTypeData { get; set; }
    }
    public class ItemQAPBarChartList
    {
        public int QAPIndicatorId { get; set; }
        public int Year { get; set; }
        public string IndicatorCode { get; set; }
        public decimal ExceptedPercentage { get; set; }
        public decimal ActualPercentage { get; set; }
    }
    public class ItemQAPLineChartList
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public string MonthName { get; set; }
        public decimal B1 { get; set; }
        public decimal B2 { get; set; }
        public decimal B1Percent { get; set; }
        public decimal B2Percent { get; set; }
    }
}
