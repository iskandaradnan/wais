using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Home
{
    public class HomeDashboard
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string CurrencyFormat { get; set; }
        public List<WorkorderChart> WorkorderChartData { get; set; }
        public List<MaintenanceCostChart> MaintenanceCostChartData { get; set; }
        public List<EquipmentUptimeChart> EquipmentUptimeChartData { get; set; }
        public List<AssetChart> AssetChartData { get; set; }
        public List<PPMRegChart> PPMRegChartData { get; set; }
        public List<AssetAgeChart> AssetAgeChartData { get; set; }       
        public List<ContractorChart> ContractorChartData { get; set; }

    }
    public class WorkorderChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int WorkOrdStatusId { get; set; }
        public string WorkOrdStatus { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }

    }
    public  class MaintenanceCostChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public string MaintenCat { get; set; }
        public decimal Cost { get; set; }
        public string Col { get; set; }
    }
    public class EquipmentUptimeChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int EquipCatId { get; set; }
        public string EquipCat { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
        public decimal Percentage { get; set; }
    }
    public class AssetChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public string AssetStatus { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
    }
    public class PPMRegChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public string PPMStatus { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
    }
    public class AssetAgeChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public int AgeGroupId { get; set; }
        public string AgeGroup { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
    }

    public class ContractorChart
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int StartYear { get; set; }
        public int StartMonth { get; set; }
        public int EndYear { get; set; }
        public int EndMonth { get; set; }
        public string ConStatus { get; set; }
        public int Count { get; set; }
        public string Col { get; set; }
    }

    public class permission
    {
        public int FacilityId { get; set; }
        public int UserId { get; set; }
        public int ScreenId { get; set; }
        public string ScreenName { get; set; }
        public List<permissionChart> permissionChartData { get; set; }
    }
        public class permissionChart
        {
            public int FacilityId { get; set; }
            public int UserId { get; set; }
            public int ScreenId { get; set; }
            public string ScreenName { get; set; }
        }
    
}
