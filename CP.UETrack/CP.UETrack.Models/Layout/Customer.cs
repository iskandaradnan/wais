using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model.Layout
{
    public class Customer
    {
        public List<LovValue> Customers { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
    }
}
