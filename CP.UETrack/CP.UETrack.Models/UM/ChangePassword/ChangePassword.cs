
using System;

namespace CP.UETrack.Model
{
    public class ChangePassword
    {
        public int UserRegistrationId { get; set; }
        public string UserName { get; set; }
        public string OldPassword { get; set; }
        public string NewPassword { get; set; }
        public int UserId { get; set; }
        public string Timestamp { get; set; }
        public string Password { get; set; }
        public bool IsAuthenticated { get; set; }
        public bool IsFromLink { get; set; }
    }
}