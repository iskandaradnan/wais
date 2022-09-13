using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class LoginViewModel 
    {
        public int UserId { get; set; }
        public int UserTypeId { get; set; }
        public int AccessLevel { get; set; }
        public string Email { get; set; }
        public string LoginName { get; set; }
        public string Password { get; set; }
        public bool RememberMe { get; set; }
        public bool IsBlocked { get; set; }
        public int InvalidAttempts { get; set; }   
        public int MaxInvalidAttempts { get; set; }   
        public int Status { get; set; }  
        public bool IsAlreadyLoggedIn { get; set; }
        public bool AllowMultipleLogins { get; set; }
        public string Language { get; set; }
        public bool IsSuccessReponse { get; set; }
        public List<LovValue> Customers { get; set; }
        public List<LovValue> Facilities { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public bool IsAuthenticated { get; set; }
        public DateTime? InvalidAttemptDateTime { get; set; }
        public string ErrorMessage { get; set; }
        public bool IsUserValid { get; set; }
        public string StaffName { get; set; }
        public bool IsValidCustomer { get; set; }

        public bool IsMultipleFacility { get; set; }
    }
}