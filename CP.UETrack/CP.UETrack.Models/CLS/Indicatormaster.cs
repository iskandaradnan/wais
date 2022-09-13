using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Models;

namespace CP.UETrack.Model.CLS
{
   public class IndicatorMaster
    {
        public int IndicatorMasterId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string IndicatorNo { get; set; }
        public string IndicatorName { get; set; }
        public decimal IndicatorStandard { get; set; }
        public List<IndicatorMaster> IndicatorMasterFetchList { get; set; }
    }
}
