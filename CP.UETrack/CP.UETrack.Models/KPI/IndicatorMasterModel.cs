using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.KPI
{
   public class IndicatorMasterModel
    {

        public int IndicatorId { get; set; }
        public int ServiceId { get; set; }
        public int Group { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public List<ItemIndicatorMasterList> IndicatorListData { get; set; }
       
    }
    public class IndicatorTypeDropdown
    {
        public List<LovValue> IndicatorServiceTypeData { get; set; }
        public List<LovValue> IndicatorGroupTypeData { get; set; }
        public List<LovValue> IndicatorFrequencyTypeData { get; set; }
        public List<ItemIndicatorMasterList> ItemData { get; set; }

    }

    public class ItemIndicatorMasterList
    {
        public int IndicatorDetId { get; set; }
        public int IndicatorId { get; set; }
        public string IndicatorNo { get; set; }
        public string IndicatorName { get; set; }
        public string IndicatorDesc { get; set; }
        public int IndicatorType { get; set; }
        public decimal Weightage { get; set; }
        public int Frequency { get; set; }
        public int ServiceId { get; set; }
        public int Group { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }

        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }

       
    }
}
