using System;
using System.Web.Security;

namespace CP.Framework.Common.StateManagement
{
    public static class MachineKeyCryptography
    {
        private const string Purpose = "Authentication Token";
        public static string Encode(string plaintextValue)
        {

            var unprotectedBytes = System.Text.Encoding.UTF8.GetBytes(plaintextValue);
            var protectedBytes = MachineKey.Protect(unprotectedBytes, Purpose);
            var protectedText = Convert.ToBase64String(protectedBytes);
            return protectedText;
        }

        public static string Decode(string protectedText)
        {
            var protectedBytes = Convert.FromBase64String(protectedText);
            var unprotectedBytes = MachineKey.Unprotect(protectedBytes, Purpose);
            var unprotectedText = System.Text.Encoding.UTF8.GetString(unprotectedBytes);
            return unprotectedText;
        }
    }
}
