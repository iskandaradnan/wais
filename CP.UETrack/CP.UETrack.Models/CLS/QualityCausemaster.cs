using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Models;

namespace CP.UETrack.Model.CLS
{
    public class QualityCauseMaster {

        public int QualityCauseMasterId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string FailureSymptomCode { get; set; }
        public string Description { get; set; }
       
        public List<QualityCauseMasterFailure> FailureList { get; set; }
      
    }
    public class QualityCauseMasterFailure
    {
        public int QualityId { get; set; }
        public string FailureType { get; set; }
        public string FailureRootCauseCode { get; set; }
        public string Details { get; set; }
        public int Status { get; set; }
        public bool isDeleted { get; set; }
    }
    public class QualityCauseMasterDropdown
    {
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> FailureTypeLovs { get; set; }

    }
}
