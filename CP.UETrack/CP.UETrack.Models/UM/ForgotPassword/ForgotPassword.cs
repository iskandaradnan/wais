
using System;

namespace CP.UETrack.Model
{
    public class ForgotPassword
    {
        public string Username { get; set; }
        public string Password { get; set; }
        public string StaffName { get; set; }
        public string Email { get; set; }
        public string ErrorMessage { get; set; }
    }
}