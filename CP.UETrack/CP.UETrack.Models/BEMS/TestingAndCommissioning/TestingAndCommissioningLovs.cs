using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class TestingAndCommissioningLovs
    {
        public List<LovValue> TAndCTypes { get; set; }
        public List<LovValue> VariationStatus { get; set; }
        public List<LovValue> Services { get; set; }
        public List<LovValue> YesNoValues { get; set; }
        public List<LovValue> TAndCStatusValues { get; set; }
        public bool IsAdditionalFieldsExist { get; set; }
        public List<LovValue> TypeOfService { get; set; }
        public List<LovValue> BatchNo { get; set; }
    }
}