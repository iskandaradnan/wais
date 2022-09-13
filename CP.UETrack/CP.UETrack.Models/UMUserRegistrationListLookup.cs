using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
    public class UMUserRegistrationListLookup
    {

      //  public List<UMUserRoleMappingMstViewModel> UserRoleMappingMst { get; set; }
        public int UserRegistrationId { get; set; }
        public int User { get; set; }
        public string LoginName { get; set; }
        public bool IsMobileUser { get; set; }
        public bool IsPasswordExpired { get; set; }
        public bool IsMobileUserFirstLogin { get; set; }
        public bool HasUMAccess { get; set; }
    }
}
