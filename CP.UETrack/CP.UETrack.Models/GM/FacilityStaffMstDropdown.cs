using System;

namespace CP.UETrack.Model
{
    using CP.UETrack.Models;
    using System.Collections.Generic;
    public class FacilityStaffMstDropdown
    {
        public List<LovValue> RoleData { get; set; }
        public List<LovValue> DepartmentData { get; set; }
        public List<LovValue> DesignationData { get; set; }
        public List<LovValue> GenderData { get; set; }
        public List<LovValue> NationalityData { get; set; }
    }
}
