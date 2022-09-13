using System;

namespace CP.UETrack.Model
{
    using CP.UETrack.Models;
    using System.Collections.Generic;
    public class CompanyStaffMstDropdown
    {
        public List<LovValue> RoleData { get; set; }
        public List<LovValue> CompetencyData { get; set; }
        public List<LovValue> GradeData { get; set; }
        public List<LovValue> SpecialityData { get; set; }
        public List<LovValue> EmployeeTypeData { get; set; }
        public List<LovValue> GenderData { get; set; }
        public List<LovValue> NationalityData { get; set; }
    }
}
