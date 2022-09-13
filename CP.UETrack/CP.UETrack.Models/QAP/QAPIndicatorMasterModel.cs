using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.QAP
{
    public class QAPIndicatorMasterModel
    {
        public int QAPIndicatorId { get; set; }
        public int ServiceId { get; set; }
        public string IndicatorCode { get; set; }
        public string IndicatorNumber { get; set; }
        public string ServiceName { get; set; }
        public string Service { get; set; }
        public string IndicatorDescription { get; set; }
        public string ShortDescription { get; set; }
        public decimal IndicatorStandard { get; set; }
        public string Remarks { get; set; }
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
    public class QAPIndicatorTypeDropdown
    {
        public List<LovValue> IndicatorServiceTypeData { get; set; }        

    }
}
