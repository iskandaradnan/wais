using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
    public class VMDashboardModel
    {
        public int FacilityId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }
        public int CustomerId { get; set; }
        public int Group { get; set; }
        public List<ItemVMDashboardList> VMDashboardListData { get; set; }
        
    }
    public class VMDashboardTypeDropdown
    {
        public List<LovValue> Years { get; set; }
        public int CurrentYear { get; set; }
        public int PreviousYear { get; set; }
        public List<LovValue> MonthListTypedata { get; set; }
        public List<LovValue> VMDashboardServiceTypeData { get; set; }

    }
    public class ItemVMDashboardList
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int VMDashboardId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public int TotalCount { get; set; }
        public string StatusName { get; set; }
        
    }
    
}
