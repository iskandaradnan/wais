using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.KPI
{
    public class KPIDashboardModel
    {
        public int FacilityId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }
        public int CustomerId { get; set; }
        public int Group { get; set; }        
        public List<ItemKPIDashboardList> KPIDashboardListData { get; set; }
        public List<ItemKPIDashboardChartList> KPIDashboardChartListData { get; set; }
    }
    public class KPIDashboardTypeDropdown
    {
        public List<LovValue> Years { get; set; }
        public int CurrentYear { get; set; }
        public int PreviousYear { get; set; }
        public List<LovValue> MonthListTypedata { get; set; }        

    }
    public class ItemKPIDashboardList
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int KPIDashboardId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public decimal MSF { get; set; }
        public decimal DeductionPercentage { get; set; }
        public decimal PenaltyValue { get; set; }
        public decimal DeductionValue { get; set; }
        public decimal PenaltyPercentage { get; set; }
    }
    public class ItemKPIDashboardChartList
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int MonthId { get; set; }
        public string MonthName { get; set; }
        public int KPIDashboardId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public decimal MSF { get; set; }
        public decimal DeductionPercentage { get; set; }
        public decimal PenaltyValue { get; set; }
        public decimal DeductionValue { get; set; }
        public decimal PenaltyPercentage { get; set; }
    }
}
