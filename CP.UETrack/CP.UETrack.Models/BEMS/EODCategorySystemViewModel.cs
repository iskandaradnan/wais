using System;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class EODCategorySystemViewModel
    {
        public int CategorySystemId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string CategorySystemName { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public List<LovValue> ServiceData { get; set; }

    }
}
