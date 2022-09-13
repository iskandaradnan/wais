using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.KPI
{
    public class ParameterMasterModel
    {
        public int SubParameterId { get; set; }
        public int ServiceId { get; set; }
        public int Group { get; set; }
        public int IndicatorDetId { get; set; }
        public string IndicatorDesc { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }

        public List<ItemParameterMasterList> ParameterListData { get; set; }

    }
    public class ParameterTypeDropdown
    {
        public List<LovValue> ParameterServiceTypeData { get; set; }
        public List<LovValue> ParameterGroupTypeData { get; set; }
        public List<LovValue> ParameterIndicatorNoTypeData { get; set; }
    }
    public class ItemParameterMasterList
    {
        public int SubParameterDetId { get; set; }
        public int SubParameterId { get; set; }
        public string SubParameter { get; set; }
        public decimal TotalParameterValue { get; set; }
        public int ServiceId { get; set; }
        public int Group { get; set; }
        public int IndicatorDetId { get; set; }
        public string IndicatorDesc { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
    }
}