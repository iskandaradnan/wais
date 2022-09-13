using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.UM
{
    public class UMTrackingTechnician
    {
        public int UserRegistrationId { get; set; }
        public int? StaffId { get; set; }
        public string StaffName { get; set; }
        public DateTime? DateTime { get; set; }
        public decimal Latitude { get; set; }
        public decimal Longitude { get; set; }
        public int ROWNUMBER { get; set; }




        
    }
}
