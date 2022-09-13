using System;
using System.Security.Principal;

namespace CP.Framework.Security.Authentication.Models
{
    public class CustomPrincipal : IPrincipal
    {
        public CustomPrincipal(IIdentity identity)
        {
            Identity = identity;
        }

        public bool IsInRole(string role)
        {
            if (string.Compare(role, "admin", StringComparison.OrdinalIgnoreCase) == 0)
            {
                return (Identity.Name == "admin");
            }
            return false;
        }

        public IIdentity Identity
        {
            get;
            private set;
        }
    }
}