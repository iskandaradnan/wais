//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace CP.UETrack.DAL.Model
{
    using System;
    using System.Collections.Generic;
    
    public partial class AsisUserRegistration
    {
        public AsisUserRegistration()
        {
           
        }
    
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public string UserName { get; set; }
        public string Password { get; set; }
        public Nullable<int> Gender { get; set; }
        public string PhoneNumber { get; set; }
        public string Email { get; set; }
        public Nullable<System.DateTime> DateofJoined { get; set; }
        public Nullable<int> UserTypeId { get; set; }
        public Nullable<bool> IsSystemUser { get; set; }
        public Nullable<bool> IsMobileUser { get; set; }
        public Nullable<bool> IsMailSent { get; set; }
        public Nullable<System.DateTime> MailSentTime { get; set; }
        public Nullable<int> ExpiryDuration { get; set; }
        public int LoginAttempt { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string SecurityCode { get; set; }
        public int Status { get; set; }
        public Nullable<bool> IsBlocked { get; set; }
        public Nullable<int> InvalidAttempts { get; set; }
        public Nullable<System.DateTime> InvalidAttemptDateTime { get; set; }
        public Nullable<System.DateTime> LoginDateTime { get; set; }
        public Nullable<System.DateTime> PasswordChangedDateTime { get; set; }
        public string MobileNumber { get; set; }
        public bool ExistingStaff { get; set; }
    
    }
}
