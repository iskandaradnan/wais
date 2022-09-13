namespace CP.UETrack.Model
{
    using Models;
    using System.Collections.Generic;
    public class UserRegistrationLovs
    {
        public List<LovValue> Genders { get; set; }
        public List<LovValue> UserTypes { get; set; }
        public List<LovValue> Statuses { get; set; }
        public List<LovValue> Customers { get; set; }
        public List<LovValue> UserRoles { get; set; }
        public List<LovValue> Locations { get; set; }

        public List<LovValue> Roles { get; set; }
        public List<LovValue> Designations { get; set; }
        public List<LovValue> Grades { get; set; }
        public List<LovValue> Competancies { get; set; }
        public List<LovValue> Deparatments { get; set; }
        public List<LovValue> Specialities { get; set; }
        public List<LovValue> AccessLevels { get; set; }
        public List<LovValue> Nationalities { get; set; }
        public List<LovValue> Services { get; set; }
        public int UserTypeId { get; set; }
    }
}
