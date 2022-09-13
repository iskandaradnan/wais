using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Security;

namespace CP.Framework.Security.Authentication
{
    public static class Ticket
    {
        public static string CreateTicket(string userName, bool isPersistent)
        {
            var ticket = new FormsAuthenticationTicket(
                0,
                userName,
                DateTime.Now.ToLocalTime(),
                DateTime.Now.ToLocalTime().AddMinutes(FormsAuthentication.Timeout.Minutes),
                isPersistent,
                Guid.NewGuid().ToString("N"));


            // Encrypt the ticket.
            return FormsAuthentication.Encrypt(ticket);
        }
    }
}
