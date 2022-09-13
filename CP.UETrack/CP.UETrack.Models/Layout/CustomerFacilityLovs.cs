using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model.Layout
{
    public class CustomerFacilityLovs
    {
        public List<LovValue> Customers { get; set; }
        public List<LovValue> Facilities { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string CustomerName { get; set; }
        public string FacilityName { get; set; }
        public int IsDevelopmentMode { get; set; }
        public string DateFormat { get; set; }
        public string Currency { get; set; }
        public int UserRoleId { get; set; }
        public string UserRoleName { get; set; }
        public int ThemeColorId { get; set; }
        public string ThemeColorName { get; set; }

        public int BEMS { get; set; }
        public int FEMS { get; set; }
        public int CLS { get; set; }
        public int LLS { get; set; }
        public int HWMS { get; set; }

    }
}
